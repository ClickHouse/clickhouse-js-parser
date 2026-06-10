/**
 * Substitution of ClickHouse query parameters (`{name:Type}`) with placeholder
 * literals of a compatible type.
 *
 * ClickHouse's `EXPLAIN AST` — and therefore the reference-output generator that
 * feeds queries to `clickhouse` / a ClickHouse server — cannot parse a
 * statement that still contains unbound query parameters; it reports an error
 * (surfacing as `<AST Error>` / `<Query Parameters>` placeholders in the reference
 * files). Replacing each parameter with a literal of a compatible type lets the
 * statement parse so a real reference AST/explain can be captured.
 *
 * Both the generator and the reference tests must apply this *identical* transform:
 * the tests compare this library's parse of the transformed SQL against ClickHouse's
 * AST of the same transformed SQL, so the two must start from byte-identical input.
 */

/**
 * Replaces every ClickHouse query parameter (`{name:Type}`) that appears in SQL code
 * with a placeholder literal of a compatible type, leaving the rest of the string
 * byte-for-byte intact.
 *
 * Parameters inside string literals (`'{x:String}'`), backtick/double-quoted
 * identifiers, or comments are left untouched — ClickHouse treats those as ordinary
 * text rather than parameters. A `{...}` that is not a well-formed `name:Type`
 * parameter (e.g. a `Map` literal such as `{1: [2,3], 2: [4,5,6]}`) is also left as-is.
 *
 * The substituted literal depends on the parameter type so that it parses wherever the
 * parameter was valid:
 *   - `Identifier` → the parameter's own name as a bare identifier (e.g. `{tbl:Identifier}` → `tbl`)
 *   - numeric types (`Int*`, `UInt*`, `Float*`, `Decimal*`, `Bool`) → `0`
 *   - `Array(...)` → `[]`, `Map(...)` → `map()`, `Tuple(...)`/`Point` → `tuple()`
 *   - date/time, string, UUID, and IP types → a string literal of a representative value
 *   - anything else → `NULL`
 */
export function substituteQueryParameters(sql: string): string {
  let out = '';
  let i = 0;
  const n = sql.length;

  while (i < n) {
    const ch = sql[i];

    // Single-quoted string literal — copy verbatim, honoring `''` and `\'` escapes.
    if (ch === "'") {
      const start = i++;
      while (i < n) {
        if (sql[i] === '\\') {
          i += 2;
          continue;
        }
        if (sql[i] === "'") {
          if (sql[i + 1] === "'") {
            i += 2;
            continue;
          }
          i++;
          break;
        }
        i++;
      }
      out += sql.slice(start, i);
      continue;
    }

    // Backtick- or double-quoted identifier — copy verbatim.
    if (ch === '`' || ch === '"') {
      const start = i++;
      while (i < n && sql[i] !== ch) i++;
      i++; // consume the closing quote (if any)
      out += sql.slice(start, Math.min(i, n));
      continue;
    }

    // Line comment `-- ...` — copy to end of line.
    if (ch === '-' && sql[i + 1] === '-') {
      const nl = sql.indexOf('\n', i);
      const end = nl === -1 ? n : nl;
      out += sql.slice(i, end);
      i = end;
      continue;
    }

    // Block comment `/* ... */` — copy through the close.
    if (ch === '/' && sql[i + 1] === '*') {
      const close = sql.indexOf('*/', i + 2);
      const end = close === -1 ? n : close + 2;
      out += sql.slice(i, end);
      i = end;
      continue;
    }

    // Potential query parameter `{name:Type}`.
    if (ch === '{') {
      const param = tryParseQueryParameter(sql, i);
      if (param) {
        out += literalForType(param.name, param.type);
        i = param.end;
        continue;
      }
    }

    out += ch;
    i++;
  }

  return out;
}

interface ParsedParameter {
  name: string;
  type: string;
  /** Index just past the closing `}`. */
  end: number;
}

const WHITESPACE = /\s/;
const IDENT_START = /[A-Za-z_]/;
const IDENT_CHAR = /[A-Za-z0-9_]/;

/**
 * Attempts to read a query parameter `{name:Type}` starting at `sql[start]` (which must
 * be `{`). Returns the parsed parameter and the index past its closing `}`, or `null`
 * if the braces do not enclose a well-formed `name:Type` parameter.
 *
 * The type is read up to the matching `}` while tracking parenthesis depth. To avoid
 * mistaking a `Map` literal (`{1: ...}`, `{a: 1, b: 2}`) for a parameter, the name must
 * be a valid identifier and the type, at parenthesis depth 0, must contain no comma,
 * colon, bracket, brace, or quote (commas inside a type's own parentheses, e.g.
 * `Map(UUID, Array(Float32))`, are fine).
 */
function tryParseQueryParameter(sql: string, start: number): ParsedParameter | null {
  const n = sql.length;
  let i = start + 1;

  while (i < n && WHITESPACE.test(sql[i])) i++;

  if (i >= n || !IDENT_START.test(sql[i])) return null;
  const nameStart = i;
  while (i < n && IDENT_CHAR.test(sql[i])) i++;
  const name = sql.slice(nameStart, i);

  while (i < n && WHITESPACE.test(sql[i])) i++;
  if (sql[i] !== ':') return null;
  i++;
  while (i < n && WHITESPACE.test(sql[i])) i++;

  const typeStart = i;
  let depth = 0;
  while (i < n) {
    const c = sql[i];
    if (c === '(') {
      depth++;
    } else if (c === ')') {
      if (depth === 0) return null;
      depth--;
    } else if (c === '}') {
      if (depth !== 0) return null;
      break;
    } else if (depth === 0 && (c === ',' || c === ':' || c === '[' || c === ']' || c === '{')) {
      return null;
    } else if (c === "'" || c === '`' || c === '"') {
      return null;
    }
    i++;
  }
  if (i >= n) return null; // no closing `}`

  const type = sql.slice(typeStart, i).trim();
  if (!IDENT_START.test(type)) return null;

  return { name, type, end: i + 1 };
}

/** Returns a placeholder literal of a type compatible with the parameter's type. */
function literalForType(name: string, type: string): string {
  // Unwrap transparent type wrappers so the inner type drives the literal.
  let base = type;
  for (;;) {
    const m = /^(?:Nullable|LowCardinality)\s*\((.*)\)$/i.exec(base);
    if (!m) break;
    base = m[1].trim();
  }

  const baseName = (/^[A-Za-z_][A-Za-z0-9_]*/.exec(base) ?? [''])[0].toLowerCase();

  if (baseName === 'identifier') return name;

  if (
    /^u?int(8|16|32|64|128|256)?$/.test(baseName) ||
    /^float(32|64)?$/.test(baseName) ||
    baseName.startsWith('decimal') ||
    baseName === 'bool' ||
    baseName === 'boolean'
  ) {
    return '0';
  }

  if (baseName === 'array' || baseName === 'qbit') return '[]';
  if (baseName === 'map') return 'map()';
  if (baseName === 'tuple' || baseName === 'point') return 'tuple()';

  if (baseName === 'date' || baseName === 'date32') return "'2020-01-01'";
  if (baseName === 'datetime' || baseName === 'datetime64') return "'2020-01-01 00:00:00'";
  if (baseName === 'uuid') return "'00000000-0000-0000-0000-000000000000'";
  if (baseName === 'ipv4') return "'0.0.0.0'";
  if (baseName === 'ipv6') return "'::'";
  if (baseName === 'string' || baseName === 'fixedstring' || baseName.startsWith('enum')) {
    // A non-empty placeholder: an empty string is more likely to trip "falsy means
    // absent" handling in downstream formatting (e.g. an empty password clause).
    return "'placeholder'";
  }

  return 'NULL';
}
