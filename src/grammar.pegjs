// ClickHouse SQL Grammar
{{
  // Keywords that cannot be used as bare identifiers
  const KEYWORDS = new Set([
    'SELECT', 'FROM', 'PREWHERE', 'WHERE', 'GROUP', 'HAVING', 'ORDER', 'BY',
    'LIMIT', 'OFFSET', 'WITH', 'ASC', 'AS', 'AND', 'OR', 'DESC',
    'NULL', 'NOT', 'INTERSECT', 'INTO', 'IN', 'DISTINCT', 'JOIN', 'ON', 'USING', 'FINAL',
    'SETTINGS', 'UNION', 'ILIKE', 'LIKE', 'BETWEEN',
    'EXCEPT', 'WINDOW', 'OVER', 'QUALIFY', 'SAMPLE',
  ]);

  // Reserved keywords that ClickHouse nonetheless accepts as an *implicit* (no-AS)
  // alias. These are the subset of KEYWORDS that are NOT in ClickHouse's ParserAlias
  // "restricted keywords" list and are not structural modifiers consumed earlier by
  // expression / FINAL / window parsing. Determined empirically against the
  // `clickhouse` binary (e.g. `SELECT a DESC FROM t` aliases `a` as `DESC`;
  // `SELECT x FROM t BY` aliases the table as `BY`).
  //
  // Column vs table position differ:
  //  - `SELECT` is a valid column alias (`SELECT a SELECT FROM t`). As a table alias
  //    it is handled specially (see TableImplicitAlias) because a bare `SELECT`
  //    after a table also begins the FROM-first form `FROM numbers(1) SELECT x`.
  //  - Operator keywords AND/OR/IN can be table aliases (`SELECT x FROM t AND`) but
  //    never column aliases (in expression position they are consumed as operators).
  const COLUMN_IMPLICIT_ALIAS_KEYWORDS = new Set([
    'BY', 'ASC', 'DESC', 'NULL', 'DISTINCT', 'OVER', 'SELECT',
  ]);
  const TABLE_IMPLICIT_ALIAS_KEYWORDS = new Set([
    'BY', 'ASC', 'DESC', 'NULL', 'DISTINCT', 'OVER', 'AND', 'OR', 'IN',
  ]);

  // Flatten a whitespace result { trailing: [...], leading: [...] } into a single array
  function flattenWs(ws) {
    return ws.trailing.concat(ws.leading);
  }

  // Prepend comments to a node's leadingComments (no-op if empty)
  function addLeading(node, comments) {
    if (comments.length > 0) {
      return { ...node, leadingComments: [...comments, ...(node.leadingComments || [])] };
    }
    return node;
  }

  // Append comments to a node's trailingComments (no-op if empty)
  function addTrailing(node, comments) {
    if (comments.length > 0) {
      return { ...node, trailingComments: [...(node.trailingComments || []), ...comments] };
    }
    return node;
  }

  // Shorthand: flatten a whitespace result and prepend as leading comments
  function addWsLeading(node, ws) {
    return addLeading(node, flattenWs(ws));
  }

  // Attach leading and trailing comments from surrounding whitespace (e.g., parenthesized queries)
  function addSurroundingWs(node, beforeWs, afterWs) {
    return addTrailing(addLeading(node, flattenWs(beforeWs)), flattenWs(afterWs));
  }

  // Build a comma-separated list with comment distribution:
  //   ws before comma → all comments go to leading on next item
  //   ws after comma → .trailing goes to trailing on prev item, .leading goes to leading on next
  function buildCommaList(head, tail, itemIndex = 3) {
    const items = [head];
    for (const t of tail) {
      const ws1 = t[0]; // before comma
      const ws2 = t[2]; // after comma
      items[items.length - 1] = addTrailing(items[items.length - 1], ws2.trailing);
      items.push(addLeading(t[itemIndex], [...flattenWs(ws1), ...ws2.leading]));
    }
    return items;
  }

  // ── ClickHouse-native node construction ─────────────────────────────────────

  // Maps operator tokens to ClickHouse function names.
  const OP_TO_FUNCTION = {
    AND: 'and',
    OR: 'or',
    '>': 'greater',
    '<': 'less',
    '>=': 'greaterOrEquals',
    '<=': 'lessOrEquals',
    '=': 'equals',
    '==': 'equals',
    '!=': 'notEquals',
    '<>': 'notEquals',
    '+': 'plus',
    '-': 'minus',
    '*': 'multiply',
    '/': 'divide',
    '%': 'modulo',
    DIV: 'intDiv',
    MOD: 'modulo',
    '<=>': 'isNotDistinctFrom',
    'IS DISTINCT FROM': 'isDistinctFrom',
  };

  // Function-name aliases ClickHouse normalizes in its AST. The source
  // spelling is not preserved — alias and case variants canonicalize to the
  // canonical spelling on the right-hand side.
  const FUNC_ALIASES = {
    cast: 'CAST',
    datediff: 'dateDiff',
    ltrim: 'trimLeft',
    rtrim: 'trimRight',
    trim: 'trimBoth',
    exists: 'exists',
    grouping: 'grouping',
    substring: 'substring',
    extract: 'extract',
    position: 'position',
  };

  // Build a Function node. view()/viewIfPermitted() arguments unwrap their
  // Subquery node — ClickHouse stores the query directly.
  function fn(name, args, extra) {
    let actualArgs = args;
    const lower = typeof name === 'string' ? name.toLowerCase() : '';
    if ((lower === 'view' || lower === 'viewifpermitted') && args.length >= 1) {
      actualArgs = args.map((a, i) =>
        i === 0 && a !== null && a.type === 'Subquery' && a.alias === undefined ? a.query : a,
      );
    }
    const node = { type: 'Function', name, arguments: actualArgs };
    if (extra) Object.assign(node, extra);
    return node;
  }

  // Build a Function node for an operator token (sets is_operator: true).
  // The function name comes from OP_TO_FUNCTION; format() recovers the
  // canonical token by looking up the name in FN_TO_OP.
  function opFn(op, args, extra) {
    return fn(OP_TO_FUNCTION[op] !== undefined ? OP_TO_FUNCTION[op] : op, args, {
      is_operator: true,
      ...extra,
    });
  }

  // Build a Literal node. Numeric `value` is stored in ClickHouse's native
  // form — a decimal-digit string for UInt64/Int64 (lossless) and a JS
  // number for Float64; the original source spelling is not retained.
  function lit(value_type, value, extra) {
    const node = { type: 'Literal', value_type, value };
    if (extra) Object.assign(node, extra);
    return node;
  }

  function strLit(decoded, extra) {
    return lit('String', decoded, extra);
  }

  // UInt64 literal from normalized digit text ('123', '0x1f', '0b101').
  // `value` is the canonical decimal-digit string, matching ClickHouse's
  // `EXPLAIN AST json=1` output, so values beyond `Number.MAX_SAFE_INTEGER`
  // (up to UInt64 max) round-trip without precision loss. Hex/binary input
  // normalizes to decimal (`0xFF` → `255`).
  function uintLit(raw, extra) {
    return lit('UInt64', normalizeUInt(raw), extra);
  }

  // Int64 literal from (possibly negative) decimal digit text.
  // `value` is the canonical decimal-digit string, matching ClickHouse's
  // `EXPLAIN AST json=1` output, so values outside Int64-safe Number range
  // round-trip without precision loss.
  function intLit(raw, extra) {
    return lit('Int64', raw, extra);
  }

  // Float64 literal from float text ('1.5', '1e10', 'inf', 'nan'). `value`
  // is the IEEE double (a lossy JS number). Two forms cannot be recovered
  // from the native AST's `value`: non-finite values collapse to `null`, and
  // negative zero collapses to `0`. Both are recorded in a library-only
  // `nonfinite` discriminator so format()/formatExplain() can reproduce them.
  function floatLit(raw, extra) {
    const v = floatValue(raw);
    const node = lit('Float64', v, extra);
    if (v === null) node.nonfinite = nonfiniteToken(raw);
    else if (v === 0 && Object.is(Number(raw), -0)) node.nonfinite = '-0';
    return node;
  }

  // Classify a non-finite float token into one of the four JSON-unrepresentable
  // forms ClickHouse spells. `raw` here is already known to be non-finite.
  function nonfiniteToken(raw) {
    const neg = raw.charAt(0) === '-' ? '-' : '';
    return neg + (/nan/i.test(raw) ? 'nan' : 'inf');
  }

  function floatValue(raw) {
    // Non-finite floats serialize as null in ClickHouse's AST JSON; -0 as 0
    if (raw === 'inf' || raw === '-inf' || raw === 'nan' || raw === '-nan') return null;
    const n = Number(raw);
    if (Number.isFinite(n) === false) return null;
    return n === 0 ? 0 : n;
  }

  function normalizeUInt(value) {
    if (value.startsWith('0x') || value.startsWith('0X') || value.startsWith('0b') || value.startsWith('0B')) {
      return BigInt(value).toString();
    }
    return value;
  }

  // Negate a Literal's `value` field, preserving its native shape: UInt64/
  // Int64 are decimal-digit strings (use BigInt for precision), Float64 is
  // a JS number (non-finite `null` is left untouched — see `negateNumericLit`
  // for the `nonfinite` flip). Used by the `::` cast-fold negation path;
  // other literal types should never reach this helper.
  function negateLitValue(node) {
    if (node.value_type === 'UInt64' || node.value_type === 'Int64') {
      return String(-BigInt(node.value));
    }
    if (typeof node.value === 'number') {
      const n = -node.value;
      return n === 0 ? 0 : n;
    }
    return node.value;
  }

  // True for a non-negative UInt64/Int64/Float64 literal — the cases the
  // unary-minus folder may negate in place (mirrors the old `_raw[0] !== '-'`
  // guard now that source spelling is gone).
  function isNonNegNumericLit(n) {
    if (n.type !== 'Literal') return false;
    if (n.value_type !== 'UInt64' && n.value_type !== 'Int64' && n.value_type !== 'Float64') {
      return false;
    }
    if (n.nonfinite !== undefined) return n.nonfinite.charAt(0) !== '-';
    if (typeof n.value === 'number') return !(n.value < 0);
    return n.value.charAt(0) !== '-';
  }

  // Return a negated copy of a numeric literal. For Float64 this also flips
  // the `nonfinite` sign discriminator: inf↔-inf, nan↔-nan, +0↔-0 (the cases
  // `value` alone can't represent).
  function negateNumericLit(n) {
    const out = { ...n, value: negateLitValue(n) };
    if (n.value_type === 'Float64') {
      if (n.nonfinite !== undefined) {
        const flipped = n.nonfinite === '-0'
          ? undefined
          : n.nonfinite.charAt(0) === '-'
            ? n.nonfinite.substring(1)
            : '-' + n.nonfinite;
        if (flipped === undefined) delete out.nonfinite;
        else out.nonfinite = flipped;
      } else if (out.value === 0) {
        // Negating +0 yields -0.
        out.nonfinite = '-0';
      }
    }
    return out;
  }

  // Canonical Float64 spelling reconstructed from a finite JS number, matching
  // ClickHouse's `Field` dump: integral magnitudes always get a trailing dot
  // ("1." / "100000000000000000000."); values whose shortest form already
  // carries a fraction or exponent are emitted as-is.
  function floatNumText(v) {
    const s = String(v).replace('e+', 'e');
    return /[.eE]/.test(s) ? s : s + '.';
  }

  // Plain dump form of a Float64 literal node. Non-finite values (`value` is
  // null) come from `nonfinite`; `nan`/`-nan` both dump as `nan`.
  function floatDump(node) {
    if (node.value === null) {
      return node.nonfinite === 'nan' || node.nonfinite === '-nan' ? 'nan' : node.nonfinite;
    }
    if (node.nonfinite === '-0') return '-0.';
    return floatNumText(node.value);
  }


  // Display form of an identifier part (plain string or QueryParameter node).
  function partName(part) {
    return typeof part === 'string' ? part : '{' + part.name + ':' + part.param_type + '}';
  }

  // ClickHouse normalizes JSON subcolumn path parts: `^name` backquotes the
  // name, `name[]` desugars to two parts (`name`, ':`Array(JSON)`').
  function normalizeIdentPart(part) {
    if (typeof part !== 'string') return [part];
    if (part.startsWith('^')) return ['^`' + part.slice(1) + '`'];
    if (part.endsWith('[]')) return [part.slice(0, -2), ':`Array(JSON)`'];
    return [part];
  }

  // Build an Identifier node from a list of parts. `name_parts` is included
  // only for compound names, matching ClickHouse's serialization. Source-form
  // sugar (`^a`, `a[]`) is normalized into the canonical `name_parts` shape
  // (`^`a``, `a` + `:`Array(JSON)``); the formatter re-emits the source form
  // by recognizing those structurally encoded parts (see `renderIdentPart`
  // in `src/format.ts`).
  function ident(parts) {
    const normalized = parts.flatMap(normalizeIdentPart);
    if (normalized.length === 1 && typeof normalized[0] === 'string') {
      return { type: 'Identifier', name: normalized[0] };
    }
    return { type: 'Identifier', name: normalized.map(partName).join('.'), name_parts: normalized };
  }

  // ident() carrying a source location — used for DDL name identifiers (table /
  // database / index / column names) built from target temps that captured a
  // span via `loc()`. `l` is typically the enclosing target temp's location.
  // Defined lazily below `withLoc`/`loc`; here it forwards to the global helper.
  function identLoc(parts, l) {
    const node = ident(parts);
    if (l !== undefined && node.location === undefined) node.location = l;
    return node;
  }

  // Apply an inline alias to an expression node.
  function applyAlias(node, alias) {
    return { ...node, alias };
  }

  // Escape a decoded string for ClickHouse's quoted dump / explain label form.
  // \a (0x07), \v (0x0B), and \e (0x1B) control chars pass through unescaped,
  // matching ClickHouse EXPLAIN output.
  function escapeDecoded(value) {
    return value
      .replace(/\\/g, '\\\\')
      .replace(/'/g, "\\'")
      .replace(/\x08/g, '\\b')
      .replace(/\t/g, '\\t')
      .replace(/\n/g, '\\n')
      .replace(/\r/g, '\\r')
      .replace(/\f/g, '\\f')
      .replace(/\0/g, '\\0');
  }

  // ── Literal Array/Tuple typed-element model ──────────────────────────────────
  // ClickHouse serializes all-literal array/tuple syntax as a single Literal
  // node whose `value` is the list of its elements, each a {value_type, value}
  // object (recursively for nested Array/Tuple, with `nonfinite` carried for
  // non-finite/`-0` Float64 elements). Elements that can't be folded force the
  // Function array/tuple form instead.

  // True when `node` is an operator-form array/tuple function (the collection
  // literals that fold into typed-element form). `name`, when given, restricts
  // to 'array' or 'tuple'.
  function isOpCollection(node, name) {
    return (
      node != null &&
      node.type === 'Function' &&
      node.is_operator === true &&
      (name !== undefined ? node.name === name : node.name === 'array' || node.name === 'tuple')
    );
  }

  // Build a {value_type, value} element from a foldable literal node, or null
  // when the node is not a foldable literal. `allowNested` selects which
  // collection type is permitted as an element: 'array' allows nested Array
  // (not Tuple), 'tuple' allows nested Tuple (not Array).
  function litElem(node, allowNested) {
    if (node.parenthesized) return null;
    if (node.alias !== undefined) return null;
    if (node.type !== 'Literal') return null;
    switch (node.value_type) {
      case 'String':
      case 'Null':
      case 'Bool':
      case 'Float64':
      case 'Int64':
      case 'UInt64':
        break;
      case 'Array':
        if (allowNested !== 'array') return null;
        break;
      case 'Tuple':
        if (allowNested !== 'tuple') return null;
        break;
      default:
        return null;
    }
    const el = { value_type: node.value_type, value: node.value };
    if (node.nonfinite !== undefined) el.nonfinite = node.nonfinite;
    return el;
  }

  // Element of an IN value list: scalars plus a non-parenthesized nested Tuple;
  // arrays force the Function tuple form.
  function inElem(node) {
    if (node.type === 'Literal' && node.value_type === 'Array') return null;
    if (node.type === 'Literal' && node.value_type === 'Tuple') {
      return litElem(node, 'tuple');
    }
    return litElem(node, 'array');
  }

  // Rebuild a Literal Array/Tuple element ({value_type, value, nonfinite?})
  // into a Literal Expression node (used when a folded Literal collection must
  // be expanded back into Function array/tuple arguments).
  function elemToExpr(el) {
    const extra = el.nonfinite !== undefined ? { nonfinite: el.nonfinite } : undefined;
    return lit(el.value_type, el.value, extra);
  }

  // Build the node for an array literal: Literal Array when all elements are
  // foldable, Function array otherwise. Empty arrays use the Function form.
  function arrayNode(elements) {
    if (elements.length > 0) {
      const els = elements.map((e) => litElem(e, 'array'));
      if (els.every((d) => d !== null)) {
        return lit('Array', els);
      }
    }
    return fn('array', elements, { is_operator: true });
  }

  // Build the node for a tuple literal (2+ elements or trailing-comma form).
  function tupleNode(elements) {
    const els = elements.map((e) => litElem(e, 'tuple'));
    if (elements.length > 0 && els.every((d) => d !== null)) {
      return lit('Tuple', els);
    }
    return fn('tuple', elements, { is_operator: true });
  }

  // Convert a Literal Array/Tuple back to its Function array/tuple form.
  function tupleAsFunction(node) {
    if (node.type !== 'Literal' || (node.value_type !== 'Tuple' && node.value_type !== 'Array')) {
      return node;
    }
    const isTuple = node.value_type === 'Tuple';
    const elems = Array.isArray(node.value) ? node.value.map(elemToExpr) : [];
    const result = fn(isTuple ? 'tuple' : 'array', elems, {
      is_operator: true,
    });
    if (node.location !== undefined) result.location = node.location;
    if (node.alias !== undefined) result.alias = node.alias;
    return result;
  }

  // Build the right-hand side of an IN expression from its parsed target.
  function inRhs(values) {
    if (!Array.isArray(values)) return values; // Subquery node
    if (values.length === 1) {
      const single = values[0];
      // A single tuple literal value is wrapped in Function tuple.
      if (single.type === 'Literal' && single.value_type === 'Tuple') {
        return withLoc(fn('tuple', [single], { is_operator: true }), spanOf([single]));
      }
      return single;
    }
    const els = values.map(inElem);
    if (els.every((d) => d !== null)) {
      return withLoc(lit('Tuple', els), spanOf(values));
    }
    return withLoc(fn('tuple', values, { is_operator: true }), spanOf(values));
  }

  // Build a Settings node from SETTINGS items. `SET x = DEFAULT` resets go to
  // default_settings; everything else collapses into the `changes` map (which
  // matches ClickHouse's native AST shape: keys de-duplicate to the last
  // occurrence, and complex expression values are flattened to their scalar
  // form via settingChangeValue / exprToCompactText). Query parameters
  // (`SET param_x = ...`) are NOT in ClickHouse's native AST at all — the
  // reference dumps them as a bare `{type: 'Settings'}` — but we keep them in
  // `changes` so the formatter can re-emit them. The reference-AST test
  // strips library-only `param_*` keys before comparing.
  function setNode(items, typeName) {
    const changes = {};
    const changeValueTypes = {};
    const defaults = [];
    let hasChanges = false;
    for (const item of items) {
      const v = item.value;
      if (v.type === 'Identifier' && v.name_parts === undefined && v.name.toUpperCase() === 'DEFAULT') {
        defaults.push(item.name);
        continue;
      }
      const decoded = settingChangeValue(v);
      changes[item.name] = decoded;
      // Record the numeric literal type for format(), but only when the decoded
      // value is non-null: non-finite Float64 values serialize as null, which
      // format() re-emits as `NULL` (losing the Float64 tag), so tracking the
      // type there would break round-trips.
      if (
        decoded !== null &&
        v.type === 'Literal' &&
        (v.value_type === 'UInt64' || v.value_type === 'Int64' || v.value_type === 'Float64')
      ) {
        changeValueTypes[item.name] = v.value_type;
      } else {
        // A later non-numeric occurrence of the same setting overrides the
        // value, so drop any stale numeric-type tag from an earlier one.
        delete changeValueTypes[item.name];
      }
      hasChanges = true;
    }
    const node = { type: typeName || 'Settings' };
    if (hasChanges) node.changes = changes;
    if (Object.keys(changeValueTypes).length > 0) node.change_value_types = changeValueTypes;
    if (defaults.length > 0) node.default_settings = defaults;
    return withLoc(node, spanOf(items) ?? spanOf(items.map((i) => i.value)));
  }

  // The plain scalar a setting value serializes to in Set.changes. ClickHouse's
  // native JSON emits numeric setting values as strings (for example
  // `enable_positional_arguments = 1` -> `{ "enable_positional_arguments": "1" }`).
  function settingChangeValue(node) {
    if (node.type === 'Literal') {
      if (node.value_type === 'String') return node.value;
      if (node.value_type === 'Bool') return node.value;
      if (node.value_type === 'Null') return null;
      if (node.value === null && node.value_type !== 'Array' && node.value_type !== 'Tuple')
        return null;
      // ClickHouse serializes integer setting values (UInt64 / Int64) as
      // decimal strings, but float setting values (Float64) as JSON numbers.
      if (node.value_type === 'UInt64' || node.value_type === 'Int64') {
        return String(node.value);
      }
      if (node.value_type === 'Float64') {
        return node.value;
      }
      // Array setting values that are a list of 2-tuples serialize as a map
      // object ({key: {value_type, value}}); other Array/Tuple values keep
      // their typed-element list (`node.value`).
      if (node.value_type === 'Array') {
        return tupleListToMap(node.value) ?? node.value;
      }
      if (node.value_type === 'Tuple') {
        return node.value;
      }
      return typeof node.value === 'number' ? node.value : String(node.value);
    }
    if (node.type === 'Identifier') return node.name;
    // `map(...)`-valued settings serialize directly as a map object.
    if (node.type === 'Function' && node.name === 'map') {
      return mapPairsToObject(node.arguments || []);
    }
    // Array/tuple-valued settings serialize as a typed-element list, then
    // collapse to a map object when every element is a 2-tuple.
    const list = settingValueList(node);
    if (list !== null) return tupleListToMap(list) ?? list;
    // Fall back to a compact source-text serialization for other complex
    // values (e.g. `disk = disk(...)`), matching ClickHouse's stringified form.
    return exprToCompactText(node);
  }

  // Convert one setting value expression into its {value_type, value} typed
  // element, or null when it has no typed Field representation.
  function settingElement(node) {
    if (node.type === 'Literal') {
      return { value_type: node.value_type, value: node.value };
    }
    if (isOpCollection(node, 'array')) {
      return { value_type: 'Array', value: (node.arguments || []).map(settingElement) };
    }
    if (isOpCollection(node, 'tuple')) {
      return { value_type: 'Tuple', value: (node.arguments || []).map(settingElement) };
    }
    if (node.type === 'Function' && node.name === 'map') {
      // Nested maps (inside a setting's value) keep the array-of-tuples
      // element form; only the top-level setting value becomes a map object.
      return { value_type: 'Array', value: mapPairsToTuples(node.arguments || []) };
    }
    return null;
  }

  // map(k1, v1, k2, v2, ...) -> [Tuple(k1, v1), Tuple(k2, v2), ...] elements.
  function mapPairsToTuples(args) {
    const pairs = [];
    for (let i = 0; i + 1 < args.length; i += 2) {
      pairs.push({ value_type: 'Tuple', value: [settingElement(args[i]), settingElement(args[i + 1])] });
    }
    return pairs;
  }

  // map(k1, v1, ...) -> { keyText: {value_type, value} } map object for a
  // Map-typed setting value.
  function mapPairsToObject(args) {
    const obj = {};
    for (let i = 0; i + 1 < args.length; i += 2) {
      obj[settingKeyText(settingElement(args[i]))] = settingElement(args[i + 1]);
    }
    return obj;
  }

  // Collapse a typed-element list whose every entry is a 2-tuple into a map
  // object { keyText: valueElement }, or null when it is not such a list.
  function tupleListToMap(list) {
    if (!Array.isArray(list) || list.length === 0) return null;
    const obj = {};
    for (const el of list) {
      if (!el || el.value_type !== 'Tuple' || !Array.isArray(el.value) || el.value.length !== 2)
        return null;
      obj[settingKeyText(el.value[0])] = el.value[1];
    }
    return obj;
  }

  // String form of a map key element (object keys are always strings in JSON).
  function settingKeyText(el) {
    return el === null || el === undefined || el.value === null ? '' : String(el.value);
  }

  // Typed-element list for an array/tuple-valued setting, or null otherwise.
  function settingValueList(node) {
    return isOpCollection(node) ? (node.arguments || []).map(settingElement) : null;
  }

  // Compact SQL-like serialization of an expression, used for setting values
  // whose ClickHouse-side representation is a free-form string (e.g.
  // `additional_table_filters`, `disk = disk(...)`).
  function exprToCompactText(node) {
    if (node === null || node === undefined) return '';
    if (node.type === 'Literal') {
      if (node.value_type === 'String') return "'" + escapeDecoded(String(node.value)) + "'";
      if (node.value_type === 'Bool') return node.value ? 'true' : 'false';
      if (node.value_type === 'Null') return 'NULL';
      if (node.value === null) return 'NULL';
      if (node.value_type === 'Float64') return floatDump(node);
      return String(node.value);
    }
    if (node.type === 'Identifier') return node.name;
    if (node.type === 'Function') {
      const args = (node.arguments || []).map(exprToCompactText);
      if (node.name === 'array') return '[' + args.join(', ') + ']';
      if (node.name === 'tuple') return '(' + args.join(', ') + ')';
      // `map(k1, v1, k2, v2, ...)` → `[(k1, v1), (k2, v2), ...]` — ClickHouse
      // normalizes Map(String, String) setting values into their array-of-
      // tuples canonical form for the Set.changes JSON entry.
      if (node.name === 'map' && args.length % 2 === 0) {
        const pairs = [];
        for (let i = 0; i < args.length; i += 2) {
          pairs.push('(' + args[i] + ', ' + args[i + 1] + ')');
        }
        return '[' + pairs.join(', ') + ']';
      }
      if (node.is_operator && node.name === 'equals' && args.length === 2) {
        return args[0] + ' = ' + args[1];
      }
      return node.name + '(' + args.join(', ') + ')';
    }
    return '';
  }

  // Typed `{value_type, value}` form of a NAMED COLLECTION / WORKLOAD setting
  // value, mirroring ClickHouse's reference AST. A literal keeps its native
  // `value_type`/`value`; any other expression (e.g. `disk(...)`) serializes to
  // a `CustomType` whose value is the compact SQL text.
  function typedSettingValue(node) {
    if (node.type === 'Literal') {
      return { value_type: node.value_type, value: node.value };
    }
    return { value_type: 'CustomType', value: exprToCompactText(node) };
  }

  // Normalize a type name to ClickHouse's canonical plain display form (no
  // string escaping — that happens at dump/label time).
  function normalizeTypeNamePlain(type) {
    let result = '';
    let inString = false;
    const s = type.replace(/\s+/g, ' ').trim();
    for (let i = 0; i < s.length; i++) {
      const ch = s[i];
      if (inString) {
        result += ch;
        if (ch === "'") inString = false;
      } else {
        if (ch === "'") {
          result += ch;
          inString = true;
        } else if (ch === '(' || ch === ')') {
          result = result.trimEnd();
          if (ch === ')' && result.endsWith(',')) result = result.slice(0, -1).trimEnd();
          result += ch;
          if (i + 1 < s.length && s[i + 1] === ' ') i++;
        } else if (ch === ',') {
          result = result.trimEnd();
          result += ', ';
          if (i + 1 < s.length && s[i + 1] === ' ') i++;
        } else if (ch === '=' && result.length > 0 && /[\w']/.test(result[result.length - 1])) {
          result = result.trimEnd() + ' = ';
          if (i + 1 < s.length && s[i + 1] === ' ') i++;
        } else {
          result += ch;
        }
      }
    }
    return quoteJsonPaths(result).replace(/\bTuple\(\)/g, 'Tuple');
  }

  // In JSON type specs, unquoted dotted paths followed by a type name need
  // backtick quoting: JSON(a.b.c Bool) → JSON(`a.b.c` Bool).
  function quoteJsonPaths(s) {
    let result = '';
    let i = 0;
    while (i < s.length) {
      const idx = s.indexOf('JSON(', i);
      if (idx === -1) {
        result += s.slice(i);
        break;
      }
      result += s.slice(i, idx + 5);
      i = idx + 5;
      let depth = 1;
      const start = i;
      while (i < s.length && depth > 0) {
        if (s[i] === '(') depth++;
        else if (s[i] === ')') depth--;
        i++;
      }
      const inner = s.slice(start, i - 1);
      result += quoteJsonInner(inner) + ')';
    }
    return result;
  }

  function quoteJsonInner(inner) {
    const parts = [];
    let depth = 0;
    let start = 0;
    for (let i = 0; i < inner.length; i++) {
      const ch = inner[i];
      if (ch === '(' || ch === '[') depth++;
      else if (ch === ')' || ch === ']') depth--;
      else if (ch === ',' && depth === 0) {
        parts.push(inner.slice(start, i).trim());
        start = i + 1;
      }
    }
    parts.push(inner.slice(start).trim());

    const processed = parts.map((part) => {
      if (/^SKIP\s|^REGEXP\s|^\w+ *=/.test(part)) return part;
      const m = part.match(/^([a-zA-Z_%][a-zA-Z0-9_%.]*)(\s+.+)$/);
      if (m && m[1].includes('.')) {
        return '`' + m[1] + '`' + m[2];
      }
      return part;
    });

    return processed.join(', ');
  }

  // Build an EXCEPT column transformer from a list of column names.
  function exceptTransformer(cols, strict, l) {
    const node = { type: 'ColumnsExceptTransformer' };
    if (strict) node.is_strict = true;
    node.columns = cols.map((c) => withLoc(ident([c]), l));
    return withLoc(node, l);
  }

  // Build an APPLY column transformer from the applied expression.
  function applyTransformer(func, l) {
    const node = { type: 'ColumnsApplyTransformer' };
    if (func.type === 'Identifier') {
      node.func_name = func.name;
    } else if (func.type === 'Function' && (func.is_lambda_function || func.name === 'lambda')) {
      const params = func.arguments[0];
      // Mark `lambda(tuple(x), body)` function-call form as a lambda so it
      // matches ClickHouse's `is_lambda_function: true` on the inner node.
      node.lambda = func.is_lambda_function ? func : { ...func, is_lambda_function: true };
      if (
        params !== undefined &&
        params.type === 'Function' &&
        params.arguments.length > 0 &&
        params.arguments[0].type === 'Identifier'
      ) {
        node.lambda_arg = params.arguments[0].name;
      }
    } else if (func.type === 'Function') {
      node.func_name = func.name;
      // Parametric functions in APPLY: `quantiles(0.5)` (arguments) and
      // `quantiles(0.5)(*)` (parameters+arguments) both become `parameters`
      // on the transformer node, matching ClickHouse's normalization.
      const params = func.parameters !== undefined ? func.parameters : func.arguments;
      if (params !== undefined && params.length > 0) {
        node.parameters = exprList(params);
      }
    }
    return withLoc(node, l ?? spanOf([node.lambda, node.parameters]));
  }

  // Build a REPLACE column transformer from `expr AS name` items.
  function replaceTransformer(items, strict, l) {
    const node = { type: 'ColumnsReplaceTransformer' };
    if (strict) node.is_strict = true;
    node.replacements = items.map((item) => withLoc({
      type: 'ColumnsReplaceTransformer::Replacement',
      name: item.alias,
      expression: item.expr,
    }, item.location ?? spanOf([item.expr])));
    return withLoc(node, l ?? spanOf(node.replacements));
  }

  // Rewrite `x op ANY/ALL (subquery)` to ClickHouse's canonical form. The
  // resulting AST is structurally identical to a user-written
  // `(SELECT aggName(*) FROM (sub))`, which is the canonical form we emit
  // on format.
  function syntheticAggSubquery(aggName, sub) {
    const L = sub.location;
    const sel = withLoc({
      type: 'SelectQuery',
      select: [withLoc(fn(aggName, [withLoc({ type: 'Asterisk' }, L)]), L)],
      from: withLoc({
        type: 'TablesInSelectQuery',
        children: [
          withLoc({
            type: 'TablesInSelectQueryElement',
            table_expression: withLoc({ type: 'TableExpression', subquery: sub }, L),
          }, L),
        ],
      }, L),
      // ClickHouse's `op ANY/ALL (sub)` lowering appends the projection and
      // tables to the synthetic SelectQuery's child vector twice, so its
      // EXPLAIN AST text dump shows `SelectQuery (children 4)`. The JSON AST
      // (and our named `select`/`from` fields) keep a single copy; this flag
      // tells the explain projection to emit the doubled child list.
      agg_repeat: true,
    }, L);
    return withLoc({ type: 'Subquery', query: withLoc(wrapSWU([sel]), L) }, L);
  }

  function tryAnyAllRewrite(op, left, right) {
    if (right.type !== 'Function') return null;
    const fname = right.name.toLowerCase();
    if (fname !== 'any' && fname !== 'all') return null;
    if (right.arguments.length !== 1 || right.arguments[0].type !== 'Subquery') return null;
    const sub = right.arguments[0];
    const isAny = fname === 'any';
    // ClickHouse's `x op ANY/ALL (sub)` lowers to either a plain `IN`/`NOT IN`
    // (bare equality cases) or a synthetic `(SELECT agg(*) FROM (sub))` wrap.
    // The AST that results is structurally indistinguishable from a
    // user-written form, so format() emits the canonical lowered shape
    // (cosmetic loss, semantically equivalent).
    const mark = { is_operator: true };
    if ((op === '=' || op === '==') && isAny) return fn('in', [left, sub], mark);
    if ((op === '!=' || op === '<>') && isAny === false) return fn('notIn', [left, sub], mark);
    if ((op === '=' || op === '==') && isAny === false) {
      return fn('in', [left, syntheticAggSubquery('singleValueOrNull', sub)], mark);
    }
    if ((op === '!=' || op === '<>') && isAny) {
      return fn('notIn', [left, syntheticAggSubquery('singleValueOrNull', sub)], mark);
    }
    if (op !== '<' && op !== '<=' && op !== '>' && op !== '>=') return null;
    const aggFunc = isAny
      ? (op === '<' || op === '<=' ? 'max' : 'min')
      : (op === '<' || op === '<=' ? 'min' : 'max');
    return fn(OP_TO_FUNCTION[op], [left, syntheticAggSubquery(aggFunc, sub)], mark);
  }

  // Build a lambda Function node: lambda(tuple(params), body).
  // An alias on the body moves to the lambda node itself, as ClickHouse does.
  function lambdaFn(params, body, l) {
    let b = body;
    let alias;
    if (b.alias !== undefined) {
      alias = b.alias;
      b = { ...b };
      delete b.alias;
    }
    // `params` are bare names; the synthesized `tuple(...)` wrapper and the
    // per-parameter Identifiers have no contiguous source of their own, so they
    // inherit the whole lambda span `l` (the `params -> body` range).
    const paramTuple = withLoc(fn('tuple', params.map((p) => withLoc(ident([p]), l)), { is_operator: true }), l ?? spanOf([b]));
    const node = fn(
      'lambda',
      [paramTuple, b],
      { is_operator: true, is_lambda_function: true, kind: 'LAMBDA_FUNCTION' },
    );
    if (alias !== undefined) node.alias = alias;
    return withLoc(node, l ?? spanOf([paramTuple, b]));
  }

  // Build a nested WindowDefinition `frame_begin`/`frame_end` bound object
  // from a parsed bound (`{boundType, preceding, offset?}`). Matches
  // ClickHouse's native shape: `Current` has no extra fields; `Unbounded`
  // and `Offset` carry the direction in `preceding` (omitted for FOLLOWING,
  // mirroring ClickHouse's serialization), and `Offset` carries `offset`.
  function frameBoundNode(bound, isBegin) {
    if (bound.boundType === 'Current') {
      // CURRENT ROW carries `preceding: true` only when it appears as
      // `frame_begin` (mirrors ClickHouse's serialization).
      const node = { type: 'Current' };
      if (isBegin) node.preceding = true;
      return node;
    }
    const node = { type: bound.boundType };
    if (bound.preceding === true) node.preceding = true;
    if (bound.offset !== undefined) node.offset = bound.offset;
    return node;
  }

  // Build the String literal holding a CAST target type.
  // Both `CAST(x AS T)` and `CAST(x, 'T')` collapse to the same shape: a plain
  // String literal whose `value` is the type text, so the two forms round-trip
  // to identical ASTs.
  function typeLit(rawType) {
    return strLit(normalizeTypeNamePlain(rawType));
  }

  // Canonical dump text of one typed-list element, or null when it is not a
  // pure-cast literal (Null/Bool). Recurses through nested Array/Tuple. Typed
  // elements share the Literal node's `value`/`nonfinite` shape, so `floatDump`
  // handles the Float64 case directly.
  function elemCastText(el) {
    switch (el.value_type) {
      case 'String':
        return "'" + escapeDecoded(el.value) + "'";
      case 'Float64':
        return floatDump(el);
      case 'Int64':
      case 'UInt64':
        return String(el.value);
      case 'Array':
        return '[' + el.value.map(elemCastText).join(', ') + ']';
      case 'Tuple':
        return '(' + el.value.map(elemCastText).join(', ') + ')';
      default:
        return null;
    }
  }

  // Whether every element of a typed Literal Array/Tuple list is a pure-cast
  // literal (no Null/Bool), recursively.
  function elemIsPureCast(el) {
    if (el.value_type === 'Null' || el.value_type === 'Bool') return false;
    if (el.value_type === 'Array' || el.value_type === 'Tuple') {
      return el.value.every(elemIsPureCast);
    }
    return true;
  }

  function castOperandText(e) {
    if (isOpCollection(e)) {
      if (e.arguments.every(isPureCastLiteral) === false) return null;
      const parts = e.arguments.map(castElementText);
      if (parts.some((p) => p === null)) return null;
      const open = e.name === 'array' ? '[' : '(';
      const close = e.name === 'array' ? ']' : ')';
      return open + parts.join(', ') + close;
    }
    if (e.type !== 'Literal') return null;
    if (e.value_type === 'Null' || e.value_type === 'Bool') return null;
    if (e.value_type === 'String') return e.value;
    // Reconstruct the canonical bracket dump text from the typed element list.
    if (e.value_type === 'Array' || e.value_type === 'Tuple') {
      if (!Array.isArray(e.value) || e.value.every(elemIsPureCast) === false) return null;
      const open = e.value_type === 'Array' ? '[' : '(';
      const close = e.value_type === 'Array' ? ']' : ')';
      return open + e.value.map(elemCastText).join(', ') + close;
    }
    return e.value_type === 'Float64' ? floatDump(e) : String(e.value);
  }

  // Per-element text inside a Function array/tuple cast operand dump.
  // Mirrors `litElem` for Literals; recurses through nested Function
  // array/tuple wrappers and folded Literal collections.
  function castElementText(e) {
    if (isOpCollection(e)) {
      return castOperandText(e);
    }
    if (e.type !== 'Literal') return null;
    switch (e.value_type) {
      case 'String':
        return "'" + escapeDecoded(e.value) + "'";
      case 'Float64':
        return floatDump(e);
      case 'Int64':
      case 'UInt64':
        return String(e.value);
      case 'Array':
      case 'Tuple':
        return castOperandText(e);
      default:
        return null;
    }
  }

  function isPureCastLiteral(e) {
    if (isOpCollection(e)) {
      return e.arguments.every(isPureCastLiteral);
    }
    if (e.type !== 'Literal') return false;
    if (e.value_type === 'Null' || e.value_type === 'Bool') return false;
    if (e.value_type === 'Array' || e.value_type === 'Tuple') {
      return Array.isArray(e.value) && e.value.every(elemIsPureCast);
    }
    return true;
  }

  // Build a CAST Function node for the `::` operator form. Pure-literal
  // operands are stored as their String literal text, as ClickHouse does.
  // The structured operand is parked on a parse-time-only `cast_operand`
  // marker so the unary-minus negate-fold can distinguish a folded `::`
  // cast (which folds `-1::Int8` → `CAST('-1','Int8')`) from a user-written
  // `CAST('1','Int8')` (which must stay `negate(CAST('1','Int8'))`). The
  // marker is stripped by `stripParseTimeMarkers` in `src/index.ts` before
  // the AST is returned, so the public AST cannot tell the folded form
  // from a user-written `CAST('1','UInt8')` — the formatter accepts that
  // canonicalization (`1::UInt8` → `CAST('1' AS UInt8)`).
  //
  // ClickHouse's folded form stores the operand's verbatim source text
  // (so `[(0,0),(1,1)]` keeps its compact spelling). The caller passes
  // `operandText` sliced from the input; we still derive a structural
  // fallback via `castOperandText` so nested folds (where the operand was
  // built without a contiguous source range) still work.
  function castOpFn(operand, rawType, operandText) {
    const isTopLevelString = operand.type === 'Literal' && operand.value_type === 'String';
    let text = null;
    if (!isTopLevelString && isPureCastLiteral(operand)) {
      text = operandText !== undefined ? operandText : castOperandText(operand);
    }
    if (text !== null) {
      // Stringified pure-literal casts are plain CAST calls in ClickHouse's AST
      const stringified = withLoc(strLit(text, { cast_operand: operand }), operand.location);
      return withLoc(fn('CAST', [stringified, withLoc(typeLit(rawType), operand.location)]), operand.location);
    }
    return withLoc(fn('CAST', [operand, withLoc(typeLit(rawType), operand.location)], { is_operator: true }), operand.location);
  }

  // ── SELECT statement node construction ──────────────────────────────────────

  // Convert a parsed sample ratio ({num, den?}) into a SampleRatio node with
  // ClickHouse's normalized fraction form. The source spelling is not
  // preserved — `SAMPLE 0.1` canonicalizes to `SAMPLE 1/10` at format time.
  function sampleRatioNode(v) {
    let node;
    if (v.den !== undefined) {
      node = {
        type: 'SampleRatio',
        numerator: String(Math.round(parseFloat(v.num))),
        denominator: String(Math.round(parseFloat(v.den))),
      };
    } else {
      const numText = v.num;
      const lower = numText.toLowerCase();
      if (/^[0-9]+$/.test(numText)) {
        node = { type: 'SampleRatio', numerator: numText, denominator: '1' };
      } else if (lower.includes('e-')) {
        const parts = lower.split('e-');
        const num = Math.round(parseFloat(parts[0]));
        const den = Math.round(Math.pow(10, parseInt(parts[1], 10)));
        node = { type: 'SampleRatio', numerator: String(num), denominator: String(den) };
      } else if (lower.includes('.')) {
        const dotIdx = lower.indexOf('.');
        const afterDot = lower.substring(dotIdx + 1).replace(/e.*$/, '');
        const decimalPlaces = afterDot.length;
        const digits = lower.replace('.', '').replace(/e.*$/, '');
        const num = parseInt(digits, 10);
        const den = Math.round(Math.pow(10, decimalPlaces));
        node = { type: 'SampleRatio', numerator: String(num), denominator: String(den) };
      } else {
        node = {
          type: 'SampleRatio',
          numerator: String(Math.round(parseFloat(numText))),
          denominator: '1',
        };
      }
    }
    return withLoc(node, v.location);
  }

  // Convert a FROM atom (tableRef / subqueryFrom / tableFunctionRef temp) into
  // a TableExpression node.
  function tableExprNode(atom) {
    const te = { type: 'TableExpression' };
    if (atom.kind === 'tableRef') {
      const ti = { type: 'TableIdentifier' };
      // A name/database segment is either a plain string or, for an
      // identifier-position query parameter (`{db:Identifier}.t`), the
      // QueryParameter node itself.
      ti.name = atom.table;
      if (atom.database !== undefined) ti.database = atom.database;
      if (atom.alias !== undefined) ti.alias = atom.alias;
      if (atom.location !== undefined) ti.location = atom.location;
      te.database_and_table_name = ti;
    } else if (atom.kind === 'tableFunctionRef') {
      const f = fn(atom.name, atom.args);
      if (atom.settings !== undefined) f.arguments = [...f.arguments, setNode(atom.settings)];
      if (atom.alias !== undefined) f.alias = atom.alias;
      if (atom.location !== undefined) f.location = atom.location;
      else withLoc(f, spanOf(f.arguments));
      te.table_function = f;
    } else {
      const sq = subqueryNode(atom.query);
      if (atom.alias !== undefined) sq.alias = atom.alias;
      if (atom.location !== undefined) sq.location = atom.location;
      te.subquery = sq;
      if (atom.columnAliases !== undefined) {
        te.column_aliases = withLoc(exprList(atom.columnAliases.map((a) => withLoc(ident([a]), atom.location))), atom.location);
      }
    }
    if (atom.final) te.final = true;
    if (atom.sample !== undefined) {
      te.sample_size = sampleRatioNode(atom.sample.ratio);
      if (atom.sample.offset !== undefined) te.sample_offset = sampleRatioNode(atom.sample.offset);
    }
    if (atom.leadingComments !== undefined) te.leadingComments = atom.leadingComments;
    if (atom.trailingComments !== undefined) te.trailingComments = atom.trailingComments;
    if (atom.location !== undefined) te.location = atom.location;
    else withLoc(te, spanOf([te.database_and_table_name, te.table_function, te.subquery]));
    return te;
  }

  // Convert the old-style FROM tree (joinExpr/arrayJoinExpr temps) into a flat
  // TablesInSelectQuery node.
  function tablesNode(from) {
    const elements = [];
    function flatten(node) {
      if (node.kind === 'joinExpr') {
        flatten(node.left);
        const joinNode = withLoc({ type: 'TableJoin', kind: node.joinType }, node.location);
        if (node.strictness !== undefined) joinNode.strictness = node.strictness;
        if (node.global) joinNode.locality = 'GLOBAL';
        if (node.constraint !== undefined) {
          if (node.constraint.kind === 'on') joinNode.on = node.constraint.expr;
          else {
            // `USING a, b` and `USING (a, b)` collapse to the same AST; the
            // formatter always emits the parenthesized form (canonical).
            joinNode.using = node.constraint.columns;
          }
        }
        const te = tableExprNode(node.right);
        elements.push(withLoc({
          type: 'TablesInSelectQueryElement',
          table_expression: te,
          table_join: joinNode,
        }, spanOf([te, joinNode]) ?? node.location));
      } else if (node.kind === 'arrayJoinExpr') {
        flatten(node.left);
        const aj = withLoc({
          type: 'ArrayJoin',
          kind: node.joinType === 'LEFT ARRAY' ? 'LEFT' : 'INNER',
          expressions: node.expressions,
        }, node.location ?? spanOf(node.expressions));
        elements.push(withLoc({ type: 'TablesInSelectQueryElement', array_join: aj }, aj.location));
      } else {
        const te = tableExprNode(node);
        elements.push(withLoc({ type: 'TablesInSelectQueryElement', table_expression: te }, te.location ?? node.location));
      }
    }
    flatten(from);
    const result = { type: 'TablesInSelectQuery', children: elements };
    return withLoc(result, spanOf(elements) ?? from.location);
  }

  // ── Union/intersect wrapper construction ─────────────────────────────────────

  function wrapSWU(members, extra) {
    const node = { type: 'SelectWithUnionQuery', selects: members };
    if (extra) Object.assign(node, extra);
    return withLoc(node, spanOf(members));
  }

  // Members contributed by a node when combined with UNION ALL: an unmoded
  // SelectWithUnionQuery dissolves into its selects; a DISTINCT chain becomes
  // a nested group whose mode is implied rather than serialized, as ClickHouse
  // normalizes it. The implicit-DISTINCT group is recovered structurally
  // (unmoded SWU child of a UNION_ALL parent) rather than via a flag.
  function unionAllMembers(node) {
    if (node.type === 'SelectWithUnionQuery') {
      if (node.union_mode === 'UNION_DISTINCT') {
        // Explicitly parenthesized DISTINCT groups keep their serialized mode;
        // precedence-implied groups have it removed (ClickHouse mode REMOVED).
        if (node.parenthesized === true) return [node];
        const group = { ...node };
        delete group.union_mode;
        return [group];
      }
      return node.selects;
    }
    return [node];
  }

  // Deep flattening for UNION DISTINCT chains (dissolves all nested wrappers).
  function deepMembers(node) {
    if (node.type === 'SelectWithUnionQuery') {
      let out = [];
      for (const s of node.selects) out = out.concat(deepMembers(s));
      return out;
    }
    return [node];
  }

  // Wrap an intersect/except child in SelectWithUnionQuery when required.
  function intersectChild(node, wrap) {
    if (node.type === 'SelectWithUnionQuery') return node;
    if (node.parenthesized) wrap = true;
    return wrap ? wrapSWU([node]) : node;
  }

  // Build a SelectIntersectExceptQuery node with ClickHouse's wrapping rules:
  // EXCEPT left child is always wrapped; INTERSECT children that are themselves
  // intersect/except nodes are wrapped; parenthesized children are wrapped.
  // The bare `INTERSECT`/`EXCEPT` spelling canonicalizes to the equivalent
  // `INTERSECT ALL`/`EXCEPT ALL` operator on format() (semantically identical
  // — ClickHouse defaults bare INTERSECT/EXCEPT to the ALL variant).
  function intersectNode(opKeyword, mode, left, right) {
    const isExcept = opKeyword === 'EXCEPT';
    const lw = isExcept || left.type === 'SelectIntersectExceptQuery';
    const rw = !isExcept && right.type === 'SelectIntersectExceptQuery';
    const selects = [intersectChild(left, lw), intersectChild(right, rw)];
    return withLoc({
      type: 'SelectIntersectExceptQuery',
      operator: opKeyword + ' ' + (mode !== null && mode !== undefined ? mode : 'ALL'),
      selects,
    }, spanOf(selects));
  }

  // ── WITH (CTE) distribution across union members ─────────────────────────────

  // Distribute the first member's WITH items to the other union members.
  // ClickHouse's AST has the WITH replicated on every member it scopes over;
  // we mirror that shape directly. The distributed copies are no longer
  // tagged with a side-channel marker — format() simply emits WITH on every
  // member that has it set, so a `WITH ... SELECT ... UNION ALL SELECT ...`
  // canonicalizes to `WITH ... SELECT ... UNION ALL WITH ... SELECT ...` on
  // re-format, which is semantically equivalent.
  function distributeUnionWith(members) {
    if (members.length < 2) return members;
    const first = members[0];
    if (first.type !== 'SelectQuery' || first.with === undefined || first.with.length === 0) {
      return members;
    }
    return members.map((m, i) => {
      if (i === 0 || m.type !== 'SelectQuery') return m;
      if (m.with !== undefined && m.with.length > 0) return m;
      // A WITH that scopes the whole union is emitted first on the member that
      // declared it but appended last on every member it propagates into, so
      // the distributed copies are tagged trailing.
      return { ...m, with: first.with, with_trailing: true };
    });
  }

  // Distribute the leftmost SELECT's WITH items across an intersect chain.
  function distributeIntersectWith(node) {
    function findLeftmostSelect(q) {
      if (q.type === 'SelectQuery') return q;
      if (q.type === 'SelectIntersectExceptQuery') return findLeftmostSelect(q.selects[0]);
      if (q.type === 'SelectWithUnionQuery' && q.selects.length > 0) {
        return findLeftmostSelect(q.selects[0]);
      }
      return undefined;
    }
    function distribute(q, withItems, isLeftmostPath) {
      if (q.type === 'SelectQuery') {
        if (isLeftmostPath) return q;
        if (q.with !== undefined && q.with.length > 0) return q;
        // Propagated (non-leftmost) copies are appended last by ClickHouse.
        return { ...q, with: withItems, with_trailing: true };
      }
      if (q.type === 'SelectIntersectExceptQuery') {
        return {
          ...q,
          selects: q.selects.map((c, i) => distribute(c, withItems, isLeftmostPath && i === 0)),
        };
      }
      if (q.type === 'SelectWithUnionQuery') {
        return {
          ...q,
          selects: q.selects.map((c, i) => distribute(c, withItems, isLeftmostPath && i === 0)),
        };
      }
      return q;
    }
    const leftSelect = findLeftmostSelect(node);
    const leftWith = leftSelect === undefined ? undefined : leftSelect.with;
    if (leftWith === undefined || leftWith.length === 0) return node;
    return distribute(node, leftWith, true);
  }

  // Attach an INSERT statement's WITH items to its query's leftmost SELECT
  // and distribute them across union/intersect members, as ClickHouse does.
  function attachInsertWith(query, withItems) {
    function attachLeftmost(q) {
      if (q.type === 'SelectQuery') {
        if (q.with !== undefined && q.with.length > 0) return q;
        // A WITH written before INSERT (`WITH ... INSERT INTO ... SELECT ...`)
        // is appended to the inner SELECT's child list by ClickHouse, so its
        // EXPLAIN AST emits the WITH ExpressionList *after* the select body.
        // `with_trailing` records that source position for the explain
        // projection (format() still re-emits it before the statement).
        return { ...q, with: withItems, with_trailing: true };
      }
      if (q.type === 'SelectWithUnionQuery') {
        const selects = q.selects.slice();
        selects[0] = attachLeftmost(selects[0]);
        return { ...q, selects };
      }
      if (q.type === 'SelectIntersectExceptQuery') {
        const selects = q.selects.slice();
        selects[0] = attachLeftmost(selects[0]);
        return { ...q, selects };
      }
      return q;
    }
    let attached = attachLeftmost(query);
    if (attached.type === 'SelectWithUnionQuery') {
      attached = {
        ...attached,
        selects: distributeUnionWith(
          attached.selects.map((m) =>
            m.type === 'SelectIntersectExceptQuery' ? distributeIntersectWith(m) : m,
          ),
        ),
      };
    }
    return attached;
  }

  // Finalize a query produced by the UnionQuery rule: wrap bare selects /
  // intersects in SelectWithUnionQuery and apply WITH distribution.
  function finalizeQuery(node) {
    if (node.type === 'SelectQuery') return wrapSWU([node]);
    if (node.type === 'SelectIntersectExceptQuery') {
      return wrapSWU([distributeIntersectWith(node)]);
    }
    if (node.type === 'SelectWithUnionQuery') {
      return { ...node, selects: distributeUnionWith(node.selects.map((s) =>
        s.type === 'SelectIntersectExceptQuery' ? distributeIntersectWith(s) : s)) };
    }
    return node;
  }

  // Render a setting value (a scalar from Set.changes) as it appears inside
  // viewExplain's settings string.
  function explainSettingText(v, valueType) {
    if (v === null || v === undefined) return 'NULL';
    if (typeof v === 'string') {
      if (valueType === 'UInt64' || valueType === 'Int64' || valueType === 'Float64') return String(Number(v));
      return "'" + v + "'";
    }
    if (typeof v === 'boolean') return v ? 'true' : 'false';
    return String(v);
  }

  // Build a Subquery node. ClickHouse's parser rewrites (EXPLAIN ...) subqueries
  // into (SELECT * FROM viewExplain('EXPLAIN <kind>', '<settings>', (<query>)));
  // we apply the same rewrite so the AST matches ClickHouse's native shape.
  // The formatter emits the rewritten viewExplain form (canonical); the original
  // (EXPLAIN ...) source-text spelling is not preserved.
  function subqueryNode(query) {
    if (query.type !== 'Explain') return withLoc({ type: 'Subquery', query }, spanOf([query]));
    const L = query.location;
    const typeLabel = query.kind ?? 'EXPLAIN';
    const preSet = query.settings;
    const preEntries = [];
    if (preSet !== undefined) {
      if (preSet.changes !== undefined) {
        for (const key of Object.keys(preSet.changes)) {
          preEntries.push(key + ' = ' + explainSettingText(preSet.changes[key], preSet.change_value_types && preSet.change_value_types[key]));
        }
      }
      if (preSet.default_settings !== undefined) {
        for (const key of preSet.default_settings) {
          preEntries.push(key + ' = DEFAULT');
        }
      }
    }
    const settingsLabel = preEntries.join(', ');
    const args = [withLoc(strLit(typeLabel), L), withLoc(strLit(settingsLabel), L)];
    if (query.query !== undefined) {
      args.push(withLoc({ type: 'Subquery', query: query.query }, spanOf([query.query]) ?? L));
    }
    const sel = withLoc({
      type: 'SelectQuery',
      select: [withLoc({ type: 'Asterisk' }, L)],
      from: withLoc({
        type: 'TablesInSelectQuery',
        children: [
          withLoc({
            type: 'TablesInSelectQueryElement',
            table_expression: withLoc({ type: 'TableExpression', table_function: withLoc(fn('viewExplain', args), L) }, L),
          }, L),
        ],
      }, L),
    }, L);
    return withLoc({ type: 'Subquery', query: withLoc(wrapSWU([sel]), L) }, L);
  }

  // Convert a parsed CTE temp into a WITH item node.
  function cteToWithItem(cte) {
    let result;
    if (cte.kind === 'cteSubquery') {
      result = { type: 'WithElement', name: cte.name, subquery: subqueryNode(cte.query) };
      if (cte.columnAliases !== undefined) {
        result.aliases = withLoc(exprList(cte.columnAliases.map((a) => withLoc(ident([a]), cte.location))), cte.location);
      }
      withLoc(result, cte.location ?? spanOf([result.subquery]));
    } else if (cte.kind === 'cteTuple') {
      result = withLoc(fn('tuple', cte.elements, { is_operator: true }), cte.location ?? spanOf(cte.elements));
    } else {
      result = cte.name !== undefined ? applyAlias(cte.expr, cte.name) : cte.expr;
    }
    if (cte.leadingComments !== undefined) {
      result = addLeading(result, cte.leadingComments);
    }
    if (cte.trailingComments !== undefined) {
      result = addTrailing(result, cte.trailingComments);
    }
    if (cte.location !== undefined && result.location === undefined) result.location = cte.location;
    return result;
  }

  // Assemble a SelectQuery node from parsed clause pieces.
  function buildSelectQuery(o) {
    const result = { type: 'SelectQuery' };
    let withTrailingComments = [];
    if (o.withClause !== null && o.withClause !== undefined) {
      const wcd = o.withClause[0];
      result.with = wcd.items.map(cteToWithItem);
      if (wcd.recursive) result.recursive_with = true;
      const kwComments = flattenWs(wcd.keywordComments);
      if (kwComments.length > 0) result.leadingComments = kwComments;
      withTrailingComments = flattenWs(o.withClause[1]);
    }
    // DISTINCT / DISTINCT ON
    const distVal = o.distinct !== null && o.distinct !== undefined ? o.distinct[0] : null;
    if (distVal !== null && typeof distVal === 'object' && distVal.kind === 'distinctOn') {
      // DISTINCT ON (cols) is rewritten to LIMIT 1 BY cols, as ClickHouse does.
      // The original DISTINCT ON spelling is not recoverable from the AST;
      // format() emits the canonical `LIMIT 1 BY` form.
      result.limit_by = { length: withLoc(uintLit('1'), spanOf(distVal.on)), by: distVal.on };
    } else {
      const distStr = Array.isArray(distVal) ? distVal[0] : distVal;
      if (distStr !== null && distStr !== undefined && distStr.toString().toUpperCase() === 'DISTINCT') {
        result.distinct = true;
      }
    }
    result.select = o.select;
    if (o.from !== null && o.from !== undefined) {
      result.from = tablesNode(o.from);
      if (o.fromLeading !== undefined && o.fromLeading.length > 0) {
        result.from.leadingComments = o.fromLeading;
      }
    }
    if (o.prewhere !== null && o.prewhere !== undefined) result.prewhere = o.prewhere;
    if (o.where !== null && o.where !== undefined) result.where = o.where;
    // WITH TOTALS/CUBE/ROLLUP modifiers (can appear without GROUP BY)
    if (o.withModifier === 'TOTALS') result.group_by_with_totals = true;
    if (o.withModifier === 'ROLLUP') result.group_by_with_rollup = true;
    if (o.withModifier === 'CUBE') result.group_by_with_cube = true;
    // GROUP BY clause
    if (o.groupBy !== null && o.groupBy !== undefined) {
      const gb = o.groupBy[1];
      const gbc = flattenWs(o.groupBy[0]);
      if (gb.all) {
        result.group_by_all = true;
      } else if (gb.groupingSets) {
        result.group_by = gb.groupingSets.map((set) =>
          set.length > 0 ? exprList(set) : withLoc({ type: 'ExpressionList' }, set.location),
        );
        result.group_by_with_grouping_sets = true;
      } else {
        let gbItems = gb.items;
        if (gbc.length > 0 && gbItems.length > 0) {
          gbItems = gbItems.slice();
          gbItems[0] = addLeading(gbItems[0], gbc);
        }
        // GROUP BY ROLLUP(...)/CUBE(...) function syntax flattens into the items
        // and sets the equivalent `group_by_with_rollup`/`group_by_with_cube`
        // flag. The original function-call spelling is lost; format() emits
        // the canonical `WITH ROLLUP`/`WITH CUBE` suffix form.
        const flat = [];
        for (const item of gbItems) {
          if (
            item.type === 'Function' &&
            item.is_operator !== true &&
            (item.name.toUpperCase() === 'ROLLUP' || item.name.toUpperCase() === 'CUBE')
          ) {
            for (const a of item.arguments) flat.push(a);
            if (item.name.toUpperCase() === 'ROLLUP') result.group_by_with_rollup = true;
            else result.group_by_with_cube = true;
          } else {
            flat.push(item);
          }
        }
        result.group_by = flat;
      }
      if (gb.withTotals) result.group_by_with_totals = true;
      if (gb.withCube) result.group_by_with_cube = true;
      if (gb.withRollup) result.group_by_with_rollup = true;
    }
    if (o.having !== null && o.having !== undefined) result.having = o.having;
    // Named windows. WINDOW may appear before or after LIMIT in the source;
    // either spelling canonicalizes to the pre-LIMIT slot on format().
    if (o.windows !== null && o.windows !== undefined) {
      result.window = o.windows.map((w) => withLoc({ type: 'WindowListElement', name: w.name, definition: w.spec }, w.location ?? spanOf([w.spec])));
    }
    // QUALIFY similarly canonicalizes to the pre-LIMIT slot on format().
    if (o.qualify !== null && o.qualify !== undefined) {
      result.qualify = o.qualify;
    }
    // ORDER BY
    if (o.orderBy !== null && o.orderBy !== undefined) {
      let items = o.orderBy;
      // ORDER BY ALL
      if (
        items.length === 1 &&
        items[0].expression.type === 'Identifier' &&
        items[0].expression.name_parts === undefined &&
        items[0].expression.name.toUpperCase() === 'ALL'
      ) {
        result.order_by_all = true;
      }
      // Lift INTERPOLATE from the order item onto the SelectQuery
      for (let i = 0; i < items.length; i++) {
        if (items[i]._interpolate !== undefined) {
          result.interpolate = items[i]._interpolate;
          const copy = { ...items[i] };
          delete copy._interpolate;
          items = items.map((it, j) => (j === i ? copy : it));
          break;
        }
      }
      result.order_by = items;
    }
    // LIMIT BY
    if (o.limitBy !== null && o.limitBy !== undefined) {
      const lb = o.limitBy;
      const limitBy = { length: lb.count, by: lb.by };
      if (lb.limitByOffset !== undefined) limitBy.offset = lb.limitByOffset;
      result.limit_by = limitBy;
    }
    // LIMIT / OFFSET / FETCH / TOP all canonicalize to `LIMIT length [OFFSET
    // offset] [WITH TIES]` on format(). The original syntactic form (comma
    // pair, SQL-standard FETCH, or SELECT TOP n) is not recoverable from the
    // AST. Only WITH TIES is preserved, since it changes result semantics.
    if (o.limit !== null && o.limit !== undefined) {
      const lc = o.limit;
      if (lc.comma) {
        // LIMIT offset, length: canonicalized to (limit, offset)
        result.offset = lc.count;
        result.limit = lc.offset;
      } else {
        result.limit = lc.count;
      }
      if (lc.withTies) result.limit_with_ties = true;
    }
    if (o.offset !== null && o.offset !== undefined) result.offset = o.offset;
    if (o.fetch !== null && o.fetch !== undefined) {
      const fc = o.fetch;
      result.limit = fc.count;
      if (fc.withTies) result.limit_with_ties = true;
    }
    if (o.top !== null && o.top !== undefined && result.limit === undefined) {
      result.limit = o.top.count;
      if (o.top.withTies) result.limit_with_ties = true;
    }
    if (o.settings !== null && o.settings !== undefined) result.settings = setNode(o.settings);
    // Comments between WITH block/SELECT keyword and first item
    const selectCommentsFlat = [...withTrailingComments, ...flattenWs(o.selectComments)];
    if (selectCommentsFlat.length > 0 && result.select.length > 0) {
      result.select[0] = addLeading(result.select[0], selectCommentsFlat);
    }
    // Trailing same-line comment after the last select item
    if (o.selectTrailing !== undefined && o.selectTrailing.length > 0) {
      const hasFollowingClause =
        result.from || result.prewhere || result.where || result.group_by ||
        result.group_by_all || result.having || result.order_by ||
        result.limit_by || result.limit || result.offset ||
        result.window || result.qualify || result.settings;
      if (hasFollowingClause) {
        result.select[result.select.length - 1] = addTrailing(
          result.select[result.select.length - 1],
          o.selectTrailing,
        );
      } else {
        result.trailingComments = o.selectTrailing;
      }
    }
    return result;
  }

  // TableIdentifier node from a parsed table ref temp ({database?, table}).
  function tableIdentNode(t) {
    const node = { type: 'TableIdentifier', name: partName(t.table) };
    if (t.database !== undefined) node.database = partName(t.database);
    return withLoc(node, t.location);
  }

  // Build a drop-family statement node (DropQuery/DetachQuery/TruncateQuery/
  // UndropQuery) in ClickHouse's native explicit-field shape. Native fields:
  // `kind` (action), `table`/`database` (Identifier nodes), and the boolean
  // modifiers `if_exists`, `temporary`, `is_dictionary`, `is_view`, `sync`,
  // plus `cluster`, `uuid`, and the `TRUNCATE ALL TABLES FROM ... LIKE`
  // bookkeeping (`has_all`/`has_tables`/`like`/`not_like`/
  // `case_insensitive_like`). Library-only underscore fields preserve what the
  // native AST drops (target keyword, SETTINGS/FORMAT trailers).
  function dropFamilyNode(type, o) {
    // UndropQuery has no `kind` discriminator in the native AST — the node
    // `type` is enough.
    const action = type === 'DetachQuery' ? 'DETACH'
      : type === 'TruncateQuery' ? 'TRUNCATE'
      : type === 'UndropQuery' ? undefined : 'DROP';
    const node = { type };
    if (action !== undefined) node.kind = action;
    if (o.targetType === 'DICTIONARY') node.is_dictionary = true;
    else if (o.targetType === 'VIEW') node.is_view = true;
    if (o.tables !== undefined) {
      // Multi-table DROP/DETACH/TRUNCATE serializes the list under
      // `database_and_tables` as an `ExpressionList` of `TableIdentifier`s.
      node.database_and_tables = exprList(o.tables.map(tableIdentNode));
    } else if (o.database !== undefined) {
      node.database = identLoc([o.database], o.location);
    } else if (o.table !== undefined) {
      const tl = o.table.location;
      if (o.targetType === 'DATABASE') {
        node.database = identLoc([o.table.table], tl);
      } else {
        if (o.table.database !== undefined) {
          node.database = identLoc([o.table.database], tl);
        }
        node.table = identLoc([o.table.table], tl);
      }
    }
    if (o.settings !== undefined && o.settings.length > 0) node.settings = setNode(o.settings);
    if (o.format !== undefined) node.format = o.format;
    if (o.temporary) node.temporary = true;
    if (o.ifExists) node.if_exists = true;
    if (o.ifEmpty) node.if_empty = true;
    if (o.permanently) node.permanently = true;
    if (o.sync) node.sync = true;
    // `TRUNCATE [ALL] TABLES FROM db` carries the ALL/TABLES keyword markers.
    if (o.allTables) node.has_all = true;
    if (o.targetType === 'TABLES') node.has_tables = true;
    if (o.uuid !== undefined) node.uuid = o.uuid;
    if (o.onCluster !== undefined) node.cluster = o.onCluster;
    if (o.like !== undefined) {
      node.like = o.like.pattern;
      if (o.like.not) node.not_like = true;
      if (o.like.ilike) node.case_insensitive_like = true;
    }
    return node;
  }

  // First Set node found among a query's selects (settings of the inner SELECT).
  function findFirstSelectSettings(q) {
    if (q === undefined || q === null) return undefined;
    if (q.type === 'SelectQuery') return q.settings;
    if (q.type === 'SelectWithUnionQuery') {
      for (const m of q.selects) {
        const r = findFirstSelectSettings(m);
        if (r !== undefined) return r;
      }
      return undefined;
    }
    if (q.type === 'SelectIntersectExceptQuery') {
      for (const m of q.selects) {
        const r = findFirstSelectSettings(m);
        if (r !== undefined) return r;
      }
      return undefined;
    }
    return undefined;
  }

  // Build an InsertQuery node in ClickHouse's native explicit-field shape.
  // The native AST exposes `table`/`database`/`table_function` (target),
  // `columns` (insert column list), `select` (inner SELECT), `format`, and
  // `settings` (the effective, hoisted settings — INSERT-level values win over
  // the inner SELECT's on key conflicts, matching ClickHouse).
  function insertQueryNode(o) {
    const node = { type: 'InsertQuery' };
    if (o.fromInfile !== undefined) {
      node.infile = o.fromInfile.path;
      if (o.fromInfile.compression !== undefined) {
        node.compression = o.fromInfile.compression;
      }
    }
    if (o.target.kind === 'table') {
      const t = o.target.table;
      if (t.database !== undefined) node.database = identLoc([t.database], t.location);
      node.table = identLoc([t.table], t.location);
    } else {
      node.table_function = withLoc(fn(o.target.func.name, o.target.func.args), o.target.func.location ?? spanOf(o.target.func.args));
    }
    if (o.partitionBy !== undefined) node.partition_by = o.partitionBy;
    if (o.columns !== undefined && o.columns.length > 0) node.columns = o.columns;
    if (o.selectQuery !== undefined && o.selectQuery !== null) {
      node.select = o.selectQuery;
      if (o.format !== undefined) node.format = o.format;
    } else {
      // ClickHouse's default INSERT format is `Values` — set it whenever the
      // INSERT has no inline SELECT so the AST shape matches the native
      // serialization (which always carries the format keyword for VALUES /
      // bare INSERTs, even though the formatter drops the trailing data).
      node.format = o.format !== undefined ? o.format : 'Values';
    }
    // The native `settings` node mirrors the effective settings for this
    // INSERT — ClickHouse hoists the inner SELECT's settings onto it, with
    // INSERT-level values winning on key conflicts. The formatter re-derives
    // the INSERT-level clause by subtracting the inner SELECT's own settings.
    const insertItems =
      o.insertSettings !== undefined && o.insertSettings.length > 0 ? o.insertSettings : null;
    const querySettings =
      o.querySettings !== undefined && o.querySettings !== null && o.querySettings.length > 0
        ? o.querySettings
        : null;
    const selectInner = findFirstSelectSettings(o.selectQuery);
    if (insertItems !== null) {
      const setN = setNode(insertItems);
      if (selectInner !== undefined) {
        // INSERT-level settings win on duplicate keys; merge inner ∪ insert
        // into changes so the AST matches the native oracle (which collapses
        // all settings onto the INSERT's Set node).
        const mergedChanges = {
          ...(selectInner.changes || {}),
          ...(setN.changes || {}),
        };
        const mergedValueTypes = {
          ...(selectInner.change_value_types || {}),
          ...(setN.change_value_types || {}),
        };
        if (Object.keys(mergedChanges).length > 0) setN.changes = mergedChanges;
        if (Object.keys(mergedValueTypes).length > 0) setN.change_value_types = mergedValueTypes;
        const insertKeys = new Set(Object.keys(setN.changes || {}));
        const seen = new Set();
        const mergedDefaults = [];
        for (const arr of [selectInner.default_settings || [], setN.default_settings || []]) {
          for (const name of arr) {
            if (insertKeys.has(name) || seen.has(name)) continue;
            seen.add(name);
            mergedDefaults.push(name);
          }
        }
        if (mergedDefaults.length > 0) setN.default_settings = mergedDefaults;
      }
      node.settings = setN;
    } else if (querySettings !== null) {
      node.settings = setNode(querySettings);
    } else if (
      selectInner !== undefined &&
      (selectInner.changes !== undefined || selectInner.default_settings !== undefined)
    ) {
      // No SETTINGS at the INSERT level — ClickHouse still hoists the inner
      // SELECT's settings onto the INSERT's native `settings` node. The
      // formatter re-derives the INSERT-level clause by subtracting the inner
      // SELECT's own settings, so no origin marker is needed.
      const setN = { type: 'Settings' };
      if (selectInner.changes !== undefined) setN.changes = { ...selectInner.changes };
      if (selectInner.change_value_types !== undefined) {
        setN.change_value_types = { ...selectInner.change_value_types };
      }
      if (selectInner.default_settings !== undefined) {
        setN.default_settings = [...selectInner.default_settings];
      }
      withLoc(setN, selectInner.location);
      node.settings = setN;
    }
    return node;
  }

  // Partition / Partition_ID node from a partition clause temp
  // ({kind:'id',id} | {kind:'all'} | {kind:'expr',expr}).
  function partitionChildNode(part) {
    if (part.kind === 'all') return withLoc({ type: 'Partition_ID', all: true }, part.location);
    if (part.kind === 'id') {
      const idNode =
        part.id !== null && typeof part.id === 'object' && part.id.type !== undefined
          ? part.id
          : withLoc(strLit(part.id), part.location);
      return withLoc({ type: 'Partition_ID', id: idNode }, part.location ?? spanOf([idNode]));
    }
    return withLoc({ type: 'Partition', value: part.expr }, part.location ?? spanOf([part.expr]));
  }

  // Drop-family / TableTarget shape: set `database` and `table` Identifier
  // fields directly (no children array). Mirrors ClickHouse's native JSON.
  function setTableTarget(node, t) {
    if (t.database !== undefined) node.database = identLoc([t.database], t.location);
    node.table = identLoc([t.table], t.location);
  }

  // Attach leading comments to a statement, descending into the first member
  // of union/intersect trees so attachment matches in-statement comments.
  function addStmtLeading(stmt, comments) {
    if (comments === undefined || comments === null || comments.length === 0) return stmt;
    if (stmt.type === 'SelectWithUnionQuery' && Array.isArray(stmt.selects) && stmt.selects.length > 0) {
      const selects = [...stmt.selects];
      selects[0] = addStmtLeading(selects[0], comments);
      return { ...stmt, selects };
    }
    if (stmt.type === 'SelectIntersectExceptQuery' && Array.isArray(stmt.selects) && stmt.selects.length > 0) {
      const selects = [...stmt.selects];
      selects[0] = addStmtLeading(selects[0], comments);
      return { ...stmt, selects };
    }
    return addLeading(stmt, comments);
  }

  // Attach trailing comments to a statement, descending into the last member
  // of union/intersect trees so attachment matches in-statement comments.
  function addStmtTrailing(stmt, comments) {
    if (comments === undefined || comments === null || comments.length === 0) return stmt;
    if (stmt.type === 'SelectWithUnionQuery' && Array.isArray(stmt.selects) && stmt.selects.length > 0) {
      const selects = [...stmt.selects];
      selects[selects.length - 1] = addStmtTrailing(selects[selects.length - 1], comments);
      return { ...stmt, selects };
    }
    if (stmt.type === 'SelectIntersectExceptQuery' && Array.isArray(stmt.selects) && stmt.selects.length > 0) {
      const selects = [...stmt.selects];
      selects[selects.length - 1] = addStmtTrailing(selects[selects.length - 1], comments);
      return { ...stmt, selects };
    }
    return addTrailing(stmt, comments);
  }

  // Interval unit name lookup (lowercase key → capitalized unit name)
  const INTERVAL_UNITS = {
    nanosecond: 'Nanosecond', nanoseconds: 'Nanosecond', ns: 'Nanosecond',
    microsecond: 'Microsecond', microseconds: 'Microsecond', us: 'Microsecond',
    millisecond: 'Millisecond', milliseconds: 'Millisecond', ms: 'Millisecond',
    second: 'Second', seconds: 'Second', s: 'Second',
    minute: 'Minute', minutes: 'Minute', min: 'Minute',
    hour: 'Hour', hours: 'Hour', h: 'Hour',
    day: 'Day', days: 'Day', d: 'Day',
    week: 'Week', weeks: 'Week', w: 'Week',
    month: 'Month', months: 'Month', m: 'Month',
    quarter: 'Quarter', quarters: 'Quarter', q: 'Quarter',
    year: 'Year', years: 'Year', y: 'Year',
    // SQL_TSI_ prefixed units for TIMESTAMP_ADD/TIMESTAMP_SUB
    sql_tsi_nanosecond: 'Nanosecond', sql_tsi_microsecond: 'Microsecond',
    sql_tsi_millisecond: 'Millisecond', sql_tsi_second: 'Second',
    sql_tsi_minute: 'Minute', sql_tsi_hour: 'Hour', sql_tsi_day: 'Day',
    sql_tsi_week: 'Week', sql_tsi_month: 'Month', sql_tsi_quarter: 'Quarter',
    sql_tsi_year: 'Year',
  };

  // ── Phase 3: DDL native-node builders ───────────────────────────────────────

  // Acyclic deep clone of a parsed subtree (parent refs are not set at parse
  // time). Used to stash structured clause data in `_`-fields for format()
  // without aliasing nodes that also live in `children`.
  function cloneAst(v) {
    if (Array.isArray(v)) {
      const a = v.map(cloneAst);
      // Preserve custom non-index array props (e.g. ORDER BY `parenthesized`).
      for (const k of Object.keys(v)) if (!/^\d+$/.test(k)) a[k] = cloneAst(v[k]);
      return a;
    }
    if (v !== null && typeof v === 'object') {
      const o = {};
      for (const k in v) if (k !== 'parent') o[k] = cloneAst(v[k]);
      return o;
    }
    return v;
  }

  // Backtick-quote a type field name / type name for format() output.
  function quoteTypeIdent(name) {
    if (/^[A-Za-z_][A-Za-z0-9_$]*$/.test(name)) return name;
    return '`' + name.replace(/\\/g, '\\\\').replace(/`/g, '``') + '`';
  }

  // Format a structured data type to its SQL text (mirrors format.ts
  // formatDataType). Used for source text that ClickHouse itself stores as a
  // string, such as defaultValueOfTypeName('Type').
  function fmtType(dt) {
    if (dt.args === undefined) return dt.name;
    if (dt.args.length === 0) return dt.name + '()';
    return dt.name + '(' + dt.args.map(fmtTypeArg).join(', ') + ')';
  }
  function fmtTypeArg(a) {
    if (a.kind === 'type') return fmtType(a.type);
    if (a.kind === 'namedField') return quoteTypeIdent(a.name) + ' ' + fmtType(a.type);
    if (a.kind === 'literal') return a.value;
    if (a.kind === 'enumValues') {
      return a.values
        .map((v) =>
          v.name === null
            ? 'NULL'
            : v.value !== undefined
              ? "'" + escapeDecoded(v.name) + "' = " + v.value
              : "'" + escapeDecoded(v.name) + "'",
        )
        .join(', ');
    }
    if (a.kind === 'setting') return a.name + ' = ' + a.valueText;
    return '';
  }

  // Type string-literal args use a no-escape grammar ([^']*), so dropping the
  // surrounding quotes recovers the decoded value.
  function decodeTypeStr(v) {
    return v.slice(1, -1);
  }

  // Native Literal node for a type literal arg.
  function typeLitNode(v) {
    if (/^[0-9]+$/.test(v)) return uintLit(v);
    if (/^-?[0-9]+$/.test(v)) return intLit(v);
    if (/^-?[0-9]*\.[0-9]+$/.test(v) || /^[0-9]+\.[0-9]*$/.test(v)) return floatLit(v);
    if (v.startsWith("'")) return strLit(decodeTypeStr(v));
    return strLit(v);
  }

  // An explicit-clause PRIMARY KEY expression: a bare expr for a single key, a
  // `()` tuple operator for a parenthesized multi-key list.
  function pkExprNode(pk) {
    return pk.length === 1 ? pk[0] : withLoc(fn('tuple', pk, { is_operator: true }), spanOf(pk) ?? pk.location);
  }

  // ExpressionList node; ClickHouse omits the `children` key when empty.
  function exprList(children) {
    return children && children.length > 0
      ? withLoc({ type: 'ExpressionList', children }, spanOf(children))
      : { type: 'ExpressionList' };
  }

  const ENUM_RE = /^Enum(?:8|16)?$/i;
  const MYSQL_INT_RE = /^(TINYINT|SMALLINT|INT|INTEGER|BIGINT|MEDIUMINT)(\s+(SIGNED|UNSIGNED))?$/i;
  const AGG_FN_RE = /^(?:Aggregate|SimpleAggregate)Function$/i;

  // Stamp a captured source location onto a freshly-built node (no-op when the
  // location is absent). Used to thread `location()` from the type-matching
  // rules onto the materialized type nodes.
  function withLoc(node, l) {
    if (l !== undefined && node.location === undefined) node.location = l;
    return node;
  }

  // Child-union source span: the min-start .. max-end of the located nodes in
  // `nodes` (recursing one level into arrays). Used to give container nodes
  // built in global-block helpers an accurate span derived from their children.
  function spanOf(nodes) {
    if (!Array.isArray(nodes)) return undefined;
    let start, end;
    const consider = (l) => {
      if (!l) return;
      if (start === undefined || l.start.offset < start.offset) start = l.start;
      if (end === undefined || l.end.offset > end.offset) end = l.end;
    };
    for (const n of nodes) {
      if (n === null || n === undefined) continue;
      if (Array.isArray(n)) { for (const m of n) consider(m && m.location); }
      else consider(n.location);
    }
    return start !== undefined ? { start, end } : undefined;
  }

  // Convert a structured data type to its native AST node. Mirrors
  // ClickHouse's `EXPLAIN AST json=1` shape: a `type` discriminator plus an
  // explicit `name` string and optional `arguments` array. Every produced node
  // (and nested element) carries the `location` captured by `ColumnDataType` /
  // `ColumnDataTypeArg`.
  function dtNode(dt) {
    const name = dt.name;
    let node;
    if (ENUM_RE.test(name) && dt.args && dt.args.length === 1 && dt.args[0].kind === 'enumValues') {
      const vals = dt.args[0].values;
      const allExplicit = vals.every(
        (v) => v.value !== undefined && v.value !== null && v.name !== null,
      );
      if (allExplicit) {
        // ClickHouse's native AST exposes the explicit value pairs as a
        // `values` array of `{ name, value }` objects (value is numeric).
        node = { type: 'EnumDataType', name, values: vals.map((v) => ({ name: v.name, value: Number(v.value) })) };
      } else {
        const args = vals.map((v) => {
          if (v.name === null) return withLoc(lit('Null', null), dt.location);
          if (v.value !== undefined && v.value !== null) {
            return withLoc(fn(
              'equals',
              [withLoc(strLit(v.name), dt.location), withLoc(v.value.startsWith('-') ? intLit(v.value) : uintLit(v.value), dt.location)],
              { is_operator: true },
            ), dt.location);
          }
          return withLoc(strLit(v.name), dt.location);
        });
        node = { type: 'DataType', name, arguments: args };
      }
    } else if (ENUM_RE.test(name)) {
      node = { type: 'EnumDataType', name };
    } else if (MYSQL_INT_RE.test(name) && dt.args) {
      node = { type: 'DataType', name };
    } else if (dt.args === undefined) {
      node = { type: 'DataType', name };
    } else if (dt.args.length === 0) {
      node = { type: 'DataType', name, arguments: [] };
    } else if (/^Tuple$/i.test(name)) {
      // ClickHouse drops named-element names from the Tuple's native AST
      // shape; only the inner type is emitted per element.
      const args = dt.args.map((arg) => {
        if (arg.kind === 'namedField' || arg.kind === 'type') return dtNode(arg.type);
        return dtArgNode(arg, name, 0);
      });
      node = { type: 'TupleDataType', name, arguments: args };
      // ClickHouse's native AST exposes the named-element names as an
      // `element_names` string array (aligned with `arguments`) so format()
      // can re-emit `Tuple(x UInt8, ...)`.
      if (dt.args.some((arg) => arg.kind === 'namedField')) {
        node.element_names = dt.args.map((arg) => (arg.kind === 'namedField' ? arg.name : null));
      }
    } else if (/^Nested$/i.test(name)) {
      const args = dt.args.map((arg) => {
        if (arg.kind === 'namedField') {
          return withLoc({ type: 'NameTypePair', name: arg.name, data_type: dtNode(arg.type) }, arg.location);
        }
        if (arg.kind === 'type') return dtNode(arg.type);
        return dtArgNode(arg, name, 0);
      });
      node = { type: 'DataType', name, arguments: args };
    } else if (/^JSON$/i.test(name)) {
      const args = dt.args.map(jsonArgNode);
      node = { type: 'DataType', name, arguments: args };
    } else {
      const args = dt.args.map((arg, i) => dtArgNode(arg, name, i));
      node = { type: 'DataType', name, arguments: args };
    }
    return withLoc(node, dt.location);
  }

  function dtArgNode(arg, parentName, index) {
    if (arg.kind === 'type') {
      if (AGG_FN_RE.test(parentName) && index === 0) {
        const t = arg.type;
        if (t.args && t.args.length > 0) {
          return withLoc(fn(t.name, t.args.map((a, i) => dtArgNode(a, t.name, i))), arg.location);
        }
        return withLoc(ident([t.name]), arg.location);
      }
      return dtNode(arg.type);
    }
    if (arg.kind === 'namedField') {
      return withLoc({ type: 'NameTypePair', name: arg.name, data_type: dtNode(arg.type) }, arg.location);
    }
    if (arg.kind === 'literal') return withLoc(typeLitNode(arg.value), arg.location);
    if (arg.kind === 'enumValues') return withLoc({ type: 'EnumDataType', name: parentName }, arg.location);
    if (arg.kind === 'setting')
      return withLoc(fn('equals', [withLoc(ident([arg.name]), arg.location), arg.value], { is_operator: true }), arg.location);
    return withLoc(strLit(String(arg)), arg.location);
  }

  function jsonArgNode(arg) {
    if (arg.kind === 'namedField') {
      return withLoc({
        type: 'ObjectTypeArgument',
        path_with_type: withLoc({ type: 'ObjectTypedPath', name: arg.name, data_type: dtNode(arg.type) }, arg.location),
      }, arg.location);
    }
    if (arg.kind === 'setting') {
      return withLoc({
        type: 'ObjectTypeArgument',
        parameter: withLoc(fn('equals', [withLoc(ident([arg.name]), arg.location), arg.value], { is_operator: true }), arg.location),
      }, arg.location);
    }
    if (arg.kind === 'literal') {
      const skipRegexp = arg.value.match(/^SKIP REGEXP\s+(.+)$/);
      if (skipRegexp)
        return withLoc({ type: 'ObjectTypeArgument', skip_path_regexp: withLoc(strLit(decodeTypeStr(skipRegexp[1])), arg.location) }, arg.location);
      const skip = arg.value.match(/^SKIP\s+(.+)$/);
      if (skip) {
        const path = skip[1].replace(/`([^`]*)`/g, '$1');
        return withLoc({ type: 'ObjectTypeArgument', skip_path: withLoc(ident(path.split('.')), arg.location) }, arg.location);
      }
      return withLoc({ type: 'ObjectTypeArgument', skip_path_regexp: withLoc(typeLitNode(arg.value), arg.location) }, arg.location);
    }
    if (arg.kind === 'type') return withLoc({ type: 'ObjectTypeArgument', path_with_type: withLoc({ type: 'ObjectTypedPath', name: '', data_type: dtNode(arg.type) }, arg.location) }, arg.location);
    return withLoc({ type: 'ObjectTypeArgument' }, arg.location);
  }

  // A "function" engine/codec node: arguments [] both for no-parens and empty
  // parens (matching ClickHouse's JSON). `kind` is the ClickHouse
  // function-kind tag.
  function fnArgs(name, args, kindTag, l) {
    const node = fn(name, args !== undefined ? args : []);
    if (kindTag !== undefined) node.kind = kindTag;
    // ClickHouse's JSON AST shows `arguments: []` for both the no-parens form
    // (`ENGINE = MergeTree`) and the empty-parens form (`MergeTree()`), but its
    // EXPLAIN text and SHOW CREATE distinguish them. Mark the no-parens form so
    // format()/explain can re-emit it.
    if (args === undefined) node.no_parens = true;
    return withLoc(node, l ?? spanOf(args));
  }

  // CODEC(...) / STATISTICS(...) wrapper from structured CodecItem[].
  function codecNode(items, name, kindTag, l) {
    const inner = items.map((item) => fnArgs(item.name, item.args, undefined, item.location ?? l));
    return fnArgs(name, inner, kindTag, l ?? spanOf(inner));
  }

  // ColumnDeclaration native node. Mirrors ClickHouse's `EXPLAIN AST json=1`
  // shape: explicit `name`, `data_type`, default/codec/comment/ttl/settings
  // fields, plus the optional `null_modifier`, `primary_key_specifier`, and
  // `ephemeral_default` boolean flags the native AST exposes.
  function columnDeclNode(col) {
    const node = { type: 'ColumnDeclaration', name: col.name };
    if (col.type) node.data_type = dtNode(col.type);
    if (col.autoIncrement === true) node.default_specifier = 'AUTO_INCREMENT';
    else if (col.defaultKind) node.default_specifier = col.defaultKind;
    if (col.defaultExpr) {
      node.default_expression = col.defaultExpr;
    } else if (col.defaultKind === 'EPHEMERAL') {
      // ClickHouse synthesizes `defaultValueOfTypeName('TypeText')` for the
      // bare EPHEMERAL form (no explicit expression).
      node.default_expression = withLoc(fn('defaultValueOfTypeName', col.type ? [withLoc(strLit(fmtType(col.type)), col.location)] : []), col.location);
      node.ephemeral_default = true;
    }
    if (col.codec) node.codec = codecNode(col.codec, 'CODEC', 'CODEC', col.location);
    if (col.statistics) node.statistics = codecNode(col.statistics, 'STATISTICS', 'STATISTICS', col.location);
    if (col.columnSettings) node.settings = setNode(col.columnSettings);
    if (col.ttl) node.ttl = col.ttl;
    if (col.comment) node.comment = withLoc(strLit(col.comment), col.location);
    // Native flags. `null_modifier` is a boolean: true for NULL, false for
    // NOT NULL; omitted when the source did not specify either.
    if (col.nullable === 'NULL') node.null_modifier = true;
    else if (col.nullable === 'NOT NULL') node.null_modifier = false;
    if (col.primaryKey) node.primary_key_specifier = true;
    if (col.collate) {
      node.collation = withLoc({ type: 'Collation', name: col.collate }, col.location);
    }
    return withLoc(node, col.location);
  }

  function indexTypeName(indexType) {
    return indexType && typeof indexType.name === 'string'
      ? indexType.name.toLowerCase()
      : undefined;
  }

  // ClickHouse's default skip-index GRANULARITY when the source omits the
  // clause: `text` and `vector_similarity` indexes default to 100000000
  // (effectively whole-part), every other index type defaults to 1.
  function defaultIndexGranularity(indexType) {
    const name = indexTypeName(indexType);
    return name === 'text' || name === 'vector_similarity' ? 100000000 : 1;
  }

  // `text` (full-text/GIN) indexes always serialize GRANULARITY 100000000 in
  // the native AST, regardless of the value the source specified.
  function forcesIndexGranularity(indexType) {
    return indexTypeName(indexType) === 'text';
  }

  // Compute the native `granularity` plus any library-only fields the
  // formatter needs, then assign them onto an Index/index_declaration node.
  function assignIndexGranularity(node, indexType, explicit) {
    if (forcesIndexGranularity(indexType)) {
      // A `text` index forces granularity to 100000000 regardless of the
      // source value, so any explicit GRANULARITY is dropped (the formatter
      // canonically re-emits the forced native value).
      node.granularity = 100000000;
      return;
    }
    node.granularity = explicit !== undefined ? explicit : defaultIndexGranularity(indexType);
  }

  // Build an Index native node from an indexDef table element. The formatter
  // always re-emits the (canonical) GRANULARITY clause from `granularity`.
  function indexElNode(el) {
    const node = { type: 'Index' };
    if (el.name !== undefined) node.name = el.name;
    if (el.expr !== undefined) node.expression = el.expr;
    if (el.indexType !== undefined) node.index_type = indexTypeNode(el.indexType);
    assignIndexGranularity(node, el.indexType, el.granularity);
    return withLoc(node, el.location ?? spanOf([node.expression, node.index_type]));
  }

  function indexTypeNode(it) {
    return withLoc(fnArgs(it.name, it.args), it.location ?? spanOf(it.args));
  }

  // Storage native node — mirrors ClickHouse's `EXPLAIN AST json=1` shape
  // with explicit `engine`/`partition_by`/`primary_key`/`order_by`/... fields.
  function storageNode(stmt) {
    const node = { type: 'Storage' };
    if (stmt.engine) node.engine = fnArgs(stmt.engine.name, stmt.engine.args, 'TABLE_ENGINE', stmt.engine.location);
    if (stmt.partitionBy) node.partition_by = stmt.partitionBy;

    const pk = stmt.primaryKey || stmt.primaryKeyInSchema;
    const storagePkFromColumns = (stmt.tableElements || []).some(
      (el) => el.kind === 'columnDef' && el.primaryKey,
    );
    if (pk) {
      node.primary_key = storagePkFromColumns
        ? withLoc(fn('tuple', pk, { is_operator: true }), spanOf(pk))
        : pkExprNode(pk);
    }
    if (stmt.orderBy) {
      node.order_by = storageOrderByNode(stmt.orderBy);
    }
    if (stmt.sampleBy) node.sample_by = stmt.sampleBy;
    if (stmt.ttl) {
      node.ttl_table = exprList(stmt.ttl.map(ttlElementNode));
    }
    if (stmt.settings) node.settings = setNode(stmt.settings);
    // ClickHouse's Storage node stores clauses as named fields, losing their
    // source order. The `SETTINGS`-after-ORDER-BY position is load-bearing for
    // EXPLAIN (the native `Set` child order follows the source), so keep that
    // flag. `PRIMARY KEY` position has no such effect: format() canonicalizes
    // it to ClickHouse's `PRIMARY KEY` … `ORDER BY` order.
    if (stmt.settingsAfterOrderBy === true) node.settings_after_order_by = true;
    // Empty when none of the optional fields applied.
    if (
      node.engine === undefined &&
      node.partition_by === undefined &&
      node.primary_key === undefined &&
      node.order_by === undefined &&
      node.sample_by === undefined &&
      node.ttl_table === undefined &&
      node.settings === undefined
    ) {
      return null;
    }
    return withLoc(node, spanOf([node.engine, node.partition_by, node.primary_key, node.order_by, node.sample_by, node.ttl_table, node.settings]));
  }

  // ALTER ... RESET SETTING a, b → ClickHouse stores the setting names as an
  // ExpressionList of Identifiers in `settings_resets`.
  function settingResetsNode(names, l) {
    const children = names.map((n) => withLoc(ident([n]), l));
    return withLoc({
      type: 'ExpressionList',
      children,
    }, l ?? spanOf(children));
  }

  // Build the native RefreshStrategy node from a parsed RefreshClause. Mirrors
  // ClickHouse's full shape: `schedule_kind` (EVERY/AFTER), `period` /
  // `offset` / `spread` (TimeInterval), `dependencies` (ExpressionList of
  // TableIdentifier), `settings` (Settings), and an `append` flag.
  function refreshStrategyNode(r) {
    const node = { type: 'RefreshStrategy', schedule_kind: r.schedule_kind };
    if (r.append) node.append = true;
    if (r.period !== undefined) node.period = r.period;
    if (r.offset !== undefined) node.offset = r.offset;
    if (r.spread !== undefined) node.spread = r.spread;
    if (r.dependencies !== undefined) node.dependencies = r.dependencies;
    if (r.settings !== undefined) node.settings = setNode(r.settings);
    return withLoc(node, r.location ?? spanOf([node.period, node.offset, node.spread, node.dependencies, node.settings]));
  }

  // A `DEPENDS ON` table reference → native TableIdentifier.
  function refreshDepIdent(t) {
    const ti = { type: 'TableIdentifier', name: t.table };
    if (t.database !== undefined) ti.database = t.database;
    return withLoc(ti, t.location);
  }

  // Build a TTLElement from a parsed TTL temp ({mode?, expr, where?, ...}).
  // Default mode is `DELETE` when none is specified (matches ClickHouse's
  // native AST shape, which always emits `mode`).
  function ttlElementNode(item) {
    const node = { type: 'TTLElement' };
    node.mode = item.mode !== undefined ? item.mode : 'DELETE';
    node.ttl = item.expr;
    if (item.where !== undefined) node.where = item.where;
    if (item.mode === 'MOVE') {
      node.destination_type = item.destinationType;
      node.destination_name = item.destinationName;
      if (item.ifExists) node.if_exists = true;
    } else if (item.mode === 'RECOMPRESS' && item.codec !== undefined) {
      node.recompression_codec = codecNode(item.codec, 'CODEC', 'CODEC', item.location);
    } else if (item.mode === 'GROUP_BY') {
      // ClickHouse exposes the GROUP BY keys as `group_by_key` and the SET
      // assignments as `group_by_assignments` (Assignment nodes).
      if (item.groupBy !== undefined && item.groupBy.length > 0) node.group_by_key = item.groupBy;
      if (item.set !== undefined && item.set.length > 0) {
        node.group_by_assignments = item.set.map((s) => withLoc({
          type: 'Assignment',
          column: s.name && s.name.type === 'Identifier' ? s.name.name : s.name,
          expression: s.value,
        }, s.location ?? spanOf([s.value])));
      }
    }
    return withLoc(node, item.location ?? spanOf([node.ttl, node.where, node.recompression_codec, node.group_by_key, node.group_by_assignments]));
  }

  // ORDER BY child for Storage. ClickHouse drops the DESC marker but preserves
  // the expressions (wrapping each item in StorageOrderByElement when any item
  // is DESC). Single ASC is a bare expr; single DESC is StorageOrderByElement;
  // multi-ASC is tuple(exprs); multi-with-DESC is tuple(StorageOrderByElement,
  // ...). The original ordering (with dirs) is stashed on `_order_by` for the
  // formatter.
  function storageOrderByNode(orderBy) {
    const hasDesc = orderBy.some((o) => o.dir === 'DESC');
    const parenthesized = !!orderBy.parenthesized;
    const sobe = (expr, dir) => withLoc({
      type: 'StorageOrderByElement',
      expression: expr,
      direction: dir === 'DESC' ? 'DESC' : 'ASC',
    }, spanOf([expr]));
    if (orderBy.length === 1) {
      const item = orderBy[0];
      if (item.dir === 'DESC') {
        // Single-DESC: unparenthesized → bare StorageOrderByElement;
        // parenthesized `(c desc)` → `tuple(StorageOrderByElement(c))`.
        if (parenthesized) { const el = sobe(item.expr, 'DESC'); return withLoc(fn('tuple', [el]), spanOf([el])); }
        return sobe(item.expr, 'DESC');
      }
      return item.expr;
    }
    if (hasDesc) {
      // Multi-with-DESC emits `tuple(SOBE(c1), SOBE(c2), ...)` — every item is
      // wrapped in a StorageOrderByElement carrying its own ASC/DESC direction
      // (the reverse-sorting-key feature; original dirs also live on
      // `_order_by` for format).
      const els = orderBy.map((o) => sobe(o.expr, o.dir));
      return withLoc(fn('tuple', els), spanOf(els));
    }
    const exprs = orderBy.map((o) => o.expr);
    return withLoc(fn(
      'tuple',
      exprs,
      parenthesized ? { is_operator: true } : undefined,
    ), spanOf(exprs));
  }

  // Columns definition native node from a list of table elements. `pkInColsDef`
  // is the primary-key expression list to embed in the Columns node (schema-level
  // PRIMARY KEY or promoted column-level PRIMARY KEY); `pkFromColumns` selects the
  // tuple-vs-bare rendering.
  function columnsNode(tableElements, pkInColsDef, pkFromColumns) {
    const columns = [];
    const constraints = [];
    const indexes = [];
    const projections = [];
    for (const el of tableElements) {
      switch (el.kind) {
        case 'columnDef':
          columns.push(columnDeclNode(el));
          break;
        case 'constraintDef':
          constraints.push(constraintNode(el));
          break;
        case 'indexDef':
          indexes.push(indexElNode(el));
          break;
        case 'projectionDef':
          projections.push(projectionNode(el));
          break;
      }
    }
    const node = withLoc({ type: 'Columns', columns }, spanOf([columns, constraints, indexes, projections]));
    if (constraints.length > 0) node.constraints = constraints;
    if (indexes.length > 0) node.indices = indexes;
    if (projections.length > 0) node.projections = projections;
    if (pkInColsDef) {
      // Column-level PRIMARY KEY modifiers produce the dedicated
      // `primary_key_from_columns` field (a tuple of the column refs);
      // a schema-level PRIMARY KEY uses `primary_key` with the expression
      // directly.
      if (pkFromColumns) {
        node.primary_key_from_columns = withLoc(fn('tuple', pkInColsDef, { is_operator: true }), spanOf(pkInColsDef));
      } else {
        node.primary_key = pkExprNode(pkInColsDef);
      }
    }
    return node;
  }

  function constraintNode(el) {
    return withLoc({
      type: 'Constraint',
      name: el.name,
      constraint_type: el.constraintType,
      expression: el.expr,
    }, el.location ?? spanOf([el.expr]));
  }

  // ClickHouse normalizes a projection's ORDER BY into a single sort-key
  // expression (the same way a storage ORDER BY is built: a lone key stays
  // bare, multiple keys are wrapped in `tuple(...)`, DESC keys in
  // `StorageOrderByElement`). The native `order_by` field then serializes the
  // CHILDREN of that key node: a leaf key (Identifier/Literal) has none, so
  // `order_by` is `[]`; a Function/tuple key carries its arguments in a single
  // `ExpressionList` child. The original clause is kept in `_create` for
  // format(), so this lossy shape is only used for the AST view.
  // A projection's `ORDER BY` keys serialize as a flat list of the key
  // expressions (projections don't allow DESC or grouping sets, so no
  // wrapping is needed). Matches ClickHouse's `ProjectionSelectQuery.order_by`.
  function projectionOrderByChildren(orderBy) {
    return orderBy.map((o) => o.expression);
  }

  function projectionNode(el) {
    if (el.indexExpr) {
      // ClickHouse's native AST exposes the projection-index TYPE as `index_type`.
      const node = { type: 'Projection', name: el.name, index: el.indexExpr };
      if (el.indexType) node.index_type = indexTypeNode(el.indexType);
      return withLoc(node, el.location ?? spanOf([node.index, node.index_type]));
    }
    const q = el.query;
    const psq = { type: 'ProjectionSelectQuery' };
    if (q.with && q.with.length > 0) psq.with = q.with;
    if (q.select) psq.select = q.select;
    if (q.group_by && !q.group_by_with_grouping_sets) psq.group_by = q.group_by;
    if (q.order_by && q.order_by.length > 0) {
      psq.order_by = projectionOrderByChildren(q.order_by);
    }
    withLoc(psq, spanOf([psq.with, psq.select, psq.group_by, psq.order_by]));
    const node = { type: 'Projection', name: el.name, query: psq };
    if (el.projectionSettings) node.settings = setNode(el.projectionSettings);
    return withLoc(node, el.location ?? spanOf([psq, node.settings]));
  }

  // CreateQuery node for CREATE/ATTACH/REPLACE TABLE. Native shape uses
  // explicit fields (table/database/columns_list/storage/select/...) matching
  // ClickHouse's `EXPLAIN AST json=1` output. Library-only `_create` carries
  // the parser's structured payload for round-trip formatting.
  function createTableNode(stmt) {
    const tableElements = stmt.tableElements || [];
    const pkFromColumns = tableElements.some((el) => el.kind === 'columnDef' && el.primaryKey);
    const pkInColsDef =
      stmt.primaryKeyInSchema ||
      (stmt.primaryKey && pkFromColumns ? stmt.primaryKey : undefined);

    const node = { type: stmt.attach ? 'AttachQuery' : 'CreateQuery' };
    if (stmt.attach) node.attach = true;
    if (stmt.table.database !== undefined) node.database = identLoc([stmt.table.database], stmt.table.location);
    node.table = identLoc([stmt.table.table], stmt.table.location);
    // ClickHouse treats `CREATE OR REPLACE TABLE` as a REPLACE under the
    // hood, so it carries both flags in the native AST.
    if (stmt.replace === true || stmt.orReplace === true) node.replace_table = true;
    if (stmt.orReplace === true) node.create_or_replace = true;
    if (stmt.temporary === true) node.temporary = true;
    if (stmt.empty === true) node.is_create_empty = true;
    if (stmt.ifNotExists === true) node.if_not_exists = true;
    if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
    if (stmt.uuid !== undefined) node.uuid = stmt.uuid;

    const hasColumns = tableElements.length > 0 || stmt.primaryKeyInSchema;
    if (hasColumns) node.columns_list = columnsNode(tableElements, pkInColsDef, pkFromColumns);
    const storage = storageNode(stmt);
    if (storage) node.storage = storage;
    if (stmt.asTable !== undefined) {
      // `ATTACH TABLE t AS [NOT] REPLICATED` is a conversion command, not an
      // `AS <table>` clone. ClickHouse exposes it as a boolean
      // `attach_as_replicated` (true for REPLICATED, false for NOT REPLICATED).
      if (
        stmt.attach === true &&
        stmt.asTable.database === undefined &&
        /^(NOT\s+)?REPLICATED$/i.test(stmt.asTable.table)
      ) {
        node.attach_as_replicated = !/^NOT\b/i.test(stmt.asTable.table);
      } else {
        if (stmt.clone === true) node.is_clone_as = true;
        if (stmt.asTable.database !== undefined) node.as_database = stmt.asTable.database;
        node.as_table = stmt.asTable.table;
      }
    }
    if (stmt.asTableFunction)
      node.as_table_function = fnArgs(stmt.asTableFunction.name, stmt.asTableFunction.args);
    if (stmt.asQuery) node.select = stmt.asQuery;
    if (stmt.comment !== undefined) node.comment = withLoc(strLit(stmt.comment), stmt.table && stmt.table.location);
    if (stmt.querySettings) node.settings = setNode(stmt.querySettings);
    if (stmt.format !== undefined) node.format = stmt.format;
    // `ATTACH TABLE t FROM '/path'` source path.
    if (stmt.attachFromPath !== undefined) node.attach_from_path = stmt.attachFromPath;

    return node;
  }

  // CreateQuery node for CREATE DATABASE.
  function createDatabaseNode(stmt) {
    const node = { type: 'CreateQuery', database: identLoc([stmt.name], stmt.location) };
    if (stmt.ifNotExists === true) node.if_not_exists = true;
    if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
    const storage = { type: 'Storage' };
    let storageHas = false;
    if (stmt.engine) {
      storage.engine = fnArgs(stmt.engine.name, stmt.engine.args, 'DATABASE_ENGINE', stmt.engine.location);
      storageHas = true;
    }
    if (stmt.orderBy && stmt.orderBy.length === 1 && !stmt.orderBy[0].dir) {
      storage.order_by = stmt.orderBy[0].expr;
      storageHas = true;
    }
    if (stmt.settings) {
      // ClickHouse's DATABASE_ENGINE storage only carries `SETTINGS` when an
      // engine (or other storage clause) is present; a bare `CREATE DATABASE db
      // SETTINGS ...` attaches them at the query level with no Storage node.
      if (storageHas) storage.settings = setNode(stmt.settings);
      else node.settings = setNode(stmt.settings);
    }
    if (storageHas) node.storage = withLoc(storage, stmt.engine ? stmt.engine.location : spanOf([storage.engine, storage.order_by, storage.settings]));
    if (stmt.comment !== undefined) node.comment = withLoc(strLit(stmt.comment), stmt.location);
    if (stmt.format !== undefined) node.format = stmt.format;
    return node;
  }

  // Columns definition for views/MVs: bare column aliases become a plain
  // ExpressionList of Identifiers; typed columns (+indexes/projections/pk) use a
  // Columns node. Returns the child node, or null when there are no elements.
  function viewColumnsNode(stmt) {
    const els = stmt.tableElements || [];
    const columns = els.filter((el) => el.kind === 'columnDef');
    if (columns.length === 0 && !stmt.primaryKeyInSchema) {
      // MV may still carry indexes/projections
      if (!els.some((el) => el.kind === 'indexDef' || el.kind === 'projectionDef')) return null;
    }
    const allBare = columns.length > 0 && columns.every((c) => !c.type);
    if (allBare) {
      return exprList(columns.map((c) => withLoc(ident([c.name]), c.location)));
    }
    const colPkExprs = columns
      .filter((el) => el.primaryKey)
      .map((el) => withLoc(ident([el.name]), el.location));
    const pkFromColumns = colPkExprs.length > 0;
    const pkInColsDef =
      stmt.primaryKeyInSchema ||
      (stmt.primaryKey && pkFromColumns ? stmt.primaryKey : undefined) ||
      (pkFromColumns ? colPkExprs : undefined);
    return columnsNode(els, pkInColsDef, pkFromColumns);
  }

  function createViewNode(stmt) {
    const node = { type: stmt.attach ? 'AttachQuery' : 'CreateQuery' };
    if (stmt.attach) node.attach = true;
    if (stmt.table.database !== undefined) node.database = identLoc([stmt.table.database], stmt.table.location);
    node.table = identLoc([stmt.table.table], stmt.table.location);
    if (stmt.temporary === true) node.temporary = true;
    if (stmt.ifNotExists === true) node.if_not_exists = true;
    if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
    node.is_ordinary_view = true;
    // `CREATE OR REPLACE VIEW` carries `replace_view: true`, not the
    // table-shape `create_or_replace`.
    if (stmt.orReplace === true) node.replace_view = true;
    // A bare column-name list on an ordinary view (`CREATE VIEW v (a, b) AS
    // ...`) is stored by ClickHouse as `aliases` (an Identifier array), not a
    // `columns_list` schema.
    const viewEls = stmt.tableElements || [];
    const viewCols = viewEls.filter((el) => el.kind === 'columnDef');
    const viewAllBare = viewCols.length > 0 && viewCols.every((c) => !c.type);
    if (viewAllBare && !stmt.primaryKeyInSchema) {
      node.aliases = viewCols.map((c) => withLoc(ident([c.name]), c.location));
    } else {
      const cols = viewColumnsNode(stmt);
      if (cols) node.columns_list = cols;
    }
    if (stmt.asQuery) node.select = stmt.asQuery;
    if (stmt.comment !== undefined) node.comment = withLoc(strLit(stmt.comment), stmt.table && stmt.table.location);
    return node;
  }

  function createMaterializedViewNode(stmt) {
    const node = { type: stmt.attach ? 'AttachQuery' : 'CreateQuery' };
    if (stmt.attach) node.attach = true;
    if (stmt.table.database !== undefined) node.database = identLoc([stmt.table.database], stmt.table.location);
    node.table = identLoc([stmt.table.table], stmt.table.location);
    if (stmt.ifNotExists === true) node.if_not_exists = true;
    if (stmt.orReplace === true) node.replace_view = true;
    if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
    if (stmt.uuid !== undefined) node.uuid = stmt.uuid;
    node.is_materialized_view = true;
    // Native AST exposes the full structured `RefreshStrategy`.
    if (stmt.refresh !== undefined) {
      node.refresh = refreshStrategyNode(stmt.refresh);
    }
    if (stmt.populate === true) node.is_populate = true;
    if (stmt.empty === true) node.is_create_empty = true;
    const cols = viewColumnsNode(stmt);
    if (cols) node.columns_list = cols;
    // ViewTargets: TO-table form carries the target table name; otherwise
    // the inner Storage (engine/order/pk) is captured under `inner_engine`.
    const tloc = stmt.table.location;
    if (stmt.toTable) {
      const target = { kind: 'to' };
      if (stmt.toTable.database !== undefined) target.database = stmt.toTable.database;
      target.table = stmt.toTable.table;
      node.targets = withLoc({ type: 'ViewTargets', targets: [target] }, stmt.toTable.location ?? tloc);
    } else if (
      stmt.engine ||
      stmt.orderBy ||
      stmt.primaryKey ||
      stmt.primaryKeyInSchema ||
      (stmt.tableElements || []).some((el) => el.kind === 'columnDef' && el.primaryKey)
    ) {
      const innerStorage = mvViewTargetStorage(stmt);
      node.targets = innerStorage !== null
        ? withLoc({ type: 'ViewTargets', targets: [{ kind: 'to', inner_engine: innerStorage }] }, spanOf([innerStorage]) ?? tloc)
        : withLoc({ type: 'ViewTargets' }, tloc);
    }
    if (stmt.asQuery) node.select = stmt.asQuery;
    if (stmt.comment !== undefined) node.comment = withLoc(strLit(stmt.comment), tloc);
    if (stmt.format !== undefined) node.format = stmt.format;
    return node;
  }

  // Inner-table Storage for an MV's ViewTargets. ClickHouse stores the inner
  // engine like a normal table's Storage (PRIMARY KEY stays in `primary_key`;
  // it is not promoted to `order_by`). A column-level PRIMARY KEY on the MV's
  // schema becomes the inner engine's `primary_key` (as a `tuple(...)`).
  function mvViewTargetStorage(stmt) {
    const node = storageNode(stmt);
    if (node && node.primary_key === undefined) {
      const colPk = (stmt.tableElements || [])
        .filter((el) => el.kind === 'columnDef' && el.primaryKey)
        .map((el) => withLoc(ident([el.name]), el.location));
      if (colPk.length > 0) node.primary_key = withLoc(fn('tuple', colPk, { is_operator: true }), spanOf(colPk));
    }
    return node;
  }

  function createFunctionNode(stmt) {
    const node = { type: 'CreateFunctionQuery' };
    if (stmt.orReplace) node.or_replace = true;
    if (stmt.ifNotExists) node.if_not_exists = true;
    node.function_name = identLoc([stmt.name], stmt.location);
    node.function_core = stmt.functionExpr;
    if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
    return node;
  }

  function createIndexNode(stmt) {
    let indexExpr;
    if (stmt.indexExpr) {
      if (stmt.indexExpr.type === 'Function' && stmt.indexExpr.name === 'tuple') {
        // Multi-column index expression `(c1, c2, ...)` is emitted as a
        // parenthesized tuple operator (the per-column DESC direction
        // markers are dropped to match ClickHouse).
        indexExpr = withLoc(fn('tuple', stmt.indexExpr.arguments, { is_operator: true }), stmt.indexExpr.location ?? spanOf(stmt.indexExpr.arguments));
      } else {
        indexExpr = stmt.indexExpr;
      }
    }
    const indexDecl = {
      type: 'Index',
      name: stmt.indexName,
    };
    if (indexExpr !== undefined) indexDecl.expression = indexExpr;
    if (stmt.indexType) indexDecl.index_type = indexTypeNode(stmt.indexType);
    withLoc(indexDecl, spanOf([indexExpr, indexDecl.index_type]) ?? stmt.location);
    // ClickHouse defaults GRANULARITY by index type when not specified; the
    // formatter canonically re-emits it from `granularity`.
    assignIndexGranularity(indexDecl, stmt.indexType, stmt.granularity);
    const node = {
      type: 'CreateIndexQuery',
      table: identLoc([stmt.table.table], stmt.table.location),
      index_name: identLoc([stmt.indexName], stmt.location ?? stmt.table.location),
      index_declaration: indexDecl,
    };
    // ClickHouse's native AST carries a qualified target's database as a
    // separate `Identifier` field (emitted before `table`).
    if (stmt.table.database !== undefined) node.database = identLoc([stmt.table.database], stmt.table.location);
    if (stmt.ifNotExists) node.if_not_exists = true;
    if (stmt.unique) node.unique = true;
    return node;
  }

  // Dictionary attribute declaration → native node.
  function dictAttrNode(attr) {
    const node = {
      type: 'DictionaryAttributeDeclaration',
      name: attr.name,
      data_type: dtNode(attr.type),
    };
    if (attr.defaultValue !== undefined) node.default_value = attr.defaultValue;
    if (attr.expression !== undefined) node.expression = attr.expression;
    if (attr.hierarchical === true) node.hierarchical = true;
    if (attr.injective === true) node.injective = true;
    if (attr.isObjectId === true) node.is_object_id = true;
    if (attr.bidirectional === true) node.bidirectional = true;
    return withLoc(node, attr.location ?? spanOf([node.data_type, node.default_value, node.expression]));
  }

  function dictSourcePairNode(p) {
    if (Array.isArray(p.value)) {
      // Nested struct (e.g. `SETTINGS(...)`) — pair value is itself an
      // ExpressionList of pairs.
      const structPairs = p.value.map((sp) => {
        const dt = sp.type;
        const inner = dt.args && dt.args.length > 0
          ? withLoc(fnArgs(dt.name, dt.args.map((a, i) => dtArgNode(a, dt.name, i))), dt.location ?? spanOf(dt.args))
          : withLoc(ident([dt.name]), dt.location);
        // ClickHouse lowercases key-value argument keys in its native AST.
        return withLoc({ type: 'pair', key: sp.name.toLowerCase(), value: inner }, sp.location ?? spanOf([inner]));
      });
      return withLoc({
        type: 'pair',
        key: p.name.toLowerCase(),
        value: exprList(structPairs),
      }, p.location ?? spanOf(structPairs));
    }
    return withLoc({ type: 'pair', key: p.name.toLowerCase(), value: p.value }, p.location ?? spanOf([p.value]));
  }

  function createDictionaryNode(stmt) {
    const node = { type: stmt.attach ? 'AttachQuery' : 'CreateQuery' };
    if (stmt.attach) node.attach = true;
    node.is_dictionary = true;
    if (stmt.table.database !== undefined) node.database = identLoc([stmt.table.database], stmt.table.location);
    node.table = identLoc([stmt.table.table], stmt.table.location);
    if (stmt.replace === true || stmt.orReplace === true) node.replace_table = true;
    if (stmt.orReplace === true) node.create_or_replace = true;
    if (stmt.ifNotExists === true) node.if_not_exists = true;
    if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
    if (stmt.dictAttrs && stmt.dictAttrs.length > 0) {
      node.dictionary_attributes = stmt.dictAttrs.map(dictAttrNode);
    }
    if (stmt.dictDef) {
      const dd = stmt.dictDef;
      const dict = { type: 'Dictionary' };
      if (dd.primaryKey) {
        const pkExprs = [];
        for (const pk of dd.primaryKey) {
          if (pk.type === 'Function' && pk.name === 'tuple' && pk.is_operator === true) pkExprs.push(...pk.arguments);
          else if (pk.type === 'Literal' && pk.value_type === 'Tuple' && Array.isArray(pk.value))
            pkExprs.push(...pk.value.map(elemToExpr));
          else pkExprs.push(pk);
        }
        dict.primary_key = pkExprs;
      }
      if (dd.source) {
        const elements = dd.source.pairs.map(dictSourcePairNode);
        dict.source = withLoc({
          type: 'FunctionWithKeyValueArguments',
          name: dd.source.name,
          elements,
        }, dd.source.location ?? spanOf(elements) ?? stmt.table.location);
      }
      if (dd.lifetime) {
        const lt = { type: 'DictionaryLifetime' };
        if (dd.lifetime.value !== undefined) {
          // `LIFETIME(value)` shorthand — ClickHouse expands it to MIN 0 MAX value.
          lt.min_sec = 0;
          lt.max_sec = dd.lifetime.value;
        } else {
          if (dd.lifetime.min !== undefined) lt.min_sec = dd.lifetime.min;
          if (dd.lifetime.max !== undefined) lt.max_sec = dd.lifetime.max;
        }
        dict.lifetime = lt;
      }
      if (dd.layout) {
        dict.layout = {
          type: 'DictionaryLayout',
          // ClickHouse lowercases the layout type and parameter keys in its
          // native AST (`format()` re-uppercases them from `_create`).
          layout_type: dd.layout.name.toLowerCase(),
          parameters: dd.layout.pairs.map((p) => withLoc({
            type: 'pair',
            key: p.name.toLowerCase(),
            value: p.value,
          }, p.location ?? spanOf([p.value]))),
        };
      }
      if (dd.range) {
        // `dd.range` is the parsed `MIN x MAX y` pair list; the native AST
        // stores the bare attribute names.
        const range = { type: 'DictionaryRange' };
        for (const item of dd.range) {
          const attrName =
            item.value && item.value.type === 'Identifier' ? item.value.name : undefined;
          if (/^MIN$/i.test(item.name)) range.min_attr_name = attrName;
          else if (/^MAX$/i.test(item.name)) range.max_attr_name = attrName;
        }
        dict.range = range;
      }
      if (dd.settings) dict.settings = setNode(dd.settings, 'DictionarySettings');
      withLoc(dict, dd.location ?? spanOf([dict.primary_key, dict.source, dict.settings]) ?? stmt.table.location);
      node.dictionary = dict;
      if (dd.comment) node.comment = withLoc(strLit(dd.comment), stmt.table.location);
    }
    return node;
  }

  // Build the Partition / Partition_ID child node for the main ALTER partition
  // commands (DROP/ATTACH/REPLACE/MOVE/FETCH/FREEZE PARTITION etc). Mirrors
  // explain.ts `partitionNode`: 'all' and 'id' both produce a `Partition_ID`
  // node (no `_all` marker — bare `{type:'Partition_ID'}` for ALL); expression
  // partitions produce a `Partition` node carrying the expression child.
  function alterPartitionNode(part) {
    if (part.partitionKind === 'all') return withLoc({ type: 'Partition_ID', all: true }, part.location);
    if (part.partitionKind === 'id') return withLoc({ type: 'Partition_ID', id: part.id }, part.location ?? spanOf([part.id]));
    return withLoc({ type: 'Partition', value: part.expr }, part.location ?? spanOf([part.expr]));
  }

  // Identifier from a (possibly qualified) column-ref name + parts pair.
  // `parts` carries the original segments (`['n','d']` for unquoted `n.d`,
  // `['n.d']` for backtick-quoted `\`n.d\``) so the resulting Identifier
  // carries `name_parts` only when the ref was qualified. When `parts` is
  // absent (legacy/single-segment), falls back to a flat-name Identifier.
  function colRefIdent(name, parts, l) {
    if (parts && parts.length > 1) return withLoc(ident(parts), l);
    return withLoc(ident([name]), l);
  }

  // Build one AlterCommand native node. Mirrors ClickHouse's `EXPLAIN AST
  // json=1` shape: explicit fields for each operand (`column_declaration`,
  // `column`, `partition`, `predicate`, `assignments`, `rename_to`, ...).
  // The library-only `_alter` payload on the parent AlterQuery still
  // carries the structured command for the formatters.
  function alterCommandNativeNode(cmd) {
    const node = { type: 'AlterCommand', command_type: cmd.commandType };
    // The native AST drops the `(...)` wrapping around a command, and this
    // library does not preserve it either: the parser still accepts a
    // parenthesized command (the parse-time `cmd.parenthesized` flag) but does
    // not record it on the node. `format()` re-derives the required wrapping
    // from the command_type sequence (see docs/underscore-fields.md, "Case
    // study: _command_parens").
    if (cmd.ifExists === true) node.if_exists = true;
    if (cmd.ifNotExists === true) node.if_not_exists = true;
    if (cmd.first === true) node.first = true;
    switch (cmd.commandType) {
      case 'ADD_COLUMN':
        if (cmd.column) node.column_declaration = columnDeclNode(cmd.column);
        if (cmd.afterColumn) node.column = colRefIdent(cmd.afterColumn, cmd.afterColumnParts, cmd.location);
        break;
      case 'DROP_COLUMN':
        if (cmd.columnName) node.column = colRefIdent(cmd.columnName, cmd.columnNameParts, cmd.location);
        if (cmd.clear === true) node.clear_column = true;
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        break;
      case 'MODIFY_COLUMN': {
        if (cmd.column) node.column_declaration = columnDeclNode(cmd.column);
        const op = cmd.columnSettingOp;
        if (op) {
          if (op.op === 'RESET_SETTING' && op.names) {
            node.settings_resets = settingResetsNode(op.names, cmd.location);
          } else {
            node.settings_changes = setNode(op.settings || []);
          }
        }
        if (cmd.afterColumn) node.column = colRefIdent(cmd.afterColumn, cmd.afterColumnParts, cmd.location);
        if (cmd.removeProperty) node.remove_property = cmd.removeProperty;
        break;
      }
      case 'RENAME_COLUMN':
        if (cmd.oldName) node.column = colRefIdent(cmd.oldName, cmd.oldNameParts, cmd.location);
        if (cmd.newName) node.rename_to = colRefIdent(cmd.newName, cmd.newNameParts, cmd.location);
        break;
      case 'COMMENT_COLUMN':
        if (cmd.columnName) node.column = colRefIdent(cmd.columnName, cmd.columnNameParts, cmd.location);
        if (cmd.comment) node.comment = cmd.comment;
        break;
      case 'MATERIALIZE_COLUMN':
        if (cmd.columnName) node.column = colRefIdent(cmd.columnName, cmd.columnNameParts, cmd.location);
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        break;
      case 'ADD_INDEX':
        if (cmd.index) node.index_declaration = indexElNode(cmd.index);
        if (cmd.afterIndex) node.index = withLoc(ident([cmd.afterIndex]), cmd.location);
        break;
      case 'DROP_INDEX':
      case 'MATERIALIZE_INDEX':
        if (cmd.clearIndex) node.clear_index = true;
        if (cmd.indexName) node.index = withLoc(ident([cmd.indexName]), cmd.location);
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        break;
      case 'ADD_PROJECTION':
        if (cmd.projection) node.projection_declaration = projectionNode(cmd.projection);
        break;
      case 'DROP_PROJECTION':
      case 'MATERIALIZE_PROJECTION':
        if (cmd.clearProjection) node.clear_projection = true;
        if (cmd.projectionName) node.projection = withLoc(ident([cmd.projectionName]), cmd.location);
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        break;

      case 'ADD_CONSTRAINT':
        if (cmd.constraint) {
          node.constraint_declaration = withLoc({
            type: 'Constraint',
            name: cmd.constraint.name,
            constraint_type: cmd.constraint.constraintType,
            expression: cmd.constraint.expr,
          }, cmd.location ?? spanOf([cmd.constraint.expr]));
        }
        break;
      case 'DROP_CONSTRAINT':
        if (cmd.constraintName) node.constraint = withLoc(ident([cmd.constraintName]), cmd.location);
        break;
      case 'ADD_STATISTICS':
      case 'MODIFY_STATISTICS': {
        const sc = { type: 'Stat' };
        if (cmd.statColumns && cmd.statColumns.length > 0) {
          sc.columns = exprList(cmd.statColumns.map((c) => withLoc(ident([c]), cmd.location)));
        }
        if (cmd.statTypes && cmd.statTypes.length > 0) {
          sc.types = exprList(cmd.statTypes.map(indexTypeNode));
        }
        withLoc(sc, cmd.location ?? spanOf([sc.columns, sc.types]));
        node.statistics_declaration = sc;
        break;
      }
      case 'DROP_STATISTICS':
      case 'MATERIALIZE_STATISTICS':
        if (cmd.clear === true) node.clear_statistics = true;
        if (cmd.statColumns && cmd.statColumns.length > 0) {
          node.statistics_declaration = withLoc({
            type: 'Stat',
            columns: exprList(cmd.statColumns.map((c) => withLoc(ident([c]), cmd.location))),
          }, cmd.location);
        }
        break;
      case 'UPDATE':
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        if (cmd.where) node.predicate = cmd.where;
        if (cmd.assignments && cmd.assignments.length > 0) {
          node.assignments = cmd.assignments.map((a) => withLoc({
            type: 'Assignment',
            column: a.column,
            expression: a.expr,
          }, a.location ?? spanOf([a.expr])));
        }
        break;
      case 'DELETE':
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        if (cmd.where) node.predicate = cmd.where;
        break;
      case 'DROP_PARTITION':
      case 'DROP_DETACHED_PARTITION':
        if (cmd.partName) {
          // `DETACH/DROP PART 'name'` — the boolean `part: true` discriminates
          // this from the PARTITION form, and the name lives in `partition`.
          node.part = true;
          node.partition = cmd.partName;
        } else if (cmd.partition) {
          node.partition = alterPartitionNode(cmd.partition);
        }
        if (cmd.detach) node.detach = true;
        break;
      case 'ATTACH_PARTITION':
        if (cmd.partName) {
          node.part = true;
          node.partition = cmd.partName;
        } else if (cmd.partition) {
          node.partition = alterPartitionNode(cmd.partition);
        }
        if (cmd.fromTable) {
          const ft = cmd.fromTable;
          node.from_table = ft.database !== undefined
            ? `${ft.database}.${ft.table}`
            : ft.table;
        }
        break;
      case 'REPLACE_PARTITION':
      case 'FETCH_PARTITION':
      case 'FREEZE_PARTITION':
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        if (cmd.fromTable) {
          if (cmd.fromTable.database !== undefined) node.from_database = cmd.fromTable.database;
          node.from_table = cmd.fromTable.table;
        }
        if (cmd.toTable) {
          if (cmd.toTable.database !== undefined) node.to_database = cmd.toTable.database;
          node.to_table = cmd.toTable.table;
        }
        // REPLACE PARTITION FROM sets replace = true; ATTACH PARTITION FROM
        // shares the same command_type but sets replace = false.
        if (cmd.replace !== undefined) node.replace = cmd.replace;
        // FREEZE PARTITION ... WITH NAME 'x' stores the backup name.
        if (cmd.withName !== undefined) node.with_name = cmd.withName;
        // SYSTEM FETCH PARTITION ... FROM 'zk_path' stores the path verbatim.
        if (cmd.fromPath !== undefined) node.from = cmd.fromPath.value;
        break;
      case 'MOVE_PARTITION':
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        if (cmd.moveDest) node.move_destination_type = cmd.moveDest.destType;
        if (cmd.moveDest && cmd.moveDest.destType === 'TABLE') {
          const tt = cmd.moveDest.table;
          if (tt.database !== undefined) node.to_database = tt.database;
          node.to_table = tt.table;
        } else if (cmd.moveDest && cmd.moveDest.value) {
          node.move_destination_name = cmd.moveDest.value.value;
        }
        break;
      case 'FREEZE_ALL':
        if (cmd.withName !== undefined) node.with_name = cmd.withName;
        break;
      case 'MODIFY_TTL':
        if (cmd.ttl) {
          node.ttl = exprList(cmd.ttl.map(ttlElementNode));
        }
        break;
      case 'REMOVE_TTL':
      case 'REMOVE_SAMPLE_BY':
        // No operand.
        break;
      case 'MATERIALIZE_TTL':
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        break;
      case 'MODIFY_ORDER_BY':
        if (cmd.expr) node.order_by = cmd.expr;
        break;
      case 'MODIFY_SAMPLE_BY':
        if (cmd.expr) node.sample_by = cmd.expr;
        break;
      case 'MODIFY_SETTING':
        node.settings_changes = setNode(cmd.settings || []);
        break;
      case 'RESET_SETTING':
        if (cmd.settingNames && cmd.settingNames.length > 0) {
          node.settings_resets = settingResetsNode(cmd.settingNames, cmd.location);
        }
        break;
      case 'MODIFY_QUERY':
        if (cmd.query) node.select = cmd.query;
        break;
      case 'MODIFY_COMMENT':
        if (cmd.comment) node.comment = cmd.comment;
        break;
      case 'APPLY_DELETED_MASK':
      case 'APPLY_PATCHES':
      case 'REWRITE_PARTS':
        if (cmd.partition) node.partition = alterPartitionNode(cmd.partition);
        break;
      case 'MODIFY_REFRESH': {
        // ClickHouse exposes the full structured RefreshStrategy.
        node.refresh = refreshStrategyNode(cmd.refresh);
        break;
      }
    }
    return withLoc(node, cmd.location);
  }

  // Parse a comma-separated `name = value` SETTINGS tail from a SYSTEM body
  // into a Set node with a `changes` map. Values are decoded as best-effort
  // numbers / strings (matches ClickHouse's Set.changes JSON shape).
  function systemSettingsToSet(tail) {
    const changes = {};
    for (const pair of tail.split(/\s*,\s*/)) {
      const m = pair.match(/^(\w+)\s*=\s*(.+?)\s*;?\s*$/);
      if (!m) continue;
      const name = m[1];
      let raw = m[2];
      let value;
      if (/^-?\d+$/.test(raw)) value = raw;
      else if (/^-?\d*\.\d+$/.test(raw)) value = raw;
      else if (raw.startsWith("'") && raw.endsWith("'")) value = raw.slice(1, -1);
      else value = raw;
      changes[name] = value;
    }
    return { type: 'Settings', changes };
  }

  // Extract the native `system_type` keyword phrase and optional target
  // table/database from a SYSTEM body. Matches the patterns ClickHouse
  // serializes: a fixed list of subcommands that accept a target table,
  // separately from the keyword-only variants.
  function extractSystemFields(body) {
    const unquote = (s) =>
      s.startsWith('`') && s.endsWith('`') ? s.slice(1, -1) : s;
    // Strip the leading SYSTEM keyword.
    const stripped = body.replace(/^\s*SYSTEM\s+/i, '');
    const IDENT = '(?:`[^`]+`|[A-Za-z_0-9][A-Za-z0-9_]*)';
    const clusterMatch = stripped.match(new RegExp(`\\bON\\s+CLUSTER\\s+(${IDENT})`, 'i'));
    const cluster = clusterMatch ? unquote(clusterMatch[1]) : undefined;

    // DROP REPLICA / DROP DATABASE REPLICA '<name>' [FROM DATABASE db | FROM
    // TABLE [db.]tbl | FROM ZKPATH '<path>' | FROM SHARD '<shard>'].
    const dropReplicaMatch = stripped.match(
      /^DROP\s+(DATABASE\s+)?REPLICA\s+(?:'([^']*)'|`([^`]+)`|([A-Za-z_0-9][A-Za-z0-9_]*))(.*)$/i,
    );
    if (dropReplicaMatch) {
      const isDb = dropReplicaMatch[1] !== undefined;
      const replica =
        dropReplicaMatch[2] !== undefined
          ? dropReplicaMatch[2]
          : (dropReplicaMatch[3] !== undefined ? unquote('`' + dropReplicaMatch[3] + '`') : dropReplicaMatch[4]);
      const rest = dropReplicaMatch[5] || '';
      const fields = { system_type: isDb ? 'DROP DATABASE REPLICA' : 'DROP REPLICA', replica };
      const fromTbl = rest.match(new RegExp(`\\bFROM\\s+TABLE\\s+(${IDENT})(?:\\.(${IDENT}))?`, 'i'));
      const fromDb = rest.match(new RegExp(`\\bFROM\\s+DATABASE\\s+(${IDENT})`, 'i'));
      const fromZk = rest.match(/\bFROM\s+ZKPATH\s+'([^']*)'/i);
      const fromShard = rest.match(/\bFROM\s+SHARD\s+'([^']*)'/i);
      if (fromTbl) {
        if (fromTbl[2] !== undefined) {
          fields.database = ident([unquote(fromTbl[1])]);
          fields.table = ident([unquote(fromTbl[2])]);
        } else {
          fields.table = ident([unquote(fromTbl[1])]);
        }
      } else if (fromDb) {
        fields.database = ident([unquote(fromDb[1])]);
      }
      // An empty ZKPATH (`''`) is dropped by ClickHouse's native AST.
      if (fromZk && fromZk[1] !== '') fields.replica_zk_path = fromZk[1];
      if (fromShard) fields.shard = fromShard[1];
      if (cluster !== undefined) fields.cluster = cluster;
      return fields;
    }
    // Subcommands that take a target table. The regex captures the keyword
    // phrase and an optional `db.table` reference.
    const TARGETED = [
      'SYNC\\s+REPLICA',
      'SYNC\\s+DATABASE\\s+REPLICA',
      'STOP\\s+(?:MERGES|FETCHES|MOVES|REPLICATED\\s+SENDS|REPLICATION\\s+QUEUES|TTL\\s+MERGES|PULLING\\s+REPLICATION\\s+LOG|CLEANUP)',
      'START\\s+(?:MERGES|FETCHES|MOVES|REPLICATED\\s+SENDS|REPLICATION\\s+QUEUES|TTL\\s+MERGES|PULLING\\s+REPLICATION\\s+LOG|CLEANUP)',
      'RESTART\\s+REPLICA',
      'DROP\\s+REPLICA',
      'WAIT\\s+LOADING\\s+PARTS',
      'PREWARM\\s+MARK\\s+CACHE',
      'PREWARM\\s+PRIMARY\\s+INDEX\\s+CACHE',
      'REFRESH\\s+VIEW',
      'WAIT\\s+VIEW',
      'STOP\\s+VIEW',
      'START\\s+VIEW',
      'CANCEL\\s+VIEW',
      'FLUSH\\s+DISTRIBUTED',
      'STOP\\s+DISTRIBUTED\\s+SENDS',
      'START\\s+DISTRIBUTED\\s+SENDS',
      'LOAD\\s+PRIMARY\\s+KEY',
      'UNLOAD\\s+PRIMARY\\s+KEY',
      'RESTORE\\s+REPLICA',
      'RELOAD\\s+DICTIONARY',
      'DROP\\s+DICTIONARY\\s+CACHE',
    ];
    const targetRe = new RegExp(
      `^(${TARGETED.join('|')})(?:\\s+ON\\s+CLUSTER\\s+(${IDENT}))?\\s+(${IDENT})(?:\\.(${IDENT}))?(?:\\s+(PULL|LIGHTWEIGHT|STRICT))?(?:\\s|;|$|\\s+SETTINGS\\b)`,
      'i',
    );
    const tm = stripped.match(targetRe);
    if (tm) {
      const fields = { system_type: tm[1].replace(/\s+/g, ' ').toUpperCase() };
      const localCluster = tm[2] !== undefined ? unquote(tm[2]) : cluster;
      const first = tm[3];
      const second = tm[4];
      if (localCluster !== undefined) fields.cluster = localCluster;
      if (first !== undefined && second !== undefined) {
        fields.database = ident([unquote(first)]);
        fields.table = ident([unquote(second)]);
      } else if (first !== undefined) {
        // Database-targeting subcommands (e.g. SYNC DATABASE REPLICA) carry a
        // database name; everything else carries a table name.
        if (/\bDATABASE\b/.test(fields.system_type)) {
          fields.database = ident([unquote(first)]);
        } else {
          fields.table = ident([unquote(first)]);
        }
      }
      // SYNC REPLICA carries an optional wait mode (PULL / LIGHTWEIGHT /
      // STRICT); the default mode is dropped from the native AST.
      if (tm[5] !== undefined) fields.sync_replica_mode = tm[5].toUpperCase();
      // SYNC REPLICA ... LIGHTWEIGHT FROM '<r1>','<r2>' carries a source
      // replica list.
      if (fields.system_type === 'SYNC REPLICA') {
        const srcMatch = stripped.match(/\bFROM\s+((?:'[^']*'\s*,?\s*)+)/i);
        if (srcMatch) {
          const reps = srcMatch[1].match(/'([^']*)'/g);
          if (reps) fields.src_replicas = reps.map((r) => r.slice(1, -1));
        }
      }
      // A trailing SETTINGS clause (e.g. FLUSH DISTRIBUTED ... SETTINGS ...)
      // is serialized as a native `settings` field.
      const settingsMatch = stripped.match(/\bSETTINGS\b\s+(.+)$/i);
      if (settingsMatch) fields.settings = systemSettingsToSet(settingsMatch[1]);
      return fields;
    }
    // No target — everything (minus optional ON CLUSTER / SETTINGS) is the
    // system_type keyword phrase.
    const keywordOnly = stripped
      .replace(/\s+ON\s+CLUSTER\s+(?:`[^`]+`|[A-Za-z_0-9][A-Za-z0-9_]*)/i, '')
      .replace(/\s+SETTINGS\b.*$/i, '')
      .replace(/;\s*$/, '')
      .trim();
    let systemType = keywordOnly.replace(/\s+/g, ' ').toUpperCase();
    // ClickHouse canonicalizes the `DROP` spelling of cache-clearing commands
    // (DROP MARK CACHE, DROP FILESYSTEM CACHE, DROP SCHEMA CACHE, …) to `CLEAR`.
    // (DROP REPLICA / DROP DICTIONARY CACHE are handled earlier and never reach
    // this keyword-only branch.)
    if (systemType.startsWith('DROP ')) systemType = 'CLEAR ' + systemType.slice(5);
    // ClickHouse's native `system_type` is only the command keyword phrase;
    // trailing operands (log lists, failpoint names, target tables, `FOR x` /
    // `TAG '...'` arguments) are dropped from the serialized type. Truncate to
    // the canonical keyword phrase when one of these argument-bearing commands
    // is present so the AST matches `EXPLAIN AST json=1`.
    const KEYWORD_PHRASES_WITH_ARGS = [
      'FLUSH ASYNC INSERT QUEUE',
      'FLUSH LOGS',
      'DISABLE FAILPOINT',
      'ENABLE FAILPOINT',
      'CLEAR FORMAT SCHEMA CACHE',
      'CLEAR SCHEMA CACHE',
      'CLEAR FILESYSTEM CACHE',
      'CLEAR QUERY CACHE',
      'START LISTEN',
      'STOP LISTEN',
      'SUSPEND',
      'UNFREEZE',
    ];
    for (const phrase of KEYWORD_PHRASES_WITH_ARGS) {
      if (systemType === phrase || systemType.startsWith(phrase + ' ')) {
        systemType = phrase;
        break;
      }
    }
    const fields = { system_type: systemType };
    if (cluster !== undefined) fields.cluster = cluster;

    // Body with the leading keyword phrase / ON CLUSTER / SETTINGS removed, so
    // the trailing operand(s) can be parsed for the argument-bearing commands.
    // The source keyword may use the `DROP` spelling where `system_type` uses
    // `CLEAR`, so strip either form of the leading phrase.
    const clearPrefix = systemType.replace(/ /g, '\\s+');
    const dropPrefix = systemType.replace(/^CLEAR\b/, 'DROP').replace(/ /g, '\\s+');
    const args = stripped
      .replace(/\s+ON\s+CLUSTER\s+(?:`[^`]+`|[A-Za-z_0-9][A-Za-z0-9_]*)/i, '')
      .replace(/\s+SETTINGS\b.*$/i, '')
      .replace(/;\s*$/, '')
      .trim()
      .replace(new RegExp(`^(?:${clearPrefix}|${dropPrefix})\\b`, 'i'), '')
      .trim();

    // FLUSH LOGS / FLUSH ASYNC INSERT QUEUE carry an optional table list.
    if (systemType === 'FLUSH LOGS' || systemType === 'FLUSH ASYNC INSERT QUEUE') {
      const tables = parseSystemTableList(args, unquote);
      if (tables.length > 0) fields.tables = tables;
    } else if (systemType === 'ENABLE FAILPOINT' || systemType === 'DISABLE FAILPOINT') {
      // FAILPOINT commands carry the fail point identifier.
      if (args.length > 0) fields.fail_point_name = unquote(args);
    } else if (systemType === 'CLEAR QUERY CACHE') {
      // CLEAR QUERY CACHE [TAG '<tag>'].
      const tagMatch = args.match(/^TAG\s+'((?:[^'\\]|\\.)*)'/i);
      if (tagMatch) fields.query_result_cache_tag = tagMatch[1].replace(/\\(.)/g, '$1');
    } else if (systemType === 'CLEAR SCHEMA CACHE') {
      // CLEAR SCHEMA CACHE [FOR <storage>].
      const forMatch = args.match(/^FOR\s+([A-Za-z_0-9]+)/i);
      if (forMatch) fields.schema_cache_storage = forMatch[1].toUpperCase();
    } else if (systemType === 'CLEAR FORMAT SCHEMA CACHE') {
      // CLEAR FORMAT SCHEMA CACHE [FOR <format>].
      const forMatch = args.match(/^FOR\s+([A-Za-z_0-9]+)/i);
      if (forMatch) fields.schema_cache_format = forMatch[1];
    } else if (systemType === 'CLEAR FILESYSTEM CACHE') {
      // CLEAR FILESYSTEM CACHE ['<name>' [KEY <k> [OFFSET <n>]]].
      const nameMatch = args.match(/^'([^']*)'/);
      if (nameMatch) fields.filesystem_cache_name = nameMatch[1];
      const keyMatch = args.match(/\bKEY\s+([A-Za-z_0-9][A-Za-z0-9_]*)/i);
      if (keyMatch) fields.key_to_drop = keyMatch[1];
      const offMatch = args.match(/\bOFFSET\s+(-?\d+)/i);
      if (offMatch) fields.offset_to_drop = parseInt(offMatch[1], 10);
    } else if (systemType === 'SUSPEND') {
      // SUSPEND FOR <n> SECOND.
      const secMatch = args.match(/\bFOR\s+(-?\d+)\s+SECOND/i);
      if (secMatch) fields.seconds = parseInt(secMatch[1], 10);
    } else if (systemType === 'UNFREEZE') {
      // UNFREEZE WITH NAME '<name>'.
      const nameMatch = args.match(/\bWITH\s+NAME\s+'([^']*)'/i);
      if (nameMatch) fields.backup_name = nameMatch[1];
    } else if (systemType === 'START LISTEN' || systemType === 'STOP LISTEN') {
      // START|STOP LISTEN <server-type> [EXCEPT <t>, ...].
      fields.server_type = parseSystemServerType(args);
    }
    return fields;
  }

  // Parse a `SYSTEM START|STOP LISTEN` server-type operand into the native
  // `server_type` struct: `{ type, custom_name?, exclude_types? }`.
  function parseSystemServerType(str) {
    const s = str.trim();
    const customMatch = s.match(/^CUSTOM\s+'([^']*)'/i);
    if (customMatch) return { type: 'CUSTOM', custom_name: customMatch[1] };
    const exceptSplit = s.split(/\s+EXCEPT\s+/i);
    const type = exceptSplit[0].trim().replace(/\s+/g, ' ').toUpperCase();
    const result = { type };
    if (exceptSplit.length > 1) {
      result.exclude_types = exceptSplit[1]
        .split(',')
        .map((t) => t.trim().replace(/\s+/g, ' ').toUpperCase())
        .filter((t) => t.length > 0);
    }
    return result;
  }

  // Parse a comma-separated `db.table` / `table` list into the native
  // `{ database?, table }` entries used by FLUSH LOGS / FLUSH ASYNC INSERT
  // QUEUE. Names may be backtick-quoted.
  function parseSystemTableList(str, unquote) {
    const IDENT = '(?:`[^`]+`|[A-Za-z_0-9][A-Za-z0-9_]*)';
    const entryRe = new RegExp(`^(${IDENT})(?:\\.(${IDENT}))?$`);
    const tables = [];
    for (const part of str.split(',')) {
      const p = part.trim();
      if (!p) continue;
      const m = p.match(entryRe);
      if (!m) continue;
      if (m[2] !== undefined) tables.push({ database: unquote(m[1]), table: unquote(m[2]) });
      else tables.push({ table: unquote(m[1]) });
    }
    return tables;
  }

  // Build the SystemQuery native node from the raw body. All operands are
  // extracted into structured native fields (`system_type` / `table` /
  // `database` / `tables` / `settings` / …) so the AST matches ClickHouse's
  // `EXPLAIN AST json=1` and `format()` / `formatExplain()` reconstruct the
  // command without any verbatim text.
  function systemQueryNode(body, l) {
    const node = { type: 'SYSTEM', ...extractSystemFields(body) };
    // The SYSTEM command body is parsed from text (regex), so its `table` /
    // `database` Identifiers have no contiguous sub-span; they inherit the
    // statement span.
    if (node.table !== undefined) withLoc(node.table, l);
    if (node.database !== undefined) withLoc(node.database, l);
    if (node.settings !== undefined) withLoc(node.settings, l);
    return node;
  }

  // Build the ShowFamilyQuery native node from a parsed ShowStatement. Every
  // operand is projected onto native fields so the AST matches ClickHouse's
  // `EXPLAIN AST json=1` and `format()` / `formatExplain()` re-emit the SHOW
  // form without any library-only payload.
  function showFamilyNode(stmt, l) {
    if (l !== undefined && stmt.location === undefined) stmt.location = l;
    const s = stmt.show;
    let type;
    // Every operand is hoisted onto a native field so the AST matches
    // ClickHouse's `EXPLAIN AST json=1` and `format()` / `formatExplain()`
    // reconstruct the SHOW form without any `_show` payload.
    // Apply the native `(NOT) (I)LIKE` fields from a parsed ShowLikeClause.
    const setLike = (obj, like) => {
      obj.like = like.pattern;
      if (like.not === true) obj.not_like = true;
      if (like.ilike === true) obj.case_insensitive_like = true;
    };
    let extra;
    switch (s.type) {
      case 'listing': {
        type = 'ShowTables';
        extra = {};
        if (s.objectType === 'DATABASES') extra.databases = true;
        else if (s.objectType === 'DICTIONARIES') extra.dictionaries = true;
        if (s.temporary === true) extra.temporary = true;
        if (s.from !== undefined) extra.from = withLoc(ident([s.from]), stmt.location);
        if (s.like !== undefined) setLike(extra, s.like);
        if (s.where !== undefined) extra.where = cloneAst(s.where);
        if (s.limit !== undefined) extra.limit = cloneAst(s.limit);
        if (s.settings !== undefined) extra.settings = setNode(s.settings);
        break;
      }
      case 'accessEntities': {
        // SHOW SETTINGS and SHOW CLUSTERS are serialized as `ShowTables`
        // sub-forms; the true access entities (USERS / ROLES / QUOTAS /
        // SETTINGS PROFILES / ROW POLICIES) are a `ShowAccessEntitiesQuery`.
        if (s.objectType === 'SETTINGS') {
          type = 'ShowTables';
          extra = { show_settings: true };
          if (s.modifier === 'CHANGED') extra.changed = true;
          if (s.like !== undefined) setLike(extra, s.like);
        } else if (s.objectType === 'CLUSTERS') {
          type = 'ShowTables';
          extra = { clusters: true };
          if (s.like !== undefined) setLike(extra, s.like);
          if (s.limit !== undefined) extra.limit = cloneAst(s.limit);
        } else {
          type = 'ShowAccessEntitiesQuery';
          const entityMap = {
            USERS: 'USER', ROLES: 'ROLE', QUOTAS: 'QUOTA',
            'SETTINGS PROFILES': 'SETTINGS PROFILE', 'ROW POLICIES': 'ROW POLICY',
            'NAMED COLLECTIONS': 'NAMED COLLECTION', WARNINGS: 'WARNING',
          };
          extra = { entity_type: entityMap[s.objectType] || s.objectType };
          if (s.modifier === 'CURRENT') extra.current_roles = true;
          else if (s.modifier === 'ENABLED') extra.enabled_roles = true;
          else extra.all = true;
        }
        break;
      }
      case 'cluster':
        // SHOW CLUSTER '<name>' → ShowTables with the cluster name.
        type = 'ShowTables';
        extra = { cluster: true, cluster_str: s.name };
        break;
      case 'merges':
        // SHOW MERGES [(NOT)(I)LIKE 'pat'] [LIMIT expr] → ShowTables.
        type = 'ShowTables';
        extra = { merges: true };
        if (s.like !== undefined) setLike(extra, s.like);
        if (s.limit !== undefined) extra.limit = cloneAst(s.limit);
        break;
      case 'columns': {
        // SHOW [EXTENDED] [FULL] COLUMNS/FIELDS FROM [db.]tbl [FROM db]
        //   [(NOT) (I)LIKE 'pat'] [WHERE expr] [LIMIT expr].
        type = 'ShowColumns';
        extra = { table: s.table.table };
        const db = s.from !== undefined ? s.from : s.table.database;
        if (db !== undefined) extra.database = db;
        if (s.extended === true) extra.extended = true;
        if (s.full === true) extra.full = true;
        if (s.like !== undefined) {
          extra.like = s.like.pattern;
          if (s.like.not === true) extra.not_like = true;
          if (s.like.ilike === true) extra.case_insensitive_like = true;
        }
        if (s.where !== undefined) extra.where = cloneAst(s.where);
        if (s.limit !== undefined) extra.limit = cloneAst(s.limit);
        break;
      }
      case 'indexes': {
        // SHOW [EXTENDED] INDEX(ES)/INDICES/KEYS FROM [db.]tbl [FROM db]
        //   [WHERE expr].
        type = 'ShowIndexes';
        extra = { table: s.table.table };
        const db = s.from !== undefined ? s.from : s.table.database;
        if (db !== undefined) extra.database = db;
        if (s.extended === true) extra.extended = true;
        if (s.where !== undefined) extra.where = cloneAst(s.where);
        break;
      }
      case 'setting':
        // SHOW SETTING <name> carries the setting name natively.
        type = 'ShowSetting';
        extra = { setting_name: s.name };
        break;
      case 'privileges':
        type = 'ShowPrivilegesQuery';
        break;
      case 'engines':
        type = 'ShowEngineQuery';
        break;
      case 'access':
        type = 'ShowAccessQuery';
        break;
      case 'processlist':
        type = 'ShowProcesslistQuery';
        break;
      case 'functions':
        // SHOW FUNCTIONS [(NOT) (I)LIKE 'pat'] carries the pattern natively.
        type = 'ShowFunctions';
        if (s.like !== undefined) { extra = {}; setLike(extra, s.like); }
        break;
      case 'grants':
        // ShowGrantsQuery exposes `for_roles` natively; no FORMAT child.
        // `SHOW GRANTS` with no `FOR` targets the current user.
        type = 'ShowGrantsQuery';
        extra = {
          for_roles:
            s.for !== undefined
              ? rolesOrUsersSetFromNames(s.for, stmt.location)
              : withLoc({ type: 'RolesOrUsersSet', current_user: true }, stmt.location),
        };
        if (s.withImplicit === true) extra.with_implicit = true;
        if (s.final === true) extra.final = true;
        break;
      case 'createAccess':
        if (s.entity === 'NAMED COLLECTION') {
          type = 'ShowCreateNamedCollectionQuery';
          extra = { collection_name: userNameStr(s.names[0]) };
        } else {
          type = 'ShowCreateAccessEntityQuery';
          extra = { entity_type: s.entity };
          // `SHOW CREATE USER CURRENT_USER` serializes as `current_user: true`.
          if (s.names.length === 1 && userNameStr(s.names[0]).toUpperCase() === 'CURRENT_USER') {
            extra.current_user = true;
          } else {
            extra.names = s.names.map(userNameStr);
          }
        }
        break;
      case 'createRowPolicy': {
        type = 'ShowCreateAccessEntityQuery';
        const hasTable = s.policies.some((p) => p.table !== undefined);
        if (!hasTable && s.policies.length === 1 && s.policies[0].names.length === 1) {
          extra = { entity_type: 'ROW POLICY', short_name: s.policies[0].names[0] };
        } else {
          extra = { entity_type: 'ROW POLICY', row_policy_names: rowPolicyNamesNode(s.policies, stmt.location) };
        }
        break;
      }
      default:
        type = 'SHOW';
    }
    // Every SHOW variant is now rendered from native fields alone — there is no
    // library-only `_show` payload.
    const node = { type };
    if (stmt.format !== undefined) node.format = stmt.format;
    if (extra) Object.assign(node, extra);
    return node;
  }

  // Build the AccessQuery native node for access-control DDL. Mirrors the
  // legacy explain.ts dispatch (which has been byte-validated against the
  // explain text suite). Each kind maps to a single native `type` literal +
  // a sparse children list plus the native access fields; `format()` and
  // `formatExplain()` re-emit the full DDL from those native fields alone.
  // Project a structured BackupElement to the native shape EXPLAIN AST json = 1
  // emits for an ASTBackupQuery element: a flat `{ element_type, ... }` record
  // with plain-string table/database names (no Identifier nodes).
  function backupElementNativeNode(el) {
    if (el.kind === 'database') {
      const e = { element_type: 'DATABASE', database: el.name };
      if (el.as !== undefined) e.new_database = el.as;
      // `EXCEPT TABLES t...` is qualified by the backed-up database.
      if (el.exceptTables && el.exceptTables.length > 0)
        e.except_tables = el.exceptTables.map((t) => ({ database: el.name, table: t }));
      return e;
    }
    if (el.kind === 'all') {
      const e = { element_type: 'ALL' };
      if (el.exceptDatabases && el.exceptDatabases.length > 0)
        e.except_databases = el.exceptDatabases;
      if (el.exceptTables && el.exceptTables.length > 0)
        e.except_tables = el.exceptTables.map((t) => {
          const o = {};
          if (t.database !== undefined) o.database = t.database;
          o.table = t.table;
          return o;
        });
      return e;
    }
    if (el.kind === 'function') return { element_type: 'FUNCTION', function_name: el.name };
    if (el.kind === 'namedCollection')
      return { element_type: 'NAMED_COLLECTION', collection_name: el.name };
    // table / dictionary / view / temporaryTable. ClickHouse canonicalizes
    // DICTIONARY/VIEW to TABLE (only the TEMPORARY_TABLE distinction survives).
    const e = { element_type: el.kind === 'temporaryTable' ? 'TEMPORARY_TABLE' : 'TABLE' };
    if (el.table.database !== undefined) e.database = el.table.database;
    e.table = el.table.table;
    if (el.as !== undefined) {
      if (el.as.database !== undefined) e.new_database = el.as.database;
      e.new_table = el.as.table;
    }
    if (el.partitions && el.partitions.length > 0)
      e.partitions = el.partitions.map((p) => ({ type: 'Partition', value: p }));
    return e;
  }

  // ── Access-control native-field helpers ───────────────────────────────────
  // These mirror ClickHouse's `EXPLAIN AST json = 1` field shapes for access
  // entities. CREATE/ALTER/GRANT/REVOKE entities carry only these native
  // fields, from which format()/formatExplain() reconstruct the DDL.

  // Strip surrounding single quotes from a user/host token.
  function unquoteAccess(s) {
    if (typeof s === 'string' && s.length >= 2 && s[0] === "'" && s[s.length - 1] === "'") {
      return s.slice(1, -1).replace(/''/g, "'").replace(/\\'/g, "'");
    }
    return s;
  }

  // A CreateUserNameItem {name, host?} → normalized "name" or "name@host"
  // string. Host '%' (any host) is dropped, matching ClickHouse.
  function userNameStr(item) {
    const name = unquoteAccess(item.name);
    if (item.host !== undefined && item.host !== null) {
      const host = unquoteAccess(item.host);
      if (host === '%') return name;
      return name + '@' + host;
    }
    return name;
  }

  // A CreateUserNameItem → native `UserNameWithHost` node.
  function userNameWithHostNode(item, l) {
    const node = { type: 'UserNameWithHost', name: unquoteAccess(item.name) };
    if (item.host !== undefined && item.host !== null) {
      const host = unquoteAccess(item.host);
      if (host !== '%') node.host_pattern = host;
    }
    return withLoc(node, item.location ?? l);
  }

  // CreateUserNameItem[] → native `UserNamesWithHost` node.
  function userNamesWithHostNode(names, l) {
    const users = names.map((n) => userNameWithHostNode(n, l));
    return withLoc({ type: 'UserNamesWithHost', users }, l ?? spanOf(users));
  }

  // RoleTarget { kind: 'all'|'none'|'names', names?, except? } → native
  // `RolesOrUsersSet` node. `current_user` items (from grantee parsing) are
  // recognized by name 'CURRENT_USER'.
  function rolesOrUsersSetNode(target, l) {
    const node = withLoc({ type: 'RolesOrUsersSet' }, target && target.location ? target.location : l);
    if (!target) return node;
    if (target.kind === 'all') {
      node.all = true;
      if (target.except && target.except.length > 0) node.except_names = target.except.slice();
    } else if (target.kind === 'names') {
      const plain = [];
      let currentUser = false;
      for (const nm of target.names) {
        if (nm === 'CURRENT_USER' || nm === 'currentUser()') currentUser = true;
        else plain.push(nm);
      }
      if (plain.length > 0) node.names = plain;
      if (currentUser) node.current_user = true;
    }
    return node;
  }

  // `USING <expr>` in a row policy. ClickHouse parses a trailing
  // `AS RESTRICTIVE`/`AS PERMISSIVE` as the policy modifier, but the generic
  // expression parser captures it as an alias — split it back out here.
  function rowPolicyUsingClause(expr) {
    if (expr && typeof expr.alias === 'string' && /^(RESTRICTIVE|PERMISSIVE)$/i.test(expr.alias)) {
      const mode = expr.alias; // preserve original casing for round-trip format()
      const e = { ...expr };
      delete e.alias;
      return { using: e, restrictive: mode };
    }
    return { using: expr };
  }

  // RowPolicyTargets `targets` → native `RowPolicyNames` node.
  function rowPolicyNamesNode(targets, l) {
    const policies = [];
    for (const t of targets) {
      for (const sn of t.names) {
        const p = { short_name: sn };
        if (t.table !== undefined) {
          if (t.table.database !== undefined) p.database = t.table.database;
          if (t.table.table !== '*') p.table = t.table.table;
        }
        policies.push(p);
      }
    }
    return withLoc({ type: 'RowPolicyNames', policies }, l);
  }

  // A plain grantee-name list (strings, possibly 'CURRENT_USER') → native
  // `RolesOrUsersSet` node.
  function rolesOrUsersSetFromNames(names, l) {
    const node = withLoc({ type: 'RolesOrUsersSet' }, l);
    const plain = [];
    let currentUser = false;
    for (const nm of names) {
      if (nm === 'CURRENT_USER') currentUser = true;
      else if (nm === 'NONE') { /* NONE → empty set */ }
      else plain.push(nm);
    }
    if (plain.length > 0) node.names = plain;
    if (currentUser) node.current_user = true;
    return node;
  }

  // Native literal string for an access-control setting/limit value (the inner
  // literal source text).
  function accessValueStr(expr) {
    if (expr && expr.type === 'Literal') return String(expr.value);
    return undefined;
  }

  // Native value for a settings-profile element. ClickHouse serializes Float
  // values as JSON numbers and integer/string values as JSON strings.
  function accessSettingValue(expr) {
    if (!expr || expr.type !== 'Literal') return undefined;
    if (expr.value_type === 'Null') return null;
    if (typeof expr.value_type === 'string' && /^Float/.test(expr.value_type))
      return parseFloat(expr.value);
    return String(expr.value);
  }

  // `AccessControlSettingsItem[] | 'NONE'` → native `SettingsProfileElements`.
  function settingsProfileElementsNode(settings, l) {
    const elements = [];
    if (settings !== 'NONE' && settings !== undefined) {
      for (const s of settings) {
        const bareName =
          s.value === undefined && s.min === undefined && s.max === undefined &&
          s.modifier === undefined;
        if (s.kind === 'profile' || s.kind === 'inherit' || bareName) {
          elements.push(withLoc({ type: 'SettingsProfileElement', parent_profile: unquoteAccess(s.name) }, s.location ?? l));
        } else {
          const e = { type: 'SettingsProfileElement', setting_name: s.name };
          if (s.value !== undefined) e.value = accessSettingValue(s.value);
          if (s.min !== undefined) e.min_value = accessSettingValue(s.min);
          if (s.max !== undefined) e.max_value = accessSettingValue(s.max);
          if (s.modifier !== undefined)
            e.writability = s.modifier === 'READONLY' ? 'CONST' : s.modifier;
          elements.push(withLoc(e, s.location ?? l));
        }
      }
    }
    return withLoc({ type: 'SettingsProfileElements', elements }, l ?? spanOf(elements));
  }

  // AuthenticationData[] → native `authentication_methods` node list. A
  // `VALID UNTIL` value (ClickHouse stores it on each AuthenticationData node)
  // is attached to every method when present.
  function authMethodsNodes(auth, validUntil, l) {
    return auth.map((a) => {
      const node = { type: 'AuthenticationData' };
      if (a.sshKeys !== undefined) {
        node.auth_type = 'SSH_KEY';
        node.arguments = a.sshKeys.map((k) => ({
          type: 'PublicSSHKey',
          key_type: k.type,
          key_base64: k.key,
        }));
        if (validUntil !== undefined) node.valid_until = validUntil;
        return node;
      }
      const t = a.authType;
      const PW = {
        no_password: 'NO_PASSWORD',
        plaintext_password: 'PLAINTEXT_PASSWORD',
        sha256_password: 'SHA256_PASSWORD',
        sha256_hash: 'SHA256_PASSWORD',
        double_sha1_password: 'DOUBLE_SHA1_PASSWORD',
        double_sha1_hash: 'DOUBLE_SHA1_PASSWORD',
        bcrypt_password: 'BCRYPT_PASSWORD',
        bcrypt_hash: 'BCRYPT_PASSWORD',
        kerberos: 'KERBEROS',
        ldap: 'LDAP',
        ssh_key: 'SSH_KEY',
      };
      if (t !== undefined && PW[t] !== undefined) node.auth_type = PW[t];
      const isHash = t !== undefined && /_hash$/.test(t);
      const isPassword =
        t === undefined || /_password$/.test(t) || t === 'plaintext_password';
      if (a.secret !== undefined) {
        if (isHash) node.contains_hash = true;
        else if (t === 'kerberos' || t === 'ldap' || t === 'ssh_key') {
          // realm/server: stored in arguments without contains_* flag
        } else if (isPassword) node.contains_password = true;
        node.arguments = [withLoc(strLit(a.secret), a.location ?? l)];
      } else {
        // No secret and no explicit type → `NOT IDENTIFIED` (NO_PASSWORD).
        if (node.auth_type === undefined) node.auth_type = 'NO_PASSWORD';
        node.arguments = [];
      }
      if (validUntil !== undefined) node.valid_until = validUntil;
      return node;
    });
  }

  // Classify an IPv6 address by stripping leading zeros in each group, matching
  // ClickHouse's canonical form (does not perform `::` zero-compression).
  function normalizeIp(addr) {
    if (addr.indexOf(':') === -1) return addr; // IPv4: unchanged
    // Split on '::' to preserve the compression marker.
    return addr
      .split('::')
      .map((part) =>
        part === ''
          ? ''
          : part
              .split(':')
              .map((g) => (g === '' ? '' : g.replace(/^0+(?=[0-9a-fA-F])/, '').toLowerCase()))
              .join(':'),
      )
      .join('::');
  }

  // HostItem[] → native `hosts` object.
  function hostsNode(hostItems) {
    const h = {};
    const push = (key, val) => {
      if (!h[key]) h[key] = [];
      h[key].push(val);
    };
    // ClickHouse only records the first pattern of a `HOST LIKE 'a', 'b'`
    // comma list (see https://github.com/ClickHouse/ClickHouse — the bare
    // continuation after `LIKE` is dropped from the parsed AllowedClientHosts).
    // We mirror that here; format() reconstructs from these native hosts, so the
    // dropped patterns are canonicalized away on a reformat too.
    let likeSeen = false;
    for (const item of hostItems) {
      switch (item.kind) {
        case 'any': h.any_host = true; break;
        case 'none': break;
        case 'local': h.local_host = true; break;
        case 'name': {
          const nm = unquoteAccess(item.value);
          if (nm.toLowerCase() === 'localhost') h.local_host = true;
          else push('names', nm);
          break;
        }
        case 'regexp': push('name_regexps', unquoteAccess(item.value)); break;
        case 'like': {
          if (likeSeen) break;
          likeSeen = true;
          const lp = unquoteAccess(item.value);
          if (lp === '%') h.any_host = true;
          else push('like_patterns', lp);
          break;
        }
        case 'ip': {
          const v = unquoteAccess(item.value);
          if (v === '::1' || v === '127.0.0.1') { h.local_host = true; break; }
          if (v.indexOf('/') !== -1) push('subnets', normalizeIp(v.split('/')[0]) + '/' + v.split('/')[1]);
          else push('addresses', normalizeIp(v));
          break;
        }
      }
    }
    return h;
  }

  // RoleTarget → native `RolesOrUsersSet`.
  function roleTargetSet(target, l) {
    return rolesOrUsersSetNode(target, l);
  }

  // Quota KEYED clause → native `key_type` enum string.
  function quotaKeyType(keyed) {
    if (keyed.notKeyed) return 'NONE';
    const comps = [];
    for (let k of keyed.keys) {
      k = unquoteAccess(k).toLowerCase().trim();
      for (let part of k.split(/\s+or\s+/)) {
        part = part.trim().replace(/\s+/g, '_');
        if (part) comps.push(part.toUpperCase());
      }
    }
    if (comps.length === 1 && comps[0] === 'NONE') return 'NONE';
    return comps.join('_OR_');
  }

  const QUOTA_UNIT_SECONDS = {
    SECOND: 1, MINUTE: 60, HOUR: 3600, DAY: 86400, WEEK: 604800,
    MONTH: 2629746, QUARTER: 7889238, YEAR: 31556952,
  };

  function quotaDurationSec(duration, unit) {
    const n = parseFloat(duration) * (QUOTA_UNIT_SECONDS[unit] || 1);
    return String(Math.round(n));
  }

  function parseSizeNumber(raw) {
    const m = String(raw).trim().match(/^(-?[0-9]*\.?[0-9]+)\s*(Ki|Mi|Gi|Ti|K|M|G|T)?$/i);
    if (!m) return Number(raw);
    const n = parseFloat(m[1]);
    const suf = m[2] ? m[2].toUpperCase() : '';
    const MULT = { K: 1e3, M: 1e6, G: 1e9, T: 1e12, KI: 1024, MI: 1048576, GI: 1073741824, TI: 1099511627776 };
    return n * (MULT[suf] || 1);
  }

  function quotaLimitValueStr(name, expr) {
    const raw = accessValueStr(expr);
    if (raw === undefined) return '0';
    if (name !== 'EXECUTION_TIME' && /^-?[0-9]+$/.test(raw.trim())) return raw.trim();
    let num = parseSizeNumber(raw);
    if (name === 'EXECUTION_TIME') num = num * 1e9;
    try { return BigInt(Math.trunc(num)).toString(); } catch (e) { return raw; }
  }

  function quotaLimitsNodes(intervals) {
    return intervals.map((iv) => {
      const o = { duration_sec: quotaDurationSec(iv.duration, iv.unit) };
      if (iv.randomized) o.randomize_interval = true;
      if (iv.noLimits) o.drop = true;
      if (iv.limits && iv.limits.length > 0) {
        const max = {};
        for (const l of iv.limits) max[l.name] = quotaLimitValueStr(l.name, l.value);
        o.max = max;
      }
      return o;
    });
  }

  // Split a trailing wildcard (`foo*`) into its prefix + flag. A bare `*` is
  // "all", not a wildcard prefix.
  function splitWildcard(part) {
    if (part !== '*' && typeof part === 'string' && part.endsWith('*')) {
      return { name: part.slice(0, -1), wildcard: true };
    }
    return { name: part, wildcard: false };
  }

  // Canonical names for ClickHouse access-type aliases (e.g. `DELETE` is an
  // alias for `ALTER DELETE`).
  const ACCESS_ALIASES = {
    DELETE: 'ALTER DELETE',
    UPDATE: 'ALTER UPDATE',
  };

  // GrantElement[] → native `access_rights` list (one element per privilege).
  // `grantOption` marks `WITH GRANT OPTION` / `GRANT OPTION FOR`.
  function accessRightsNodes(elements, grantOption) {
    const rights = [];
    for (const el of elements) {
      for (const priv of el.privileges) {
        const canonical = ACCESS_ALIASES[priv.name] || priv.name;
        const r = {
          access_types: priv.name === 'NONE' || priv.name === 'USAGE' ? [] : [canonical],
        };
        const t = el.target;
        let wildcard = false;
        // Parameterized access types take the `ON X` target as a `parameter`
        // string (source name, table engine, definer user) rather than a
        // database/table.
        const PARAM_ACCESS = { READ: 1, WRITE: 1, 'SET DEFINER': 1, 'TABLE ENGINE': 1 };
        if (PARAM_ACCESS[priv.name] && t && t.table !== undefined && t.database === undefined) {
          r.parameter = t.table;
          if (grantOption) r.grant_option = true;
          rights.push(r);
          continue;
        }
        if (t) {
          if (t.database !== undefined) {
            const db = splitWildcard(t.database);
            if (db.name !== '*') r.database = db.name;
            if (db.wildcard) wildcard = true;
            if (t.table !== undefined && t.table !== '*') {
              const tb = splitWildcard(t.table);
              r.table = tb.name;
              if (tb.wildcard) wildcard = true;
            }
          } else if (t.table !== undefined) {
            // Single-part target: a table on the default (current) database.
            r.default_database = true;
            if (t.table !== '*') {
              const tb = splitWildcard(t.table);
              r.table = tb.name;
              if (tb.wildcard) wildcard = true;
            }
          }
        }
        if (priv.columns) r.columns = priv.columns;
        if (wildcard) r.wildcard = true;
        if (grantOption) r.grant_option = true;
        rights.push(r);
      }
    }
    return rights;
  }

  // Build native access-control fields for the access query node, mirroring
  // ClickHouse's `EXPLAIN AST json = 1` shape. Returns a plain field object to
  // merge onto the node.
  function accessNativeFields(stmt) {
    const f = {};
    const k = stmt.kind;
    if (k === 'createRole' || k === 'alterRole') {
      if (k === 'alterRole') f.alter = true;
      if (stmt.orReplace) f.or_replace = true;
      if (stmt.ifNotExists) f.if_not_exists = true;
      if (stmt.onCluster !== undefined) f.cluster = stmt.onCluster;
      f.names = stmt.names.map(userNameStr);
      if (stmt.renameTo !== undefined) f.new_name = userNameStr(stmt.renameTo);
      if (stmt.settings !== undefined) {
        if (k === 'alterRole') f.alter_settings = alterSettingsProfileElements(stmt.settings, stmt.location);
        else f.settings = settingsProfileElementsNode(stmt.settings, stmt.location);
      }
    } else if (k === 'createSettingsProfile' || k === 'alterSettingsProfile') {
      if (k === 'alterSettingsProfile') f.alter = true;
      if (stmt.orReplace) f.or_replace = true;
      if (stmt.ifNotExists) f.if_not_exists = true;
      if (stmt.onCluster !== undefined) f.cluster = stmt.onCluster;
      f.names = stmt.names.map((n) => unquoteAccess(n));
      if (stmt.renameTo !== undefined) f.new_name = unquoteAccess(stmt.renameTo);
      if (k === 'alterSettingsProfile') {
        if (stmt.settings !== undefined) f.alter_settings = alterSettingsProfileElements(stmt.settings, stmt.location);
      } else if (stmt.settings !== undefined) {
        f.settings = settingsProfileElementsNode(stmt.settings, stmt.location);
      }
      if (stmt.to !== undefined) f.to_roles = roleTargetSet(stmt.to, stmt.location);
    } else if (k === 'createQuota' || k === 'alterQuota') {
      if (k === 'alterQuota') f.alter = true;
      if (stmt.orReplace) f.or_replace = true;
      if (stmt.ifNotExists) f.if_not_exists = true;
      if (stmt.onCluster !== undefined) f.cluster = stmt.onCluster;
      f.names = stmt.names.map((n) => unquoteAccess(n));
      if (stmt.renameTo !== undefined) f.new_name = unquoteAccess(stmt.renameTo);
      if (stmt.keyed !== undefined) f.key_type = quotaKeyType(stmt.keyed);
      if (stmt.intervals !== undefined) f.limits = quotaLimitsNodes(stmt.intervals);
      if (stmt.to !== undefined) f.roles = roleTargetSet(stmt.to, stmt.location);
    } else if (k === 'createRowPolicy' || k === 'alterRowPolicy') {
      if (k === 'alterRowPolicy') f.alter = true;
      if (stmt.orReplace) f.or_replace = true;
      if (stmt.ifNotExists) f.if_not_exists = true;
      if (stmt.onCluster !== undefined) f.cluster = stmt.onCluster;
      f.names = rowPolicyNamesNode(stmt.targets, stmt.location);
      if (stmt.renameTo !== undefined) f.new_short_name = unquoteAccess(stmt.renameTo);
      if (stmt.restrictive !== undefined)
        f.is_restrictive = stmt.restrictive.toUpperCase() === 'RESTRICTIVE';
      if (stmt.using !== undefined) {
        const filter = { filter_type: 'SELECT_FILTER' };
        const usingNone =
          stmt.using && stmt.using.type === 'Identifier' &&
          typeof stmt.using.name === 'string' && stmt.using.name.toUpperCase() === 'NONE';
        if (!usingNone) filter.condition = stmt.using;
        f.filters = [filter];
      }
      if (stmt.to !== undefined) f.roles = roleTargetSet(stmt.to, stmt.location);
    } else if (k === 'createUser' || k === 'alterUser') {
      Object.assign(f, createUserNativeFields(stmt));
    } else if (k === 'grant') {
      if (stmt.onCluster !== undefined) f.cluster = stmt.onCluster;
      const grantOption =
        (stmt.withOptions && stmt.withOptions.indexOf('GRANT') !== -1) ||
        stmt.optionFor === 'GRANT';
      if (stmt.elements !== undefined) {
        f.access_rights = accessRightsNodes(stmt.elements, grantOption);
        if (stmt.withOptions && stmt.withOptions.indexOf('REPLACE') !== -1) f.replace_access = true;
      }
      if (stmt.roles !== undefined) {
        f.roles = rolesOrUsersSetFromNames(stmt.roles, stmt.location);
        if (stmt.withOptions && stmt.withOptions.indexOf('REPLACE') !== -1)
          f.replace_granted_roles = true;
      }
      f.grantees = rolesOrUsersSetFromNames(stmt.grantees, stmt.location);
    } else if (k === 'setRole') {
      f.kind = 'SET_DEFAULT_ROLE';
      f.roles = roleTargetSet(stmt.roles, stmt.location);
      f.to_users = rolesOrUsersSetFromNames(stmt.users, stmt.location);
    }
    return f;
  }

  // ALTER ... SETTINGS → native `AlterSettingsProfileElements` (replace-all).
  function alterSettingsProfileElements(settings, l) {
    const node = { type: 'AlterSettingsProfileElements' };
    const add = settingsProfileElementsNode(settings, l);
    if (add.elements.length > 0) node.add_settings = add;
    node.drop_all_settings = true;
    node.drop_all_profiles = true;
    return withLoc(node, l);
  }

  // CREATE/ALTER USER native fields.
  function createUserNativeFields(stmt) {
    const f = {};
    if (stmt.kind === 'alterUser') {
      f.alter = true;
      if (stmt.ifExists) f.if_exists = true;
      if (stmt.onCluster !== undefined) f.cluster = stmt.onCluster;
      f.names = userNamesWithHostNode(stmt.names, stmt.location);
      let auth, settings, defaultRole, defaultDatabase, grantees, rename, validUntil;
      let hostItems, addHostItems, dropHostItems;
      for (const c of stmt.clauses) {
        if (c.kind === 'identified') auth = c.auth;
        else if (c.kind === 'notIdentified') auth = [{}];
        else if (c.kind === 'host') {
          if (c.mode === 'ADD') addHostItems = (addHostItems || []).concat(c.hosts);
          else if (c.mode === 'DROP') dropHostItems = (dropHostItems || []).concat(c.hosts);
          else hostItems = (hostItems || []).concat(c.hosts);
        } else if (c.kind === 'settings') settings = c.settings;
        else if (c.kind === 'defaultRole') defaultRole = c.roles;
        else if (c.kind === 'defaultDatabase') defaultDatabase = c.database;
        else if (c.kind === 'grantees') grantees = c.grantees;
        else if (c.kind === 'rename') rename = c.to;
        else if (c.kind === 'validUntil') validUntil = c.value;
      }
      if (rename !== undefined) f.new_name = userNameStr(rename);
      if (auth !== undefined) {
        f.authentication_methods = authMethodsNodes(auth, validUntil, stmt.location);
        f.replace_authentication_methods = true;
      }
      if (hostItems !== undefined) f.hosts = hostsNode(hostItems);
      if (addHostItems !== undefined) f.add_hosts = hostsNode(addHostItems);
      if (dropHostItems !== undefined) f.remove_hosts = hostsNode(dropHostItems);
      if (defaultRole !== undefined) f.default_roles = roleTargetSet(defaultRole, stmt.location);
      if (defaultDatabase !== undefined) f.default_database = databaseOrNoneNode(defaultDatabase, stmt.location);
      if (settings !== undefined) f.alter_settings = alterSettingsProfileElements(settings, stmt.location);
      if (grantees !== undefined) f.grantees = roleTargetSet(grantees, stmt.location);
      return f;
    }
    // createUser
    if (stmt.orReplace) f.or_replace = true;
    if (stmt.ifNotExists) f.if_not_exists = true;
    if (stmt.onCluster !== undefined) f.cluster = stmt.onCluster;
    f.names = userNamesWithHostNode(stmt.names, stmt.location);
    if (stmt.auth !== undefined) {
      f.authentication_methods = authMethodsNodes(stmt.auth, stmt.validUntil, stmt.location);
      f.replace_authentication_methods = true;
    }
    if (stmt.host !== undefined) f.hosts = hostsNode(stmt.host);
    else {
      const derived = deriveHostsFromNames(stmt.names);
      if (derived !== undefined) f.hosts = derived;
    }
    if (stmt.defaultRole !== undefined) f.default_roles = roleTargetSet(stmt.defaultRole, stmt.location);
    if (stmt.settings !== undefined) f.settings = settingsProfileElementsNode(stmt.settings, stmt.location);
    if (stmt.defaultDatabase !== undefined)
      f.default_database = databaseOrNoneNode(stmt.defaultDatabase, stmt.location);
    if (stmt.grantees !== undefined) f.grantees = roleTargetSet(stmt.grantees, stmt.location);
    return f;
  }

  // When a `CREATE USER name@host` carries an `@host` (and no explicit HOST
  // clause), ClickHouse derives the allowed `hosts` from it: a single shared
  // host pattern becomes a LIKE pattern (localhost/loopback → local_host); a
  // bare `%` or differing patterns across names produce no hosts.
  function deriveHostsFromNames(names) {
    if (names.length === 0) return undefined;
    let pattern;
    for (const nm of names) {
      if (nm.host === undefined || nm.host === null) return undefined;
      const p = unquoteAccess(nm.host);
      if (pattern === undefined) pattern = p;
      else if (pattern !== p) return undefined;
    }
    if (pattern === undefined || pattern === '%') return undefined;
    const lc = pattern.toLowerCase();
    if (lc === 'localhost' || pattern === '::1' || pattern === '127.0.0.1')
      return { local_host: true };
    return { like_patterns: [pattern] };
  }

  // `DEFAULT DATABASE <db>` / `DEFAULT DATABASE NONE` → native `DatabaseOrNone`.
  function databaseOrNoneNode(db, l) {
    const node = { type: 'DatabaseOrNone' };
    if (db !== undefined && db !== null && db.toUpperCase() !== 'NONE')
      node.database = unquoteAccess(db);
    return withLoc(node, l);
  }

  function accessQueryNode(stmt, l) {
    if (l !== undefined && stmt.location === undefined) stmt.location = l;
    if (stmt.kind === 'createUser' || stmt.kind === 'alterUser') {
      return { type: 'CreateUserQuery', ...accessNativeFields(stmt) };
    }
    if (stmt.kind === 'createRole' || stmt.kind === 'alterRole')
      return { type: 'CreateRoleQuery', ...accessNativeFields(stmt) };
    if (stmt.kind === 'createQuota' || stmt.kind === 'alterQuota')
      return { type: 'CreateQuotaQuery', ...accessNativeFields(stmt) };
    if (stmt.kind === 'createSettingsProfile' || stmt.kind === 'alterSettingsProfile')
      return { type: 'CreateSettingsProfileQuery', ...accessNativeFields(stmt) };
    if (stmt.kind === 'createNamedCollection') {
      const node = { type: 'CreateNamedCollectionQuery', collection_name: stmt.name };
      if (stmt.ifNotExists === true) node.if_not_exists = true;
      if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
      const changes = {};
      const overridability = {};
      for (const it of stmt.items) {
        changes[it.key] = typedSettingValue(it.value);
        if (it.overridable !== undefined) overridability[it.key] = it.overridable;
      }
      node.changes = changes;
      if (Object.keys(overridability).length > 0) node.overridability = overridability;
      return node;
    }
    if (stmt.kind === 'createRowPolicy' || stmt.kind === 'alterRowPolicy')
      return { type: 'CreateRowPolicyQuery', ...accessNativeFields(stmt) };
    if (stmt.kind === 'createWorkload') {
      const node = { type: 'CreateWorkloadQuery' };
      if (stmt.orReplace === true) node.or_replace = true;
      if (stmt.ifNotExists === true) node.if_not_exists = true;
      node.workload_name = identLoc([stmt.name], stmt.location);
      if (stmt.parentWorkload) node.workload_parent = identLoc([stmt.parentWorkload], stmt.location);
      if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
      if (stmt.settings && stmt.settings.length > 0) {
        node.changes = stmt.settings.map((it) => {
          const c = { name: it.name, value: typedSettingValue(it.value) };
          if (it.forResource !== undefined) c.resource = it.forResource;
          return c;
        });
      }
      return node;
    }
    if (stmt.kind === 'createResource') {
      const node = { type: 'CreateResourceQuery', resource_name: identLoc([stmt.name], stmt.location) };
      if (stmt.orReplace === true) node.or_replace = true;
      if (stmt.ifNotExists === true) node.if_not_exists = true;
      node.unit = 'IOByte';
      node.operations = (stmt.specs || []).map((s) => {
        const op = { mode: s.mode };
        if (s.disk !== undefined) op.disk = s.disk;
        return op;
      });
      if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
      return node;
    }
    if (stmt.kind === 'grant')
      return {
        type: stmt.operation === 'REVOKE' ? 'RevokeQuery' : 'GrantQuery',
        ...accessNativeFields(stmt),
      };
    if (stmt.kind === 'setRole') return { type: 'SetRoleQuery', ...accessNativeFields(stmt) };
    if (stmt.kind === 'backup') {
      const d = stmt.destination;
      const node = {
        type: stmt.operation === 'RESTORE' ? 'RestoreQuery' : 'BackupQuery',
        kind: stmt.operation,
        elements: stmt.elements.map(backupElementNativeNode),
        backup_name: fnArgs(d.name, d.args || [], 'BACKUP_NAME', d.location ?? stmt.location),
      };
      if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
      let backupSettings =
        stmt.settings && stmt.settings.length > 0 ? setNode(stmt.settings) : undefined;
      // The SYNC / ASYNC wait mode rides inside `settings` as a boolean
      // `async` change (SYNC → false, ASYNC → true), matching ClickHouse.
      if (stmt.wait !== undefined) {
        if (backupSettings === undefined) backupSettings = { type: 'Settings', changes: {} };
        if (backupSettings.changes === undefined) backupSettings.changes = {};
        backupSettings.changes.async = stmt.wait === 'ASYNC';
      }
      if (backupSettings !== undefined) node.settings = backupSettings;
      // Trailing `FORMAT name` is a native AST field.
      if (stmt.format !== undefined) node.format = stmt.format;
      return node;
    }
    if (stmt.kind === 'parallelWith') {
      return { type: 'ParallelWithQuery', children: stmt.queries };
    }
    // Unrecognized kind: return as-is so call sites can wrap unconditionally.
    return stmt;
  }

  // Build the native AlterQuery node from the structured AlterStatement.
  // Children mirror ClickHouse's order: ExpressionList(AlterCommand...),
  // optional database Identifier, table Identifier, optional FORMAT
  // Identifier, optional Set (for SETTINGS). The structured payload
  // (ON CLUSTER, per-command details, ...) is on `_alter`.
  function alterQueryNativeNode(stmt) {
    const node = {
      type: 'AlterQuery',
      alter_object: stmt.kind === 'alterDatabase' ? 'DATABASE' : 'TABLE',
      commands: stmt.commands.map(alterCommandNativeNode),
    };
    if (stmt.table.database !== undefined) node.database = identLoc([stmt.table.database], stmt.table.location);
    node.table = identLoc([stmt.table.table], stmt.table.location);
    if (stmt.onCluster !== undefined) node.cluster = stmt.onCluster;
    if (stmt.settings !== undefined && stmt.settings.length > 0)
      node.settings = setNode(stmt.settings);
    // Trailing `FORMAT name` is a native AST field.
    if (stmt.format !== undefined) node.format = stmt.format;
    return node;
  }

}}

{
  // Attach source location to a node (must be in per-parse initializer to access location())
  function loc(node) {
    return { ...node, location: location() };
  }
}

// Statements is the top-level rule, supporting UNION ALL and FORMAT clauses
// Allows empty input (e.g., SQL files containing only comments)
// Accepts any number of extra empty statements (bare `;`) between real statements.
// Each extra `;` produces an `empty` placeholder so AST indices align with
// ClickHouse's statement splitter (which emits a `<Explain Error>` for empties).
Statements
  = pre:_ head:TopLevelStatement headWs:_
    rest:StatementsRestEntry*
    trailing:StatementsTrailing? finalWs:_ {
      head = addStmtLeading(head, flattenWs(pre));
      head = addStmtTrailing(head, headWs.trailing);
      let pendingLeading = headWs.leading;
      const stmts = [head];
      for (const r of rest) {
        for (const ep of r.empties) stmts.push(ep);
        const ws2val = r.ws2;
        let stmt = r.stmt;
        const ws3val = r.ws3;
        stmts[stmts.length - 1] = addStmtTrailing(stmts[stmts.length - 1], ws2val.trailing);
        stmt = addStmtLeading(stmt, [...pendingLeading, ...ws2val.leading]);
        stmt = addStmtTrailing(stmt, ws3val.trailing);
        pendingLeading = ws3val.leading;
        stmts.push(stmt);
      }
      if (trailing) {
        for (const ep of trailing) stmts.push(ep);
      }
      stmts[stmts.length - 1] = addStmtTrailing(stmts[stmts.length - 1], [...pendingLeading, ...flattenWs(finalWs)]);
      return stmts;
    }
  / _ { return []; }

StatementsRestEntry
  = ";" empties:EmptyStatementRun ws2:_ stmt:TopLevelStatement ws3:_ {
      return { empties, ws2, stmt, ws3 };
    }

StatementsTrailing
  = ";" empties:EmptyStatementRun { return empties; }

EmptyStatementRun
  = tail:(_ ";")* {
      return tail.map(() => loc({ type: 'EmptyQuery' }));
    }

// A top-level statement is either an EXPLAIN or a union query with optional INTO OUTFILE, FORMAT, and SETTINGS clauses
// SETTINGS can appear before FORMAT (inside SELECT) or after FORMAT
TopLevelStatement
  = ExplainStatement
  / ParallelWithStatement
  / CreateStatement
  / AlterAccessStatement
  / AlterStatement
  / SetStatement
  / TransactionControlStatement
  / UseStatement
  / SystemStatement
  / InsertStatement
  / DropStatement
  / UndropStatement
  / BackupStatement
  / GrantStatement
  / TruncateStatement
  / OptimizeStatement
  / DescribeStatement
  / ShowCreateStatement
  / ShowStatement
  / DetachStatement
  / DeleteStatement
  / UpdateStatement
  / CheckStatement
  / AttachStatement
  / RenameStatement
  / ExistsStatement
  / KillStatement
  / ExecuteAsStatement
  / query:UnionQuery intoOutfile:( _ IntoOutfileClause )? preSettings:( _ SettingsClause )? format:( _ FormatClause )? postSettings:( _ SettingsClause )* {
      let result = query;
      const isNewNode = typeof result.type === 'string';
      if (intoOutfile !== null) {
        if (isNewNode) {
          result = { ...result, out_file: intoOutfile[1].path };
          if (intoOutfile[1].truncate) result = { ...result, outfile_truncate: true };
        } else {
          result = { ...result, intoOutfile: intoOutfile[1].path };
        }
      }
      if (format !== null) {
        result = { ...result, format: format[1] };
      }
      // SETTINGS before and/or after FORMAT collapse onto the query wrapper's
      // native `settings` field. The pre-/post-FORMAT position is a purely
      // syntactic no-op, but ClickHouse's EXPLAIN AST child order preserves it,
      // so we record a library-only `settings_before_format` hint (used only
      // by formatExplain(); format() canonicalizes to SETTINGS after FORMAT).
      const settingItems = [
        ...(preSettings !== null ? preSettings[1] : []),
        ...postSettings.reduce((acc, s) => [...acc, ...s[1]], []),
      ];
      if (settingItems.length > 0) {
        if (isNewNode) {
          result = { ...result, settings: setNode(settingItems) };
          if (preSettings !== null) result = { ...result, settings_before_format: true };
        } else {
          result = { ...result, postFormatSettings: settingItems };
        }
      }
      return result;
    }

// IntoOutfileClause: INTO OUTFILE 'path' [TRUNCATE] — output redirection.
// Returns { path: <StringLiteral>, truncate: <bool> }.
IntoOutfileClause
  = "INTO"i ![a-zA-Z0-9_] _ "OUTFILE"i ![a-zA-Z0-9_] _ path:StringLiteral truncate:( _ "TRUNCATE"i ![a-zA-Z0-9_] )? {
      return { path, truncate: truncate !== null };
    }

// ExecuteAsStatement: EXECUTE AS user <statement>
// The user name is followed by another DDL statement to run as that user.
ExecuteAsStatement
  = "EXECUTE"i ![a-zA-Z0-9_] _ "AS"i ![a-zA-Z0-9_] _ user:AliasName _
    stmt:( AlterStatement / OptimizeStatement / DescribeStatement / ShowCreateStatement
         / DetachStatement / AttachStatement / DeleteStatement / UpdateStatement
         / CheckStatement / RenameStatement / ExistsStatement / KillStatement
         / TruncateStatement / DropStatement / InsertStatement / CreateStatement
         / UnionQuery ) {
      return loc({
        type: 'ExecuteAsQuery',
        target_user: loc({ type: 'UserNameWithHost', name: user }),
        subquery: stmt,
      });
    }

// ImplicitSelectStatement: bare expression as a SELECT (requires implicit_select=1).
// Examples: `1 + 2;`, `count();`, `s;`, `*;`. Wraps the expression in a synthetic SELECT.
ImplicitSelectStatement
  = expr:( Asterisk / Expression ) &(_ ";" / _ !.) {
      return loc(wrapSWU([loc({ type: 'SelectQuery', select: [expr] })]));
    }

// SetStatement: SET key = value [, key = value ...] — changes session-level settings
SetStatement
  = "SET"i ![a-zA-Z0-9_] _ "TRANSACTION"i ![a-zA-Z0-9_] _ "SNAPSHOT"i ![a-zA-Z0-9_] _ snapshot:$[0-9]+ { return loc({ type: 'TransactionControl', action: 'SET_SNAPSHOT', snapshot: snapshot }); }
  / "SET"i ![a-zA-Z0-9_] _ "DEFAULT"i ![a-zA-Z0-9_] _ "ROLE"i ![a-zA-Z0-9_] _ roles:SetRoleList _ "TO"i ![a-zA-Z0-9_] _ users:SetRoleUserList { return loc(accessQueryNode({ kind: 'setRole', roles, users }, location())); }
  / "SET"i ![a-zA-Z0-9_] _ items:SettingsList { return loc(setNode(items)); }

SetRoleList
  = "ALL"i ![a-zA-Z0-9_] except:( _ "EXCEPT"i ![a-zA-Z0-9_] _ SetRoleNameList )? { return { kind: 'all', except: except ? except[4] : undefined }; }
  / "NONE"i ![a-zA-Z0-9_] { return { kind: 'none' }; }
  / names:SetRoleNameList { return { kind: 'names', names }; }

// A comma-separated list of identifiers (see AliasNameList).
SetRoleNameList
  = AliasNameList

SetRoleUserList
  = AliasNameList

// TransactionControlStatement: BEGIN [TRANSACTION], START TRANSACTION, COMMIT, ROLLBACK
TransactionControlStatement
  = ("BEGIN"i / "START"i) ![a-zA-Z0-9_] ( _ "TRANSACTION"i ![a-zA-Z0-9_] )? { return loc({ type: 'TransactionControl', action: 'BEGIN' }); }
  / "COMMIT"i ![a-zA-Z0-9_] { return loc({ type: 'TransactionControl', action: 'COMMIT' }); }
  / "ROLLBACK"i ![a-zA-Z0-9_] { return loc({ type: 'TransactionControl', action: 'ROLLBACK' }); }

// UseStatement: USE database — selects the current database
UseStatement
  = "USE"i ![a-zA-Z0-9_] _ db:( x:( QueryParamIdentifier / AliasName ) { return { value: x, location: location() }; } ) {
      return loc({ type: 'UseQuery', database: withLoc(ident([db.value]), db.location) });
    }

// SystemStatement: SYSTEM FLUSH LOGS, SYSTEM RELOAD CONFIG, etc. — admin commands
// Emits a native SystemQuery node with structured fields (and any Identifier/Set
// children) extracted from the subcommand text.
SystemStatement
  = "SYSTEM"i ![a-zA-Z0-9_] body:$( ![\n;] . )+ {
      return loc(systemQueryNode(('SYSTEM ' + body.trim()).trim(), location()));
    }

// ── ALTER TABLE statements ──────────────────────────────────────────────────

// AlterStatement: ALTER TABLE [db.]table [ON CLUSTER cluster] command [, command ...] [SETTINGS ...] [FORMAT ...]
AlterStatement
  = "ALTER"i ![a-zA-Z0-9_] _ ("TEMPORARY"i ![a-zA-Z0-9_] _)? "TABLE"i ![a-zA-Z0-9_] _ table:TableRef
    onCluster:( _ OnClusterClause )?
    _ head:AlterCommand tail:( _ "," _ AlterCommand )*
    preSettings:( _ SettingsClause )?
    format:( _ FormatClause )?
    postSettings:( _ SettingsClause )? {
      const commands = [head, ...tail.map(t => t[3])];
      const stmt = { kind: 'alter', table, commands };
      if (onCluster !== null) stmt.onCluster = onCluster[1];
      const settings = preSettings !== null ? preSettings[1] : (postSettings !== null ? postSettings[1] : null);
      if (settings !== null) stmt.settings = settings;
      if (format !== null) stmt.format = format[1];
      return loc(alterQueryNativeNode(stmt));
    }

// Each alter command alternative. Parenthesized commands like (APPLY DELETED MASK) are supported.
AlterCommand
  = "(" _ cmd:AlterCommandInner _ ")" { return { ...cmd, parenthesized: true }; }
  / AlterCommandInner

AlterCommandInner
  = AlterCommandAddColumn
  / AlterCommandDropColumn
  / AlterCommandClearColumn
  / AlterCommandModifyColumn
  / AlterCommandRenameColumn
  / AlterCommandCommentColumn
  / AlterCommandMaterializeColumn
  / AlterCommandModifyOrderBy
  / AlterCommandModifySampleBy
  / AlterCommandRemoveSampleBy
  / AlterCommandModifyTTL
  / AlterCommandRemoveTTL
  / AlterCommandMaterializeTTL
  / AlterCommandModifySetting
  / AlterCommandResetSetting
  / AlterCommandModifyQuery
  / AlterCommandModifyRefresh
  / AlterCommandModifyComment
  / AlterCommandAddIndex
  / AlterCommandDropIndex
  / AlterCommandClearIndex
  / AlterCommandMaterializeIndex
  / AlterCommandAddProjection
  / AlterCommandDropProjection
  / AlterCommandClearProjection
  / AlterCommandMaterializeProjection
  / AlterCommandAddConstraint
  / AlterCommandDropConstraint
  / AlterCommandAddStatistics
  / AlterCommandDropStatistics
  / AlterCommandClearStatistics
  / AlterCommandModifyStatistics
  / AlterCommandMaterializeStatistics
  / AlterCommandUpdate
  / AlterCommandDelete
  / AlterCommandDropPartition
  / AlterCommandDropDetachedPartition
  / AlterCommandAttachPartition
  / AlterCommandReplacePartition
  / AlterCommandMovePartition
  / AlterCommandFetchPartition
  / AlterCommandFreezePartition
  / AlterCommandFreezeAll
  / AlterCommandApplyDeletedMask
  / AlterCommandApplyPatches
  / AlterCommandRewriteParts

// ── Column commands ─────────────────────────────────────────────────────────

AlterCommandAddColumn
  = "ADD"i ![a-zA-Z0-9_] _ "COLUMN"i ![a-zA-Z0-9_]
    ifNotExists:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ col:AlterColumnElement
    after:( _ "AFTER"i ![a-zA-Z0-9_] _ AlterColumnRef / _ "FIRST"i ![a-zA-Z0-9_] )? {
      const result = loc({ kind: 'alterCommand', commandType: 'ADD_COLUMN', column: col });
      if (after !== null && after[1] && after[4] && typeof after[4] === 'object') {
        result.afterColumn = after[4].name;
        result.afterColumnParts = after[4].parts;
      } else if (after !== null && after[1] && after[1].toUpperCase() === 'FIRST') {
        result.first = true;
      }
      if (ifNotExists !== null) result.ifNotExists = true;
      return result;
    }

AlterCommandDropColumn
  = "DROP"i ![a-zA-Z0-9_] _ "COLUMN"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ col:AlterColumnRef
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_COLUMN', columnName: col.name, columnNameParts: col.parts });
      if (ifExists !== null) result.ifExists = true;
      if (partition !== null) result.partition = partition[1];
      return result;
    }

AlterCommandClearColumn
  = "CLEAR"i ![a-zA-Z0-9_] _ "COLUMN"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ col:AlterColumnRef
    partition:( _ AlterInPartitionClause )? {
      const result = loc({
        kind: 'alterCommand',
        commandType: 'DROP_COLUMN',
        columnName: col.name,
        columnNameParts: col.parts,
        clear: true,
      });
      if (ifExists !== null) result.ifExists = true;
      if (partition !== null) result.partition = partition[1];
      return result;
    }

AlterCommandModifyColumn
  = ("MODIFY"i / "ALTER"i) ![a-zA-Z0-9_] _ "COLUMN"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName _ "TYPE"i ![a-zA-Z0-9_] _ type:ColumnDataType {
      const col = loc({ kind: 'columnDef', name, type });
      return loc({ kind: 'alterCommand', commandType: 'MODIFY_COLUMN', column: col });
    }
  / ("MODIFY"i / "ALTER"i) ![a-zA-Z0-9_] _ "COLUMN"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ col:AlterModifyColumnElement
    removeProp:( _ "REMOVE"i ![a-zA-Z0-9_] _ AlterRemoveProperty )?
    modifySetReset:( _ AlterModifyColumnSettingClause )?
    after:( _ "AFTER"i ![a-zA-Z0-9_] _ AlterColumnRef / _ "FIRST"i ![a-zA-Z0-9_] )? {
      const result = loc({ kind: 'alterCommand', commandType: 'MODIFY_COLUMN', column: col });
      if (ifExists !== null) result.ifExists = true;
      if (removeProp !== null) result.removeProperty = removeProp[4];
      if (modifySetReset !== null) result.columnSettingOp = modifySetReset[1];
      if (after !== null && after[1] && after[4] && typeof after[4] === 'object') {
        result.afterColumn = after[4].name;
        result.afterColumnParts = after[4].parts;
      } else if (after !== null && after[1] && after[1].toUpperCase() === 'FIRST') {
        result.first = true;
      }
      return result;
    }

// MODIFY COLUMN column element: like ColumnElement but with extra negative lookaheads
// for MODIFY/RESET/REMOVE/AFTER/FIRST that can follow the column definition
AlterModifyColumnElement
  = name:$(AliasName ("." AliasName)+)
    type:( _ !("DEFAULT"i ![a-zA-Z0-9_] / "MATERIALIZED"i ![a-zA-Z0-9_] / "EPHEMERAL"i ![a-zA-Z0-9_] / "ALIAS"i ![a-zA-Z0-9_] / "COMMENT"i ![a-zA-Z0-9_] / "CODEC"i ![a-zA-Z0-9_] / "TTL"i ![a-zA-Z0-9_] / "STATISTICS"i ![a-zA-Z0-9_] / "SETTINGS"i ![a-zA-Z0-9_] / "NULL"i ![a-zA-Z0-9_] / "NOT"i ![a-zA-Z0-9_] _ "NULL"i ![a-zA-Z0-9_] / "REMOVE"i ![a-zA-Z0-9_] / "MODIFY"i ![a-zA-Z0-9_] / "RESET"i ![a-zA-Z0-9_] / "FIRST"i ![a-zA-Z0-9_] / "AFTER"i ![a-zA-Z0-9_] / "," / ")") ColumnDataType )?
    def:( _ ColumnDefault )?
    comment:( _ ColumnComment )?
    codec:( _ ColumnCodec )?
    ttl:( _ ColumnTTL )? {
      const result = loc({ kind: 'columnDef', name });
      if (type !== null) result.type = type[2];
      if (def !== null) { result.defaultKind = def[1].kind; if (def[1].expr) result.defaultExpr = def[1].expr; }
      if (comment !== null) result.comment = comment[1];
      if (codec !== null) result.codec = codec[1];
      if (ttl !== null) result.ttl = ttl[1];
      return result;
    }
  / name:AliasName
    type:( _ !("DEFAULT"i ![a-zA-Z0-9_] / "MATERIALIZED"i ![a-zA-Z0-9_] / "EPHEMERAL"i ![a-zA-Z0-9_] / "ALIAS"i ![a-zA-Z0-9_] / "COMMENT"i ![a-zA-Z0-9_] / "CODEC"i ![a-zA-Z0-9_] / "TTL"i ![a-zA-Z0-9_] / "STATISTICS"i ![a-zA-Z0-9_] / "SETTINGS"i ![a-zA-Z0-9_] / "NULL"i ![a-zA-Z0-9_] / "NOT"i ![a-zA-Z0-9_] _ "NULL"i ![a-zA-Z0-9_] / "AUTO_INCREMENT"i ![a-zA-Z0-9_] / "COLLATE"i ![a-zA-Z0-9_] / "PRIMARY"i ![a-zA-Z0-9_] / "REMOVE"i ![a-zA-Z0-9_] / "MODIFY"i ![a-zA-Z0-9_] / "RESET"i ![a-zA-Z0-9_] / "FIRST"i ![a-zA-Z0-9_] / "AFTER"i ![a-zA-Z0-9_] / "," / ")") ColumnDataType )?
    collate:( _ "COLLATE"i ![a-zA-Z0-9_] _ AliasName )?
    nullable1:( _ NullableModifier )?
    autoIncrement:( _ "AUTO_INCREMENT"i ![a-zA-Z0-9_] )?
    primaryKey:( _ "PRIMARY"i ![a-zA-Z0-9_] _ "KEY"i ![a-zA-Z0-9_] )?
    def:( _ ColumnDefault )?
    nullable2:( _ NullableModifier )?
    comment:( _ ColumnComment )?
    codec:( _ ColumnCodec )?
    stats:( _ ColumnStatistics )?
    ttl:( _ ColumnTTL )?
    colSettings:( _ ColumnSettings )? {
      const result = loc({ kind: 'columnDef', name });
      if (type !== null) result.type = type[2];
      else if (autoIncrement !== null) result.type = { name: 'INT', args: [], location: location() };
      if (autoIncrement !== null) result.autoIncrement = true;
      const nullable = nullable2 !== null ? nullable2[1] : (nullable1 !== null ? nullable1[1] : null);
      if (collate !== null) result.collate = collate[4];
      if (nullable !== null) result.nullable = nullable;
      if (primaryKey !== null) result.primaryKey = true;
      if (def !== null) { result.defaultKind = def[1].kind; if (def[1].expr) result.defaultExpr = def[1].expr; }
      if (comment !== null) result.comment = comment[1];
      if (codec !== null) result.codec = codec[1];
      if (stats !== null) result.statistics = stats[1];
      if (ttl !== null) result.ttl = ttl[1];
      if (colSettings !== null) result.columnSettings = colSettings[1];
      return result;
    }

AlterRemoveProperty
  = "DEFAULT"i ![a-zA-Z0-9_] { return 'DEFAULT'; }
  / "MATERIALIZED"i ![a-zA-Z0-9_] { return 'MATERIALIZED'; }
  / "ALIAS"i ![a-zA-Z0-9_] { return 'ALIAS'; }
  / "COMMENT"i ![a-zA-Z0-9_] { return 'COMMENT'; }
  / "CODEC"i ![a-zA-Z0-9_] { return 'CODEC'; }
  / "TTL"i ![a-zA-Z0-9_] { return 'TTL'; }
  / "SETTINGS"i ![a-zA-Z0-9_] { return 'SETTINGS'; }

AlterModifyColumnSettingClause
  = "MODIFY"i ![a-zA-Z0-9_] _ "SETTING"i ![a-zA-Z0-9_] _ settings:SettingsList { return { op: 'MODIFY_SETTING', settings }; }
  / "RESET"i ![a-zA-Z0-9_] _ "SETTING"i ![a-zA-Z0-9_] _ names:AlterResetSettingNames { return { op: 'RESET_SETTING', names }; }

AlterCommandRenameColumn
  = "RENAME"i ![a-zA-Z0-9_] _ "COLUMN"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ oldName:AlterColumnRef _ "TO"i ![a-zA-Z0-9_] _ newName:AlterColumnRef {
      const result = loc({
        kind: 'alterCommand',
        commandType: 'RENAME_COLUMN',
        oldName: oldName.name,
        newName: newName.name,
        oldNameParts: oldName.parts,
        newNameParts: newName.parts,
      });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }

AlterCommandCommentColumn
  = "COMMENT"i ![a-zA-Z0-9_] _ "COLUMN"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ col:AlterColumnRef _ comment:StringLiteral {
      const result = loc({
        kind: 'alterCommand',
        commandType: 'COMMENT_COLUMN',
        columnName: col.name,
        columnNameParts: col.parts,
        comment,
      });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }

AlterCommandMaterializeColumn
  = "MATERIALIZE"i ![a-zA-Z0-9_] _ "COLUMN"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ col:AlterColumnRef
    partition:( _ AlterInPartitionClause )? {
      const result = loc({
        kind: 'alterCommand',
        commandType: 'MATERIALIZE_COLUMN',
        columnName: col.name,
        columnNameParts: col.parts,
      });
      if (ifExists !== null) result.ifExists = true;
      if (partition !== null) result.partition = partition[1];
      return result;
    }

// Column element variant for ALTER that allows dotted names (e.g. AddedNested1.C Array(String))
// Tries dotted name first (requires dot present), falls back to ColumnElement for plain names
AlterColumnElement
  = name:$(AliasName ("." AliasName)+)
    type:( _ !("DEFAULT"i ![a-zA-Z0-9_] / "MATERIALIZED"i ![a-zA-Z0-9_] / "EPHEMERAL"i ![a-zA-Z0-9_] / "ALIAS"i ![a-zA-Z0-9_] / "COMMENT"i ![a-zA-Z0-9_] / "CODEC"i ![a-zA-Z0-9_] / "TTL"i ![a-zA-Z0-9_] / "STATISTICS"i ![a-zA-Z0-9_] / "SETTINGS"i ![a-zA-Z0-9_] / "NULL"i ![a-zA-Z0-9_] / "NOT"i ![a-zA-Z0-9_] _ "NULL"i ![a-zA-Z0-9_] / "AUTO_INCREMENT"i ![a-zA-Z0-9_] / "COLLATE"i ![a-zA-Z0-9_] / "PRIMARY"i ![a-zA-Z0-9_] / "," / ")") ColumnDataType )?
    def:( _ ColumnDefault )?
    comment:( _ ColumnComment )?
    codec:( _ ColumnCodec )?
    ttl:( _ ColumnTTL )? {
      const result = loc({ kind: 'columnDef', name });
      if (type !== null) result.type = type[2];
      if (def !== null) { result.defaultKind = def[1].kind; if (def[1].expr) result.defaultExpr = def[1].expr; }
      if (comment !== null) result.comment = comment[1];
      if (codec !== null) result.codec = codec[1];
      if (ttl !== null) result.ttl = ttl[1];
      return result;
    }
  / ColumnElement

// Projection definition without the leading PROJECTION keyword (used in ALTER ADD PROJECTION)
AlterProjectionDef
  = name:AliasName _ "(" _ query:SelectStatement _ ")"
    projSettings:( _ "WITH"i ![a-zA-Z0-9_] _ "SETTINGS"i ![a-zA-Z0-9_] _ "(" _ SettingsList _ ")" )? {
      const result = loc({ kind: 'projectionDef', name, query });
      if (projSettings !== null) result.projectionSettings = projSettings[9];
      return result;
    }
  / name:AliasName _ "INDEX"i ![a-zA-Z0-9_] _ indexExpr:IndexExpr _ "TYPE"i ![a-zA-Z0-9_] _ indexType:IndexTypeSpec {
      return loc({ kind: 'projectionDef', name, indexExpr, indexType });
    }

// Constraint definition without the leading CONSTRAINT keyword (used in ALTER ADD CONSTRAINT)
AlterConstraintDef
  = name:AliasName _ ct:("CHECK"i / "ASSUME"i) ![a-zA-Z0-9_] _ expr:Expression {
      return loc({ kind: 'constraintDef', name, constraintType: ct.toUpperCase(), expr });
    }

// Index definition without the leading INDEX keyword (used in ALTER ADD INDEX)
AlterIndexDef
  = name:AliasName _ expr:IndexExpr _ "TYPE"i ![a-zA-Z0-9_] _ indexType:IndexTypeSpec
    gran:( _ "GRANULARITY"i ![a-zA-Z0-9_] _ n:$[0-9]+ { return parseInt(n, 10); } )? {
      const result = loc({ kind: 'indexDef', name, expr, indexType });
      if (gran !== null) result.granularity = gran;
      return result;
    }

// Column references in ALTER can include dots (e.g. NestedColumn.A)
// AlterColumnRef: a column reference inside an ALTER command. Returns
// `{name, parts}` — `name` is the joined string (`n.d`), `parts` is the
// original segment array (`['n','d']` for unquoted `n.d`; `['n.d']` for
// backtick-quoted `\`n.d\``). Used by `colRefIdent` to emit an Identifier
// with `name_parts` for qualified refs while distinguishing them from
// single-segment refs that happen to contain dots.
AlterColumnRef
  = head:AliasName tail:( "." AliasName )* {
      const parts = [head, ...tail.map(t => t[1])];
      return { name: parts.join('.'), parts };
    }

// ── Index commands ──────────────────────────────────────────────────────────

AlterCommandAddIndex
  = "ADD"i ![a-zA-Z0-9_] _ "INDEX"i ![a-zA-Z0-9_]
    ifNotExists:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ idx:AlterIndexDef
    after:( _ "AFTER"i ![a-zA-Z0-9_] _ AliasName / _ "FIRST"i ![a-zA-Z0-9_] )? {
      const result = loc({ kind: 'alterCommand', commandType: 'ADD_INDEX', index: idx });
      if (after !== null && after[1] && typeof after[4] === 'string') result.afterIndex = after[4];
      else if (after !== null && after[1] && after[1].toUpperCase() === 'FIRST') result.first = true;
      if (ifNotExists !== null) result.ifNotExists = true;
      return result;
    }

AlterCommandDropIndex
  = "DROP"i ![a-zA-Z0-9_] _ "INDEX"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_INDEX', indexName: name });
      if (ifExists !== null) result.ifExists = true;
      if (partition !== null) result.partition = partition[1];
      return result;
    }

AlterCommandClearIndex
  = "CLEAR"i ![a-zA-Z0-9_] _ "INDEX"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_INDEX', indexName: name });
      result.clearIndex = true;
      if (ifExists !== null) result.ifExists = true;
      if (partition !== null) result.partition = partition[1];
      return result;
    }

AlterCommandMaterializeIndex
  = "MATERIALIZE"i ![a-zA-Z0-9_] _ "INDEX"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'MATERIALIZE_INDEX', indexName: name });
      if (ifExists !== null) result.ifExists = true;
      if (partition !== null) result.partition = partition[1];
      return result;
    }

// ── Projection commands ─────────────────────────────────────────────────────

AlterCommandAddProjection
  = "ADD"i ![a-zA-Z0-9_] _ "PROJECTION"i ![a-zA-Z0-9_]
    ifNotExists:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ proj:AlterProjectionDef
    after:( _ "AFTER"i ![a-zA-Z0-9_] _ AliasName )? {
      const result = loc({ kind: 'alterCommand', commandType: 'ADD_PROJECTION', projection: proj });
      if (after !== null) result.afterProjection = after[4];
      if (ifNotExists !== null) result.ifNotExists = true;
      return result;
    }

AlterCommandDropProjection
  = "DROP"i ![a-zA-Z0-9_] _ "PROJECTION"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_PROJECTION', projectionName: name });
      if (ifExists !== null) result.ifExists = true;
      if (partition !== null) result.partition = partition[1];
      return result;
    }

AlterCommandClearProjection
  = "CLEAR"i ![a-zA-Z0-9_] _ "PROJECTION"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_PROJECTION', projectionName: name });
      result.clearProjection = true;
      if (ifExists !== null) result.ifExists = true;
      if (partition !== null) result.partition = partition[1];
      return result;
    }

AlterCommandMaterializeProjection
  = "MATERIALIZE"i ![a-zA-Z0-9_] _ "PROJECTION"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'MATERIALIZE_PROJECTION', projectionName: name });
      if (ifExists !== null) result.ifExists = true;
      if (partition !== null) result.partition = partition[1];
      return result;
    }

// ── Constraint commands ─────────────────────────────────────────────────────

AlterCommandAddConstraint
  = "ADD"i ![a-zA-Z0-9_] _ "CONSTRAINT"i ![a-zA-Z0-9_]
    ifNotExists:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ constraint:AlterConstraintDef {
      const result = loc({ kind: 'alterCommand', commandType: 'ADD_CONSTRAINT', constraint });

      if (ifNotExists !== null) result.ifNotExists = true;

      return result;
    }

AlterCommandDropConstraint
  = "DROP"i ![a-zA-Z0-9_] _ "CONSTRAINT"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_CONSTRAINT', constraintName: name });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }

// ── Statistics commands ─────────────────────────────────────────────────────

AlterCommandAddStatistics
  = "ADD"i ![a-zA-Z0-9_] _ "STATISTICS"i ![a-zA-Z0-9_]
    ifNotExists:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ columns:AlterStatisticsColumns _ "TYPE"i ![a-zA-Z0-9_] _ types:AlterStatisticsTypes {
      const result = loc({ kind: 'alterCommand', commandType: 'ADD_STATISTICS', statColumns: columns, statTypes: types });

      if (ifNotExists !== null) result.ifNotExists = true;

      return result;
    }

AlterCommandDropStatistics
  = "DROP"i ![a-zA-Z0-9_] _ "STATISTICS"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ "ALL"i ![a-zA-Z0-9_] {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_STATISTICS' });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }
  / "DROP"i ![a-zA-Z0-9_] _ "STATISTICS"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ columns:AlterStatisticsColumns {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_STATISTICS', statColumns: columns });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }

AlterCommandModifyStatistics
  = "MODIFY"i ![a-zA-Z0-9_] _ "STATISTICS"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ columns:AlterStatisticsColumns _ "TYPE"i ![a-zA-Z0-9_] _ types:AlterStatisticsTypes {
      const result = loc({ kind: 'alterCommand', commandType: 'MODIFY_STATISTICS', statColumns: columns, statTypes: types });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }

AlterCommandClearStatistics
  = "CLEAR"i ![a-zA-Z0-9_] _ "STATISTICS"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ "ALL"i ![a-zA-Z0-9_] {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_STATISTICS', clear: true });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }
  / "CLEAR"i ![a-zA-Z0-9_] _ "STATISTICS"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ columns:AlterStatisticsColumns {
      const result = loc({ kind: 'alterCommand', commandType: 'DROP_STATISTICS', statColumns: columns, clear: true });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }

AlterCommandMaterializeStatistics
  = "MATERIALIZE"i ![a-zA-Z0-9_] _ "STATISTICS"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ "ALL"i ![a-zA-Z0-9_] {
      const result = loc({ kind: 'alterCommand', commandType: 'MATERIALIZE_STATISTICS' });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }
  / "MATERIALIZE"i ![a-zA-Z0-9_] _ "STATISTICS"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ columns:AlterStatisticsColumns {
      const result = loc({ kind: 'alterCommand', commandType: 'MATERIALIZE_STATISTICS', statColumns: columns });
      if (ifExists !== null) result.ifExists = true;
      return result;
    }

AlterStatisticsColumns
  = AliasNameList

AlterStatisticsTypes
  = head:IndexTypeSpec tail:( _ "," _ IndexTypeSpec )* { return [head, ...tail.map(t => t[3])]; }

// ── Mutation commands ───────────────────────────────────────────────────────

AlterCommandUpdate
  = "UPDATE"i ![a-zA-Z0-9_] _ assignments:AlterUpdateAssignmentList _ partition:AlterInPartitionClause _ "WHERE"i ![a-zA-Z0-9_] _ where:Expression {
      return loc({ kind: 'alterCommand', commandType: 'UPDATE', assignments, where, partition });
    }
  / "UPDATE"i ![a-zA-Z0-9_] _ assignments:AlterAssignmentList _ "WHERE"i ![a-zA-Z0-9_] _ where:Expression {
      return loc({ kind: 'alterCommand', commandType: 'UPDATE', assignments, where });
    }

AlterAssignmentList
  = head:AlterAssignment tail:( _ "," _ AlterAssignment )* { return [head, ...tail.map(t => t[3])]; }

AlterAssignment
  = col:AlterColumnRef _ "=" _ expr:TernaryExpr {
      return { column: col.name, columnParts: col.parts, expr };
    }

// Assignment list for UPDATE ... IN PARTITION — uses AddExpr (not TernaryExpr) for values
// to prevent 'x + 1 IN PARTITION' being parsed as the SQL IN operator
AlterUpdateAssignmentList
  = head:AlterUpdateAssignment tail:( _ "," _ AlterUpdateAssignment )* { return [head, ...tail.map(t => t[3])]; }

AlterUpdateAssignment
  = col:AlterColumnRef _ "=" _ expr:AddExpr {
      return { column: col.name, columnParts: col.parts, expr };
    }

AlterCommandDelete
  = "DELETE"i ![a-zA-Z0-9_] _ "WHERE"i ![a-zA-Z0-9_] _ where:Expression
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'DELETE', where });
      if (partition !== null) result.partition = partition[1];
      return result;
    }
  / "DELETE"i ![a-zA-Z0-9_] _ partition:AlterInPartitionClause _ "WHERE"i ![a-zA-Z0-9_] _ where:Expression {
      return loc({ kind: 'alterCommand', commandType: 'DELETE', where, partition });
    }

// ── Partition commands ──────────────────────────────────────────────────────

AlterCommandDropPartition
  = kw:("DROP"i / "DETACH"i) ![a-zA-Z0-9_] _ "PART"i ![a-zA-Z0-9_] _ partName:( StringLiteral / QueryParam ) {
      const node = { kind: 'alterCommand', commandType: 'DROP_PARTITION', partName };
      if (kw.toUpperCase() === 'DETACH') node.detach = true;
      return loc(node);
    }
  / kw:("DROP"i / "DETACH"i) ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ part:AlterPartitionExpr {
      const node = { kind: 'alterCommand', commandType: 'DROP_PARTITION', partition: part };
      if (kw.toUpperCase() === 'DETACH') node.detach = true;
      return loc(node);
    }

AlterCommandDropDetachedPartition
  = "DROP"i ![a-zA-Z0-9_] _ "DETACHED"i ![a-zA-Z0-9_] _ "PART"i ![a-zA-Z0-9_] _ partName:( StringLiteral / QueryParam ) {
      return loc({ kind: 'alterCommand', commandType: 'DROP_DETACHED_PARTITION', partName: partName });
    }
  / "DROP"i ![a-zA-Z0-9_] _ "DETACHED"i ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ part:AlterPartitionExpr {
      return loc({ kind: 'alterCommand', commandType: 'DROP_DETACHED_PARTITION', partition: part });
    }

AlterCommandAttachPartition
  = "ATTACH"i ![a-zA-Z0-9_] _ "PART"i ![a-zA-Z0-9_] _ partName:( StringLiteral / QueryParam ) {
      return loc({ kind: 'alterCommand', commandType: 'ATTACH_PARTITION', partName: partName });
    }
  / "ATTACH"i ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ part:AlterPartitionExpr _ "FROM"i ![a-zA-Z0-9_] _ fromTable:TableRef {
      return loc({ kind: 'alterCommand', commandType: 'REPLACE_PARTITION', partition: part, fromTable: fromTable, replace: false });
    }
  / "ATTACH"i ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ part:AlterPartitionExpr
    from:( _ "FROM"i ![a-zA-Z0-9_] _ TableRef )? {
      const result = loc({ kind: 'alterCommand', commandType: 'ATTACH_PARTITION', partition: part });
      if (from !== null) result.fromTable = from[4];
      return result;
    }

AlterCommandReplacePartition
  = "REPLACE"i ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ part:AlterPartitionExpr _ "FROM"i ![a-zA-Z0-9_] _ table:TableRef {
      return loc({ kind: 'alterCommand', commandType: 'REPLACE_PARTITION', partition: part, fromTable: table, replace: true });
    }

AlterCommandMovePartition
  = "MOVE"i ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ part:AlterPartitionExpr _ "TO"i ![a-zA-Z0-9_] _
    dest:( "TABLE"i ![a-zA-Z0-9_] _ table:TableRef { return { destType: 'TABLE', table }; }
         / "DISK"i ![a-zA-Z0-9_] _ disk:StringLiteral { return { destType: 'DISK', value: disk }; }
         / "VOLUME"i ![a-zA-Z0-9_] _ vol:StringLiteral { return { destType: 'VOLUME', value: vol }; }
         / "SHARD"i ![a-zA-Z0-9_] _ shard:StringLiteral { return { destType: 'SHARD', value: shard }; } ) {
      return loc({ kind: 'alterCommand', commandType: 'MOVE_PARTITION', partition: part, moveDest: dest });
    }

AlterCommandFetchPartition
  = "FETCH"i ![a-zA-Z0-9_] _ ("PARTITION"i / "PART"i) ![a-zA-Z0-9_]
    _ part:AlterFetchPartitionExpr _ "FROM"i ![a-zA-Z0-9_] _ path:( StringLiteral / QueryParam ) {
      return loc({ kind: 'alterCommand', commandType: 'FETCH_PARTITION', partition: part, fromPath: path });
    }

// Partition expression for FETCH that doesn't use general Expression to avoid packrat issues
AlterFetchPartitionExpr
  = "ALL"i ![a-zA-Z0-9_] { return { partitionKind: 'all', location: location() }; }
  / "ID"i ![a-zA-Z0-9_] _ id:( StringLiteral / QueryParam ) { return { partitionKind: 'id', id, location: location() }; }
  / expr:TernaryExpr { return { partitionKind: 'expr', expr }; }

AlterCommandFreezePartition
  = "FREEZE"i ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ part:AlterPartitionExpr
    withName:( _ "WITH"i ![a-zA-Z0-9_] _ "NAME"i ![a-zA-Z0-9_] _ StringLiteral )? {
      const result = loc({ kind: 'alterCommand', commandType: 'FREEZE_PARTITION', partition: part });
      if (withName !== null) result.withName = withName[7].value;
      return result;
    }

AlterCommandFreezeAll
  = "FREEZE"i ![a-zA-Z0-9_]
    withName:( _ "WITH"i ![a-zA-Z0-9_] _ "NAME"i ![a-zA-Z0-9_] _ StringLiteral )? {
      const result = loc({ kind: 'alterCommand', commandType: 'FREEZE_ALL' });
      if (withName !== null) result.withName = withName[7].value;
      return result;
    }

// ── Table-level commands ────────────────────────────────────────────────────

AlterCommandModifyTTL
  = "MODIFY"i ![a-zA-Z0-9_] _ "TTL"i ![a-zA-Z0-9_] _ head:TTLItem tail:( _ "," _ TTLItem )* {
      const ttl = [head, ...tail.map(t => t[3])];
      return loc({ kind: 'alterCommand', commandType: 'MODIFY_TTL', ttl });
    }

AlterCommandRemoveTTL
  = "REMOVE"i ![a-zA-Z0-9_] _ "TTL"i ![a-zA-Z0-9_] {
      return loc({ kind: 'alterCommand', commandType: 'REMOVE_TTL' });
    }

AlterCommandMaterializeTTL
  = "MATERIALIZE"i ![a-zA-Z0-9_] _ "TTL"i ![a-zA-Z0-9_]
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'MATERIALIZE_TTL' });
      if (partition !== null) result.partition = partition[1];
      return result;
    }

AlterCommandModifyOrderBy
  = "MODIFY"i ![a-zA-Z0-9_] _ "ORDER"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ expr:Expression {
      return loc({ kind: 'alterCommand', commandType: 'MODIFY_ORDER_BY', expr });
    }

AlterCommandModifySampleBy
  = "MODIFY"i ![a-zA-Z0-9_] _ "SAMPLE"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ expr:Expression {
      return loc({ kind: 'alterCommand', commandType: 'MODIFY_SAMPLE_BY', expr });
    }

AlterCommandRemoveSampleBy
  = "REMOVE"i ![a-zA-Z0-9_] _ "SAMPLE"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] {
      return loc({ kind: 'alterCommand', commandType: 'REMOVE_SAMPLE_BY' });
    }

AlterCommandModifySetting
  = "MODIFY"i ![a-zA-Z0-9_] _ "SETTING"i ![a-zA-Z0-9_] _ settings:SettingsList {
      return loc({ kind: 'alterCommand', commandType: 'MODIFY_SETTING', settings });
    }

AlterCommandResetSetting
  = "RESET"i ![a-zA-Z0-9_] _ "SETTING"i ![a-zA-Z0-9_] _ names:AlterResetSettingNames {
      return loc({ kind: 'alterCommand', commandType: 'RESET_SETTING', settingNames: names });
    }

AlterResetSettingNames
  = AliasNameList

AlterCommandModifyQuery
  = "MODIFY"i ![a-zA-Z0-9_] _ "QUERY"i ![a-zA-Z0-9_] _ query:UnionQuery {
      return loc({ kind: 'alterCommand', commandType: 'MODIFY_QUERY', query });
    }

AlterCommandModifyComment
  = "MODIFY"i ![a-zA-Z0-9_] _ "COMMENT"i ![a-zA-Z0-9_] _ comment:StringLiteral {
      return loc({ kind: 'alterCommand', commandType: 'MODIFY_COMMENT', comment });
    }

AlterCommandModifyRefresh
  = "MODIFY"i ![a-zA-Z0-9_] _ refresh:RefreshClause {
      return loc({ kind: 'alterCommand', commandType: 'MODIFY_REFRESH', refresh });
    }

// ── Other commands ──────────────────────────────────────────────────────────

AlterCommandApplyDeletedMask
  = "APPLY"i ![a-zA-Z0-9_] _ "DELETED"i ![a-zA-Z0-9_] _ "MASK"i ![a-zA-Z0-9_]
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'APPLY_DELETED_MASK' });
      if (partition !== null) result.partition = partition[1];
      return result;
    }

AlterCommandApplyPatches
  = "APPLY"i ![a-zA-Z0-9_] _ "PATCHES"i ![a-zA-Z0-9_]
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'APPLY_PATCHES' });
      if (partition !== null) result.partition = partition[1];
      return result;
    }

AlterCommandRewriteParts
  = "REWRITE"i ![a-zA-Z0-9_] _ "PARTS"i ![a-zA-Z0-9_]
    partition:( _ AlterInPartitionClause )? {
      const result = loc({ kind: 'alterCommand', commandType: 'REWRITE_PARTS' });
      if (partition !== null) result.partition = partition[1];
      return result;
    }

// ── Partition expression helpers ────────────────────────────────────────────

// A partition expression: PARTITION ALL, PARTITION ID 'xxx', or PARTITION expr
AlterPartitionExpr
  = "ALL"i ![a-zA-Z0-9_] { return { partitionKind: 'all', location: location() }; }
  / "ID"i ![a-zA-Z0-9_] _ id:( StringLiteral / QueryParam ) { return { partitionKind: 'id', id, location: location() }; }
  / expr:TernaryExpr { return { partitionKind: 'expr', expr, location: location() }; }

// IN PARTITION clause used by CLEAR COLUMN/INDEX, MATERIALIZE, APPLY DELETED MASK, etc.
AlterInPartitionClause
  = "IN"i ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ part:AlterPartitionExpr { return part; }
  / "IN"i ![a-zA-Z0-9_] _ "PART"i ![a-zA-Z0-9_] _ id:StringLiteral { return { partitionKind: 'id', id }; }

// ── DROP statements ─────────────────────────────────────────────────────────

// DropIndexStatement: DROP INDEX [IF EXISTS] name ON [db.]table
DropIndexStatement
  = "DROP"i ![a-zA-Z0-9_] _ "INDEX"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ indexName:AliasName _ "ON"i ![a-zA-Z0-9_] _ table:TableRef {
      const node = {
        type: 'DropIndexQuery',
        index_name: loc(ident([indexName])),
        table: withLoc(ident([table.table]), table.location),
      };
      if (ifExists !== null) node.if_exists = true;
      if (table.database !== undefined) node.database = withLoc(ident([table.database]), table.location);
      return loc(node);
    }

// DropStatement: DROP [TEMPORARY] TABLE/VIEW/DICTIONARY/DATABASE/FUNCTION [IF EXISTS|IF EMPTY] [db.]name [, ...] [ON CLUSTER ...] [SYNC|NO DELAY] [SETTINGS ...] [FORMAT ...]
// For access control objects (USER, ROLE, etc.), falls back to opaque parsing with specific label.
DropStatement
  = DropIndexStatement
  / "DROP"i ![a-zA-Z0-9_] temp:( _ "TEMPORARY"i ![a-zA-Z0-9_] )?
    _ targetType:DropTargetType
    ifClause:( _ "IF"i ![a-zA-Z0-9_] _ ( "EXISTS"i / "EMPTY"i ) ![a-zA-Z0-9_] )?
    _ head:TableRef tail:( _ "," _ TableRef )*
    cluster:( _ OnClusterClause )?
    sync:( _ ( "SYNC"i / "NO"i ![a-zA-Z0-9_] _ "DELAY"i ) ![a-zA-Z0-9_] )?
    settings:( _ SettingsClause )?
    format:( _ FormatClause )? {
      const tables = [head, ...tail.map(t => t[3])];
      if (targetType === 'FUNCTION') {
        // ClickHouse serializes DROP FUNCTION as a bare DropFunctionQuery node
        const fnNode = { type: 'DropFunctionQuery', function_name: partName(tables[0].table) };
        if (ifClause !== null) fnNode.if_exists = true;
        if (cluster !== null) fnNode.cluster = cluster[1];
        return loc(fnNode);
      }
      const o = { targetType };
      if (tables.length === 1) {
        o.table = tables[0];
      } else {
        o.tables = tables;
      }
      if (temp !== null) o.temporary = true;
      if (ifClause !== null) {
        if (ifClause[4].toUpperCase() === 'EMPTY') o.ifEmpty = true;
        else o.ifExists = true;
      }
      if (cluster !== null) o.onCluster = cluster[1];
      if (sync !== null) o.sync = true;
      if (settings !== null) o.settings = settings[1];
      if (format !== null) o.format = format[1];
      return loc(dropFamilyNode('DropQuery', o));
    }
  / "DROP"i ![a-zA-Z0-9_] _ ShowRowPolicyKeyword
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ targetsResult:RowPolicyTargets
    cluster:( _ OnClusterClause )?
    storage:( _ "FROM"i ![a-zA-Z0-9_] _ AliasName )? {
      const node = { type: 'DropAccessEntityQuery', entity_type: 'ROW POLICY' };
      if (ifExists !== null) node.if_exists = true;
      const cl = cluster !== null ? cluster[1] : targetsResult.onCluster;
      if (cl) node.cluster = cl;
      if (storage !== null) node.storage_name = storage[4];
      node.row_policy_names = rowPolicyNamesNode(targetsResult.targets, location());
      return loc(node);
    }
  / "DROP"i ![a-zA-Z0-9_] _ entity:DropAccessEntityKeyword
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ names:CreateUserNameList
    storage:( _ "FROM"i ![a-zA-Z0-9_] _ AliasName )?
    cluster:( _ OnClusterClause )? {
      const node = { type: 'DropAccessEntityQuery', entity_type: entity };
      if (ifExists !== null) node.if_exists = true;
      if (cluster !== null) node.cluster = cluster[1];
      if (storage !== null) node.storage_name = storage[4];
      node.names = names.map(userNameStr);
      return loc(node);
    }
  / "DROP"i ![a-zA-Z0-9_] _ kind:( "NAMED"i ![a-zA-Z0-9_] _ "COLLECTION"i ![a-zA-Z0-9_] { return 'NAMED COLLECTION'; } / "WORKLOAD"i ![a-zA-Z0-9_] { return 'WORKLOAD'; } / "RESOURCE"i ![a-zA-Z0-9_] { return 'RESOURCE'; } )
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    cluster:( _ OnClusterClause )? {
      let type;
      const node = {};
      if (kind === 'NAMED COLLECTION') { type = 'DropNamedCollectionQuery'; node.collection_name = name; }
      else if (kind === 'WORKLOAD') { type = 'DropWorkloadQuery'; node.workload_name = name; }
      else { type = 'DropResourceQuery'; node.resource_name = name; }
      if (ifExists !== null) node.if_exists = true;
      if (cluster !== null) node.cluster = cluster[1];
      return loc({ type, ...node });
    }

// UndropStatement: UNDROP TABLE [db.]name [UUID 'x'] [ON CLUSTER c] [FORMAT f]
UndropStatement
  = "UNDROP"i ![a-zA-Z0-9_] _ "TABLE"i ![a-zA-Z0-9_]
    _ table:TableRef
    uuid:( _ "UUID"i ![a-zA-Z0-9_] _ StringLiteral )?
    cluster:( _ OnClusterClause )?
    format:( _ FormatClause )? {
      const o = { table };
      if (uuid !== null) o.uuid = uuid[4].value;
      if (cluster !== null) o.onCluster = cluster[1];
      if (format !== null) o.format = format[1];
      return loc(dropFamilyNode('UndropQuery', o));
    }

// BackupStatement: BACKUP/RESTORE target_list TO/FROM destination [ON CLUSTER] [SETTINGS] [SYNC|ASYNC] [FORMAT]
BackupStatement
  = op:( "BACKUP"i / "RESTORE"i ) ![a-zA-Z0-9_] _ elements:BackupElementList
    _ ( "TO"i / "FROM"i ) ![a-zA-Z0-9_] _ destination:BackupDestination
    cluster:( _ OnClusterClause )?
    settings:( _ SettingsClause )?
    wait:( _ ( "SYNC"i / "ASYNC"i ) ![a-zA-Z0-9_] )?
    format:( _ FormatClause )? {
      const result = { kind: 'backup', operation: op.toUpperCase(), elements, destination };
      if (cluster !== null) result.onCluster = cluster[1];
      if (settings !== null) result.settings = settings[1];
      if (wait !== null) result.wait = wait[1].toUpperCase();
      if (format !== null) result.format = format[1];
      return loc(accessQueryNode(result, location()));
    }

BackupElementList
  = "ALL"i ![a-zA-Z0-9_] ( _ "DATABASES"i ![a-zA-Z0-9_] )?
    exceptDbs:( _ "EXCEPT"i ![a-zA-Z0-9_] _ "DATABASES"i ![a-zA-Z0-9_] _ names:AliasNameList { return names; } )?
    exceptTbls:( _ "EXCEPT"i ![a-zA-Z0-9_] _ "TABLES"i ![a-zA-Z0-9_] _ refs:BackupTableRefList { return refs; } )? {
      const result = { kind: 'all' };
      if (exceptDbs !== null) result.exceptDatabases = exceptDbs;
      if (exceptTbls !== null) result.exceptTables = exceptTbls;
      return [result];
    }
  / head:BackupElement tail:( _ "," _ BackupElement )* { return [head, ...tail.map(t => t[3])]; }

BackupElement
  = "TEMPORARY"i ![a-zA-Z0-9_] _ "TABLE"i ![a-zA-Z0-9_] _ table:TableRef as:BackupAsTable? {
      const result = { kind: 'temporaryTable', table };
      if (as !== null) result.as = as;
      return result;
    }
  / "TABLE"i ![a-zA-Z0-9_] _ table:TableRef as:BackupAsTable? parts:( _ BackupPartitions )? except:( _ BackupExceptColumns )? {
      const result = { kind: 'table', table };
      if (as !== null) result.as = as;
      if (parts !== null) result.partitions = parts[1];
      if (except !== null) result.exceptColumns = except[1];
      return result;
    }
  / "DICTIONARY"i ![a-zA-Z0-9_] _ table:TableRef as:BackupAsTable? {
      const result = { kind: 'dictionary', table };
      if (as !== null) result.as = as;
      return result;
    }
  / "VIEW"i ![a-zA-Z0-9_] _ table:TableRef as:BackupAsTable? {
      const result = { kind: 'view', table };
      if (as !== null) result.as = as;
      return result;
    }
  / "DATABASE"i ![a-zA-Z0-9_] _ name:AliasName as:( _ KW_AS _ AliasName )? except:( _ "EXCEPT"i ![a-zA-Z0-9_] _ "TABLES"i ![a-zA-Z0-9_] _ names:AliasNameList { return names; } )? {
      const result = { kind: 'database', name };
      if (as !== null) result.as = as[3];
      if (except !== null) result.exceptTables = except;
      return result;
    }
  / "FUNCTION"i ![a-zA-Z0-9_] _ name:AliasName { return { kind: 'function', name }; }
  / "NAMED"i ![a-zA-Z0-9_] _ "COLLECTION"i ![a-zA-Z0-9_] _ name:AliasName { return { kind: 'namedCollection', name }; }

BackupAsTable
  = _ KW_AS _ table:TableRef { return table; }

BackupPartitions
  = ( "PARTITIONS"i / "PARTITION"i ) ![a-zA-Z0-9_] _ list:ExpressionList { return list; }

BackupExceptColumns
  = "EXCEPT"i ![a-zA-Z0-9_] _ "COLUMNS"i ![a-zA-Z0-9_] _ "(" _ list:AliasNameList _ ")" { return list; }
  / "EXCEPT"i ![a-zA-Z0-9_] _ "COLUMNS"i ![a-zA-Z0-9_] _ list:AliasNameList { return list; }

BackupTableRefList
  = head:TableRef tail:( _ "," _ TableRef )* { return [head, ...tail.map(t => t[3])]; }

BackupDestination
  = name:AliasName args:( _ "(" _ ExpressionList? _ ")" )? {
      const result = { name };
      if (args !== null) result.args = args[3] || [];
      return result;
    }

AliasNameList
  = head:AliasName tail:( _ "," _ AliasName )* { return [head, ...tail.map(t => t[3])]; }

// GrantStatement: GRANT/REVOKE (priv ON target){,...}|roles TO/FROM grantees [WITH ... OPTION]
GrantStatement
  = op:( "GRANT"i / "REVOKE"i ) ![a-zA-Z0-9_]
    optionFor:( _ ( "GRANT"i / "ADMIN"i ) ![a-zA-Z0-9_] _ "OPTION"i ![a-zA-Z0-9_] _ "FOR"i ![a-zA-Z0-9_] )?
    cluster:( _ OnClusterClause )?
    _ body:( elements:GrantElementList { return { elements }; } / roles:GrantRoleList { return { roles }; } )
    _ ( "TO"i / "FROM"i ) ![a-zA-Z0-9_] _ grantees:GranteeList
    withOpts:( _ "WITH"i ![a-zA-Z0-9_] _ ( "GRANT"i / "ADMIN"i / "REPLACE"i ) ![a-zA-Z0-9_] _ "OPTION"i ![a-zA-Z0-9_] )* {
      const result = { kind: 'grant', operation: op.toUpperCase() };
      if (body.elements !== undefined) result.elements = body.elements;
      else result.roles = body.roles;
      result.grantees = grantees;
      if (optionFor !== null) result.optionFor = optionFor[1].toUpperCase();
      if (cluster !== null) result.onCluster = cluster[1];
      if (withOpts.length > 0) result.withOptions = withOpts.map(w => w[4].toUpperCase());
      return loc(accessQueryNode(result, location()));
    }

GrantElementList
  = head:GrantElement tail:( _ "," _ GrantElement )* { return [head, ...tail.map(t => t[3])]; }

GrantElement
  = privileges:GrantPrivilegeList _ "ON"i ![a-zA-Z0-9_] _ target:GrantTarget { return { privileges, target }; }

GrantRoleList
  = head:GrantPrivilege tail:( _ "," _ GrantPrivilege )* { return [head, ...tail.map(t => t[3])].map(p => p.name); }

GrantPrivilegeList
  = head:GrantPrivilege tail:( _ "," _ GrantPrivilege )* { return [head, ...tail.map(t => t[3])]; }

GrantPrivilege
  = words:GrantPrivilegeWords columns:( _ "(" _ AliasNameList _ ")" )? {
      const result = { name: words.join(' ') };
      if (columns !== null) result.columns = columns[3];
      return result;
    }

GrantPrivilegeWords
  = head:GrantPrivilegeWord tail:( _ GrantPrivilegeWord )* { return [head, ...tail.map(t => t[1])]; }

GrantPrivilegeWord
  = !( ( "ON"i / "TO"i / "FROM"i / "WITH"i ) ![a-zA-Z0-9_] ) w:$( [a-zA-Z_] [a-zA-Z0-9_]* ) { return w; }

// privilege_target: '*' | '*.*' | db.* | db.table | identifier (with optional '*' suffix on parts)
GrantTarget
  = db:GrantTargetPart _ "." _ tbl:GrantTargetPart { return { database: db, table: tbl }; }
  / tbl:GrantTargetPart { return { table: tbl }; }

GrantTargetPart
  = "*" { return '*'; }
  / name:$( [a-zA-Z_$] [a-zA-Z0-9_$]* "*"? ) { return name; }
  / "`" chars:BacktickChar* "`" { return chars.join(""); }

GranteeList
  = head:GranteeName tail:( _ "," _ GranteeName )* { return [head, ...tail.map(t => t[3])]; }

GranteeName
  = "CURRENT_USER"i ![a-zA-Z0-9_] { return 'CURRENT_USER'; }
  / name:CreateUserNameItem {
      return name.host !== undefined ? name.name + '@' + name.host : name.name;
    }

// ── ALTER access-control statements ──────────────────────────────────────────
AlterAccessStatement
  = AlterUserStatement
  / AlterRoleStatement
  / AlterQuotaStatement
  / AlterRowPolicyStatement
  / AlterSettingsProfileStatement

AlterUserStatement
  = "ALTER"i ![a-zA-Z0-9_] _ "USER"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ names:CreateUserNameList
    cluster:( _ OnClusterClause )?
    clauses:( _ AlterUserClause )* {
      const result = { kind: 'alterUser', names, clauses: clauses.map(c => c[1]) };
      if (ifExists !== null) result.ifExists = true;
      if (cluster !== null) result.onCluster = cluster[1];
      return loc(accessQueryNode(result, location()));
    }

AlterUserClause
  = "RENAME"i ![a-zA-Z0-9_] _ "TO"i ![a-zA-Z0-9_] _ to:CreateUserNameItem { return { kind: 'rename', to }; }
  / "NOT"i ![a-zA-Z0-9_] _ "IDENTIFIED"i ![a-zA-Z0-9_] { return { kind: 'notIdentified' }; }
  / "IDENTIFIED"i ![a-zA-Z0-9_] _ auth:CreateUserAuthMethods { return { kind: 'identified', auth }; }
  / mode:( "ADD"i / "DROP"i ) ![a-zA-Z0-9_] _ "HOST"i ![a-zA-Z0-9_] _ hosts:HostItemList { return { kind: 'host', mode: mode.toUpperCase(), hosts }; }
  / "HOST"i ![a-zA-Z0-9_] _ hosts:HostItemList { return { kind: 'host', hosts }; }
  / "SETTINGS"i ![a-zA-Z0-9_] _ "NONE"i ![a-zA-Z0-9_] { return { kind: 'settings', settings: 'NONE' }; }
  / "SETTINGS"i ![a-zA-Z0-9_] _ items:AccessControlSettingsList { return { kind: 'settings', settings: items }; }
  / "DEFAULT"i ![a-zA-Z0-9_] _ "ROLE"i ![a-zA-Z0-9_] _ roles:SetRoleList { return { kind: 'defaultRole', roles }; }
  / "DEFAULT"i ![a-zA-Z0-9_] _ "DATABASE"i ![a-zA-Z0-9_] _ db:AliasName { return { kind: 'defaultDatabase', database: db }; }
  / "GRANTEES"i ![a-zA-Z0-9_] _ g:SetRoleList { return { kind: 'grantees', grantees: g }; }
  / "VALID"i ![a-zA-Z0-9_] _ "UNTIL"i ![a-zA-Z0-9_] _ str:StringLiteral { return { kind: 'validUntil', value: str.value }; }

AlterRoleStatement
  = "ALTER"i ![a-zA-Z0-9_] _ "ROLE"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ names:CreateUserNameList
    cluster:( _ OnClusterClause )?
    rename:( _ "RENAME"i ![a-zA-Z0-9_] _ "TO"i ![a-zA-Z0-9_] _ CreateUserNameItem )?
    settings:( _ CreateRoleSettingsClause )? {
      const result = { kind: 'alterRole', names };
      if (ifExists !== null) result.ifExists = true;
      if (cluster !== null) result.onCluster = cluster[1];
      if (rename !== null) result.renameTo = rename[7];
      if (settings !== null) result.settings = settings[1];
      return loc(accessQueryNode(result, location()));
    }

AlterQuotaStatement
  = "ALTER"i ![a-zA-Z0-9_] _ "QUOTA"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ names:QuotaNameList
    cluster:( _ OnClusterClause )?
    rename:( _ "RENAME"i ![a-zA-Z0-9_] _ "TO"i ![a-zA-Z0-9_] _ AccessControlNameValue )?
    clauses:( _ ","? _ QuotaClause )* {
      const result = { kind: 'alterQuota', names };
      if (ifExists !== null) result.ifExists = true;
      if (cluster !== null) result.onCluster = cluster[1];
      if (rename !== null) result.renameTo = rename[7];
      const intervals = [];
      for (const c of clauses) {
        const clause = c[3];
        if (clause.keyed !== undefined) result.keyed = clause.keyed;
        if (clause.interval !== undefined) intervals.push(clause.interval);
        if (clause.to !== undefined) result.to = clause.to;
      }
      if (intervals.length > 0) result.intervals = intervals;
      return loc(accessQueryNode(result, location()));
    }

AlterRowPolicyStatement
  = "ALTER"i ![a-zA-Z0-9_] _ hasRow:( "ROW"i ![a-zA-Z0-9_] _ )? "POLICY"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ targetsResult:RowPolicyTargets
    clauses:( _ AlterRowPolicyClause )* {
      const result = { kind: 'alterRowPolicy', targets: targetsResult.targets };
      if (hasRow !== null) result.hasRowKeyword = true;
      if (ifExists !== null) result.ifExists = true;
      if (targetsResult.onCluster) result.onCluster = targetsResult.onCluster;
      for (const c of clauses) {
        const clause = c[1];
        if (clause.renameTo !== undefined) result.renameTo = clause.renameTo;
        if (clause.forSelect !== undefined) result.forSelect = clause.forSelect;
        if (clause.using !== undefined) result.using = clause.using;
        if (clause.restrictive !== undefined) result.restrictive = clause.restrictive;
        if (clause.to !== undefined) result.to = clause.to;
        if (clause.onCluster !== undefined) result.onCluster = clause.onCluster;
      }
      return loc(accessQueryNode(result, location()));
    }

AlterRowPolicyClause
  = "RENAME"i ![a-zA-Z0-9_] _ "TO"i ![a-zA-Z0-9_] _ name:AccessControlNameValue { return { renameTo: name }; }
  / "FOR"i ![a-zA-Z0-9_] _ "SELECT"i ![a-zA-Z0-9_] { return { forSelect: true }; }
  / "USING"i ![a-zA-Z0-9_] _ expr:Expression { return rowPolicyUsingClause(expr); }
  / "AS"i ![a-zA-Z0-9_] _ mode:( "RESTRICTIVE"i / "PERMISSIVE"i ) ![a-zA-Z0-9_] { return { restrictive: mode.toUpperCase() }; }
  / "TO"i ![a-zA-Z0-9_] _ target:SetRoleList { return { to: target }; }
  / "ON"i ![a-zA-Z0-9_] _ "CLUSTER"i ![a-zA-Z0-9_] _ name:( StringLiteral { return text(); } / AliasName ) { return { onCluster: name }; }

AlterSettingsProfileStatement
  = "ALTER"i ![a-zA-Z0-9_] _ hasSK:( "SETTINGS"i ![a-zA-Z0-9_] _ )? "PROFILE"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ names:QuotaNameList
    cluster:( _ OnClusterClause )?
    rename:( _ "RENAME"i ![a-zA-Z0-9_] _ "TO"i ![a-zA-Z0-9_] _ AccessControlNameValue )?
    settings:( _ CreateRoleSettingsClause )?
    to:( _ "TO"i ![a-zA-Z0-9_] _ SetRoleList )? {
      const result = { kind: 'alterSettingsProfile', names };
      if (hasSK !== null) result.hasSettingsKeyword = true;
      if (ifExists !== null) result.ifExists = true;
      if (cluster !== null) result.onCluster = cluster[1];
      if (rename !== null) result.renameTo = rename[7];
      if (settings !== null) result.settings = settings[1];
      if (to !== null) result.to = to[4];
      return loc(accessQueryNode(result, location()));
    }

// ── SHOW statements ──────────────────────────────────────────────────────────
// SHOW CREATE TABLE/VIEW/DICTIONARY/DATABASE is handled by ShowCreateStatement;
// this rule handles all other SHOW forms (including SHOW CREATE access entities).
ShowStatement
  = "SHOW"i ![a-zA-Z0-9_] _ show:ShowBody format:( _ FormatClause )? {
      // SHOW [TEMPORARY] TABLE/VIEW t and SHOW DATABASE db are exact shorthands
      // for SHOW CREATE ... and parse to the same nodes. The original
      // shorthand spelling is not preserved — format() emits the canonical
      // fully-qualified `SHOW CREATE ...` form.
      if (show.type === 'objectShorthand' || show.type === 'databaseShorthand') {
        let node;
        if (show.type === 'databaseShorthand') {
          node = {
            type: 'ShowCreateDatabaseQuery',
            database: loc(ident([show.database])),
          };
        } else {
          // The node `type` already encodes view/dictionary; no redundant
          // `is_view`/`is_dictionary` flag in the native AST.
          node = {
            type: show.objectType === 'VIEW' ? 'ShowCreateViewQuery' : 'ShowCreateTableQuery',
          };
          if (show.temporary) node.temporary = true;
          setTableTarget(node, show.table);
        }
        if (format !== null) node.format = format[1];
        return loc(node);
      }
      const result = { kind: 'show', show };
      if (format !== null) result.format = format[1];
      return loc(showFamilyNode(result, location()));
    }

ShowBody
  = ShowCreateAccessBody
  / ShowColumnsBody
  / ShowIndexesBody
  / ShowGrantsBody
  / ShowListingBody
  / ShowAccessEntitiesBody
  / ShowSettingBody
  / ShowSimpleBody
  / ShowClusterBody
  / ShowObjectShorthandBody

ShowCreateAccessBody
  = "CREATE"i ![a-zA-Z0-9_] _ ShowRowPolicyKeyword _ targets:RowPolicyTargets {
      return { type: 'createRowPolicy', policies: targets.targets };
    }
  / "CREATE"i ![a-zA-Z0-9_] _ ShowRowPolicyKeyword _ names:RowPolicyNameList {
      return { type: 'createRowPolicy', policies: names.map(name => ({ names: [name] })) };
    }
  / "CREATE"i ![a-zA-Z0-9_] _ entity:ShowCreateAccessKeyword _ names:CreateUserNameList {
      return { type: 'createAccess', entity, names };
    }

ShowRowPolicyKeyword
  = "ROW"i ![a-zA-Z0-9_] _ ( "POLICIES"i / "POLICY"i ) ![a-zA-Z0-9_]
  / ( "POLICIES"i / "POLICY"i ) ![a-zA-Z0-9_]

ShowCreateAccessKeyword
  = ( "USERS"i / "USER"i ) ![a-zA-Z0-9_] { return 'USER'; }
  / ( "ROLES"i / "ROLE"i ) ![a-zA-Z0-9_] { return 'ROLE'; }
  / ( "QUOTAS"i / "QUOTA"i ) ![a-zA-Z0-9_] { return 'QUOTA'; }
  / ( "SETTINGS"i ![a-zA-Z0-9_] _ )? ( "PROFILES"i / "PROFILE"i ) ![a-zA-Z0-9_] { return 'SETTINGS PROFILE'; }
  / "NAMED"i ![a-zA-Z0-9_] _ ( "COLLECTIONS"i / "COLLECTION"i ) ![a-zA-Z0-9_] { return 'NAMED COLLECTION'; }

ShowColumnsBody
  = extended:( "EXTENDED"i ![a-zA-Z0-9_] _ )? full:( "FULL"i ![a-zA-Z0-9_] _ )?
    kw:( "COLUMNS"i { return 'COLUMNS'; } / "FIELDS"i { return 'FIELDS'; } ) ![a-zA-Z0-9_]
    _ ( "FROM"i / "IN"i ) ![a-zA-Z0-9_] _ table:TableRef
    from:( _ ( "FROM"i / "IN"i ) ![a-zA-Z0-9_] _ ( QueryParamIdentifier / AliasName ) )?
    like:( _ ShowLikeClause )?
    where:( _ "WHERE"i ![a-zA-Z0-9_] _ Expression )?
    limit:( _ "LIMIT"i ![a-zA-Z0-9_] _ Expression )? {
      const result = { type: 'columns', keyword: kw, table };
      if (extended !== null) result.extended = true;
      if (full !== null) result.full = true;
      if (from !== null) result.from = from[4];
      if (like !== null) result.like = like[1];
      if (where !== null) result.where = where[4];
      if (limit !== null) result.limit = limit[4];
      return result;
    }

ShowIndexesBody
  = extended:( "EXTENDED"i ![a-zA-Z0-9_] _ )?
    kw:( "INDEXES"i { return 'INDEXES'; } / "INDICES"i { return 'INDICES'; } / "INDEX"i { return 'INDEX'; } / "KEYS"i { return 'KEYS'; } ) ![a-zA-Z0-9_]
    _ ( "FROM"i / "IN"i ) ![a-zA-Z0-9_] _ table:TableRef
    from:( _ ( "FROM"i / "IN"i ) ![a-zA-Z0-9_] _ ( QueryParamIdentifier / AliasName ) )?
    where:( _ "WHERE"i ![a-zA-Z0-9_] _ Expression )? {
      const result = { type: 'indexes', keyword: kw, table };
      if (extended !== null) result.extended = true;
      if (from !== null) result.from = from[4];
      if (where !== null) result.where = where[4];
      return result;
    }

ShowGrantsBody
  = "GRANTS"i ![a-zA-Z0-9_]
    forClause:( _ "FOR"i ![a-zA-Z0-9_] _ GranteeList )?
    impl:( _ "WITH"i ![a-zA-Z0-9_] _ "IMPLICIT"i ![a-zA-Z0-9_] )?
    final:( _ "FINAL"i ![a-zA-Z0-9_] )? {
      const result = { type: 'grants' };
      if (forClause !== null) result.for = forClause[4];
      if (impl !== null) result.withImplicit = true;
      if (final !== null) result.final = true;
      return result;
    }

ShowListingBody
  = temp:( "TEMPORARY"i ![a-zA-Z0-9_] _ )?
    objectType:( "TABLES"i { return 'TABLES'; } / "DATABASES"i { return 'DATABASES'; } / "DICTIONARIES"i { return 'DICTIONARIES'; } ) ![a-zA-Z0-9_]
    from:( _ ( "FROM"i / "IN"i ) ![a-zA-Z0-9_] _ ( QueryParamIdentifier / AliasName ) )?
    like:( _ ShowLikeClause )?
    where:( _ "WHERE"i ![a-zA-Z0-9_] _ Expression )?
    limit:( _ "LIMIT"i ![a-zA-Z0-9_] _ Expression )?
    settings:( _ SettingsClause )? {
      const result = { type: 'listing', objectType };
      if (temp !== null) result.temporary = true;
      if (from !== null) result.from = from[4];
      if (like !== null) result.like = like[1];
      if (where !== null) result.where = where[4];
      if (limit !== null) result.limit = limit[4];
      if (settings !== null) result.settings = settings[1];
      return result;
    }

ShowAccessEntitiesBody
  = changedPre:( "CHANGED"i ![a-zA-Z0-9_] _ )? "SETTINGS"i ![a-zA-Z0-9_] _ "PROFILES"i ![a-zA-Z0-9_] {
      return { type: 'accessEntities', objectType: 'SETTINGS PROFILES' };
    }
  / changedPre:( "CHANGED"i ![a-zA-Z0-9_] _ )? "SETTINGS"i ![a-zA-Z0-9_] like:( _ ShowLikeClause )? changedPost:( _ "CHANGED"i ![a-zA-Z0-9_] )? {
      const result = { type: 'accessEntities', objectType: 'SETTINGS' };
      if (changedPre !== null || changedPost !== null) result.modifier = 'CHANGED';
      if (like !== null) result.like = like[1];
      return result;
    }
  / "ROW"i ![a-zA-Z0-9_] _ "POLICIES"i ![a-zA-Z0-9_] { return { type: 'accessEntities', objectType: 'ROW POLICIES' }; }
  / "POLICIES"i ![a-zA-Z0-9_] { return { type: 'accessEntities', objectType: 'ROW POLICIES' }; }
  / "NAMED"i ![a-zA-Z0-9_] _ "COLLECTIONS"i ![a-zA-Z0-9_] { return { type: 'accessEntities', objectType: 'NAMED COLLECTIONS' }; }
  / "PROFILES"i ![a-zA-Z0-9_] { return { type: 'accessEntities', objectType: 'SETTINGS PROFILES' }; }
  / "CLUSTERS"i ![a-zA-Z0-9_] like:( _ ShowLikeClause )? limit:( _ "LIMIT"i ![a-zA-Z0-9_] _ Expression )? {
      const result = { type: 'accessEntities', objectType: 'CLUSTERS' };
      if (like !== null) result.like = like[1];
      if (limit !== null) result.limit = limit[4];
      return result;
    }
  / mod:( ( "CURRENT"i / "ENABLED"i ) ![a-zA-Z0-9_] _ )? "ROLES"i ![a-zA-Z0-9_] {
      const result = { type: 'accessEntities', objectType: 'ROLES' };
      if (mod !== null) result.modifier = mod[0].toUpperCase();
      return result;
    }
  / "USERS"i ![a-zA-Z0-9_] { return { type: 'accessEntities', objectType: 'USERS' }; }
  / "QUOTAS"i ![a-zA-Z0-9_] { return { type: 'accessEntities', objectType: 'QUOTAS' }; }
  / "WARNINGS"i ![a-zA-Z0-9_] { return { type: 'accessEntities', objectType: 'WARNINGS' }; }

ShowSettingBody
  = "SETTING"i ![a-zA-Z0-9_] _ name:( QueryParamIdentifier / AliasName ) { return { type: 'setting', name }; }

ShowSimpleBody
  = "PRIVILEGES"i ![a-zA-Z0-9_] { return { type: 'privileges' }; }
  / "ENGINES"i ![a-zA-Z0-9_] { return { type: 'engines' }; }
  / "MERGES"i ![a-zA-Z0-9_] like:( _ ShowLikeClause )? limit:( _ "LIMIT"i ![a-zA-Z0-9_] _ Expression )? {
      const result = { type: 'merges' };
      if (like !== null) result.like = like[1];
      if (limit !== null) result.limit = limit[4];
      return result;
    }
  / "ACCESS"i ![a-zA-Z0-9_] { return { type: 'access' }; }
  / "PROCESSLIST"i ![a-zA-Z0-9_] { return { type: 'processlist' }; }
  / "FUNCTIONS"i ![a-zA-Z0-9_] like:( _ ShowLikeClause )? {
      const result = { type: 'functions' };
      if (like !== null) result.like = like[1];
      return result;
    }

ShowClusterBody
  = "CLUSTER"i ![a-zA-Z0-9_] _ name:StringLiteral { return { type: 'cluster', name: name.value }; }
  / "CLUSTER"i ![a-zA-Z0-9_] _ name:( QueryParamIdentifier / AliasName ) { return { type: 'cluster', name }; }

ShowObjectShorthandBody
  = temp:( "TEMPORARY"i ![a-zA-Z0-9_] _ )? kw:( "TABLE"i { return 'TABLE'; } / "VIEW"i { return 'VIEW'; } ) ![a-zA-Z0-9_] _ table:TableRef {
      const result = { type: 'objectShorthand', objectType: kw, table };
      if (temp !== null) result.temporary = true;
      return result;
    }
  / "DATABASE"i ![a-zA-Z0-9_] _ db:( QueryParamIdentifier / AliasName ) { return { type: 'databaseShorthand', database: db }; }

ShowLikeClause
  = not:( "NOT"i ![a-zA-Z0-9_] _ )? kw:( "ILIKE"i { return true; } / "LIKE"i { return false; } ) ![a-zA-Z0-9_] _ pat:StringLiteral {
      const result = { pattern: pat.value };
      if (not !== null) result.not = true;
      if (kw) result.ilike = true;
      return result;
    }

DropTargetType
  = "TABLE"i ![a-zA-Z0-9_] { return 'TABLE'; }
  / "VIEW"i ![a-zA-Z0-9_] { return 'VIEW'; }
  / "DICTIONARY"i ![a-zA-Z0-9_] { return 'DICTIONARY'; }
  / "DATABASE"i ![a-zA-Z0-9_] { return 'DATABASE'; }
  / "FUNCTION"i ![a-zA-Z0-9_] { return 'FUNCTION'; }

// Access-control entity keywords for DROP {USER|ROLE|QUOTA|[SETTINGS] PROFILE}.
// (ROW POLICY is handled separately; NAMED COLLECTION / WORKLOAD / RESOURCE
// have dedicated drop nodes via the opaque fallback.)
DropAccessEntityKeyword
  = ( "USERS"i / "USER"i ) ![a-zA-Z0-9_] { return 'USER'; }
  / ( "ROLES"i / "ROLE"i ) ![a-zA-Z0-9_] { return 'ROLE'; }
  / ( "QUOTAS"i / "QUOTA"i ) ![a-zA-Z0-9_] { return 'QUOTA'; }
  / ( "SETTINGS"i ![a-zA-Z0-9_] _ )? ( "PROFILES"i / "PROFILE"i ) ![a-zA-Z0-9_] { return 'SETTINGS PROFILE'; }

// ── INSERT statements ────────────────────────────────────────────────────────

// InsertStatement: INSERT INTO [TABLE] target [(columns)] [SETTINGS ...] [data]
// target can be a table reference or TABLE FUNCTION / FUNCTION call
InsertStatement
  = withClause:CTEClause _ "INSERT"i ![a-zA-Z0-9_] _ "INTO"i ![a-zA-Z0-9_] _ target:InsertTarget
    partitionBy:( _ "PARTITION"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ Expression )?
    columns:( _ InsertColumnList )?
    fromInfile:( _ InsertFromInfileClause )?
    insertSettings:( _ SettingsClause )?
    data:InsertDataClause {
      const o = { target: target };
      const insertWith =
        withClause && withClause.items ? withClause.items.map(cteToWithItem) : undefined;
      if (partitionBy !== null) o.partitionBy = partitionBy[7];
      if (columns !== null) o.columns = columns[1];
      if (fromInfile !== null) o.fromInfile = fromInfile[1];
      if (insertSettings !== null) o.insertSettings = insertSettings[1];
      if (data !== null) {
        if (data.query !== undefined) {
          o.selectQuery = insertWith !== undefined
            ? attachInsertWith(data.query, insertWith)
            : data.query;
        }
        if (data.querySettings) o.querySettings = data.querySettings;
        if (data.format !== undefined) o.format = data.format;
      }
      return loc(insertQueryNode(o));
    }
  / "INSERT"i ![a-zA-Z0-9_] _ "INTO"i ![a-zA-Z0-9_] _ target:InsertTarget
    partitionBy:( _ "PARTITION"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ Expression )?
    columns:( _ InsertColumnList )?
    fromInfile:( _ InsertFromInfileClause )?
    insertSettings:( _ SettingsClause )?
    data:InsertDataClause {
      const o = { target: target };
      if (partitionBy !== null) o.partitionBy = partitionBy[7];
      if (columns !== null) o.columns = columns[1];
      if (fromInfile !== null) o.fromInfile = fromInfile[1];
      if (insertSettings !== null) o.insertSettings = insertSettings[1];
      if (data !== null) {
        if (data.query !== undefined) o.selectQuery = data.query;
        if (data.querySettings) o.querySettings = data.querySettings;
        if (data.format !== undefined) o.format = data.format;
      }
      return loc(insertQueryNode(o));
    }

// InsertFromInfileClause: FROM INFILE 'path' [COMPRESSION 'name']
InsertFromInfileClause
  = "FROM"i ![a-zA-Z0-9_] _ "INFILE"i ![a-zA-Z0-9_] _ path:StringLiteral
    compression:( _ "COMPRESSION"i ![a-zA-Z0-9_] _ comp:StringLiteral { return comp; } )? {
      const result = { path };
      if (compression !== null) result.compression = compression;
      return result;
    }

// InsertTarget: identifies what to insert into (table or table function)
InsertTarget
  = "TABLE"i ![a-zA-Z0-9_] _ "FUNCTION"i ![a-zA-Z0-9_] _ func:InsertFunctionCall { return { kind: 'function', func }; }
  / "FUNCTION"i ![a-zA-Z0-9_] _ func:InsertFunctionCall { return { kind: 'function', func }; }
  / "TABLE"i ![a-zA-Z0-9_] _ table:TableRef { return { kind: 'table', table }; }
  / table:TableRef { return { kind: 'table', table }; }

// InsertFunctionCall: parses a function call in INSERT INTO [TABLE] FUNCTION context
InsertFunctionCall
  = name:FunctionName _ "(" _ args:FunctionCallArgList? _ ")" {
      return loc({ kind: 'tableFunctionRef', name, args: args !== null ? args : [] });
    }

// InsertColumnList: optional column list with support for trailing comma and complex expressions
// Supports identifiers, asterisks with transformers, qualified asterisks, COLUMNS(), etc.
InsertColumnList
  = "(" _ head:SelectItem tail:( _ "," _ SelectItem )* _ ","? _ ")" {
      return buildCommaList(head, tail);
    }

// InsertDataClause: VALUES / FORMAT name / SELECT query / empty.
// For INSERT...SELECT...FORMAT, the FORMAT + data is consumed after the SELECT.
// `format` is the user-written format name (e.g. `Values`, `JSON`); ClickHouse
// emits it in the native AST under InsertQuery.format.
InsertDataClause
  = _ "VALUES"i ![a-zA-Z0-9_] InsertRawData { return { format: 'Values' }; }
  / _ "FORMAT"i ![a-zA-Z0-9_] _ name:$([A-Za-z_][A-Za-z0-9_]*) InsertRawData { return { format: name }; }
  / _ query:UnionQuery querySettings:( _ SettingsClause )? trailingFmt:( _ FormatClause InsertRawData )? {
      const out = { query, querySettings: querySettings ? querySettings[1] : null };
      if (trailingFmt !== null) out.format = trailingFmt[1];
      return out;
    }
  / "" { return null; }

// InsertRawData: consumes everything until ";" or end of input (including newlines, strings)
InsertRawData
  = ( "'" ( "''" / "\\'" / "\\\\" / !"'" ( [\n\r] / . ) )* "'"
    / !";" ( [\n\r] / . )
  )*

// ── CREATE statements ────────────────────────────────────────────────────────

// PARALLEL WITH: chains multiple statements (CREATE, INSERT, TRUNCATE, etc.)
ParallelWithStatement
  = head:CreateStatement tail:( _ "PARALLEL"i ![a-zA-Z0-9_] _ "WITH"i ![a-zA-Z0-9_] _ CreateStatement )+ {
      return loc(accessQueryNode({ kind: 'parallelWith', queries: [head, ...tail.map(t => t[7])] }, location()));
    }
  / head:ParallelWithItem tail:( _ "PARALLEL"i ![a-zA-Z0-9_] _ "WITH"i ![a-zA-Z0-9_] _ ParallelWithItem )+ {
      return loc(accessQueryNode({ kind: 'parallelWith', queries: [head, ...tail.map(t => t[7])] }, location()));
    }

ParallelWithItem
  = InsertStatement
  / DropStatement
  / UndropStatement
  / BackupStatement
  / TruncateStatement
  / OptimizeStatement
  / AlterStatement

// TruncateStatement: structural parsing for all TRUNCATE variants
//   TRUNCATE [TEMPORARY] [TABLE] [IF EXISTS] [db.]table [ON CLUSTER cluster] [SYNC] [SETTINGS ...]
//   TRUNCATE DATABASE [IF EXISTS] db [ON CLUSTER cluster] [SYNC]
//   TRUNCATE [ALL] TABLES FROM [IF EXISTS] db [ON CLUSTER cluster] [[NOT] LIKE 'pattern']
TruncateStatement
  = "TRUNCATE"i ![a-zA-Z0-9_]
    all:( _ "ALL"i ![a-zA-Z0-9_] )? _ "TABLES"i ![a-zA-Z0-9_]
    _ "FROM"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ database:( QueryParamIdentifier / AliasName )
    cluster:( _ OnClusterClause )?
    likeClause:( _ ( "NOT"i ![a-zA-Z0-9_] _ )? ( "ILIKE"i { return true; } / "LIKE"i { return false; } ) ![a-zA-Z0-9_] _ StringLiteral )? {
      const o = { targetType: 'TABLES', database, location: location() };
      if (all !== null) o.allTables = true;
      if (ifExists !== null) o.ifExists = true;
      if (cluster !== null) o.onCluster = cluster[1];
      if (likeClause !== null) {
        const notKw = likeClause[1];
        const ilike = likeClause[2];
        const pattern = likeClause[5].value;
        o.like = { pattern };
        if (notKw !== null) o.like.not = true;
        if (ilike) o.like.ilike = true;
      }
      return loc(dropFamilyNode('TruncateQuery', o));
    }
  / "TRUNCATE"i ![a-zA-Z0-9_]
    _ "DATABASE"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ database:( QueryParamIdentifier / AliasName )
    cluster:( _ OnClusterClause )? {
      const o = { targetType: 'DATABASE', database, location: location() };
      if (ifExists !== null) o.ifExists = true;
      if (cluster !== null) o.onCluster = cluster[1];
      return loc(dropFamilyNode('TruncateQuery', o));
    }
  / "TRUNCATE"i ![a-zA-Z0-9_]
    temp:( _ "TEMPORARY"i ![a-zA-Z0-9_] )?
    ( _ "TABLE"i ![a-zA-Z0-9_] )?
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ table:TableRef
    cluster:( _ OnClusterClause )?
    settings:( _ SettingsClause )? {
      const o = { targetType: 'TABLE', table };
      if (temp !== null) o.temporary = true;
      if (ifExists !== null) o.ifExists = true;
      if (cluster !== null) o.onCluster = cluster[1];
      if (settings !== null) o.settings = settings[1];
      return loc(dropFamilyNode('TruncateQuery', o));
    }

// ── OPTIMIZE TABLE ───────────────────────────────────────────────────────────
// OPTIMIZE TABLE [db.]name [ON CLUSTER cluster] [PARTITION expr | PARTITION ID 'id'] [FINAL] [DEDUPLICATE [BY ...]]
OptimizeStatement
  = "OPTIMIZE"i ![a-zA-Z0-9_] _ "TABLE"i ![a-zA-Z0-9_] _ table:TableRef
    cluster:( _ OnClusterClause )?
    partition:OptimizePartitionClause?
    final:( _ ( "FINAL"i / "FORCE"i ) ![a-zA-Z0-9_] )?
    cleanup:( _ "CLEANUP"i ![a-zA-Z0-9_] )?
    dedup:OptimizeDeduplicateClause?
    settings:( _ SettingsClause )? {
      const node = { type: 'OptimizeQuery' };
      setTableTarget(node, table);
      if (partition !== null) node.partition = partitionChildNode(partition);
      if (cluster !== null) node.cluster = cluster[1];
      if (final !== null) node.final = true;
      if (cleanup !== null) node.cleanup = true;
      if (dedup !== null) {
        node.deduplicate = true;
        if (dedup.by) node.deduplicate_by_columns = exprList(dedup.by);
      }
      if (settings !== null && settings[1].length > 0) node.settings = setNode(settings[1]);
      return loc(node);
    }

OptimizePartitionClause
  = _ "PARTITION"i ![a-zA-Z0-9_] _ "ID"i ![a-zA-Z0-9_] _ lit:StringLiteral {
      return { kind: 'id', id: lit.value, location: location() };
    }
  / _ "PARTITION"i ![a-zA-Z0-9_] _ "ALL"i ![a-zA-Z0-9_] {
      return { kind: 'all', location: location() };
    }
  / _ "PARTITION"i ![a-zA-Z0-9_] _ expr:Expression {
      return { kind: 'expr', expr, location: location() };
    }

OptimizeDeduplicateClause
  = _ "DEDUPLICATE"i ![a-zA-Z0-9_] by:OptimizeDeduplicateByClause? {
      return { by: by };
    }

OptimizeDeduplicateByClause
  = _ "BY"i ![a-zA-Z0-9_] _ list:ExpressionList { return list; }

// ── DESC / DESCRIBE TABLE ────────────────────────────────────────────────────
// DESC[RIBE] [TABLE] name | DESC (subquery) | DESC fn(...)
DescribeStatement
  = ( "DESCRIBE"i / "DESC"i ) ![a-zA-Z0-9_]
    ( _ "TABLE"i ![a-zA-Z0-9_] )?
    _ target:DescribeTarget
    final:( _ "FINAL"i ![a-zA-Z0-9_] )?
    preSettings:( _ SettingsClause )?
    format:( _ FormatClause )?
    postSettings:( _ SettingsClause )? {
      const te = { type: 'TableExpression' };
      if (target.kind === 'table') {
        te.database_and_table_name = tableIdentNode(target.table);
      } else if (target.kind === 'function') {
        te.table_function = withLoc(fn(target.func.name, target.func.args), target.func.location ?? spanOf(target.func.args));
      } else {
        te.subquery = subqueryNode(target.query);
      }
      if (final !== null) te.final = true;
      withLoc(te, spanOf([te.database_and_table_name, te.table_function, te.subquery]));
      const node = { type: 'DescribeQuery', table_expression: te };
      const merged = [
        ...(preSettings !== null ? preSettings[1] : []),
        ...(postSettings !== null ? postSettings[1] : []),
      ];
      if (merged.length > 0) node.settings = setNode(merged);
      if (format !== null) node.format = format[1];
      // Preserve source ordering: `SETTINGS ... FORMAT name` vs
      // `FORMAT name SETTINGS ...`.
      if (preSettings !== null && format !== null) node.settings_before_format = true;
      return loc(node);
    }

DescribeTarget
  = "(" _ query:UnionQuery _ ")" { return { kind: 'subquery', query }; }
  / &( "SELECT"i ![a-zA-Z0-9_] / "WITH"i ![a-zA-Z0-9_] ) query:UnionQuery {
      return { kind: 'subquery', query };
    }
  / func:TableFunctionRef { return { kind: 'function', func }; }
  / table:TableRef { return { kind: 'table', table }; }

// ── SHOW CREATE ──────────────────────────────────────────────────────────────
// SHOW CREATE [TABLE|VIEW|DICTIONARY|DATABASE] [db.]name [FORMAT ...] [SETTINGS ...]
ShowCreateStatement
  = "SHOW"i ![a-zA-Z0-9_] _ "CREATE"i ![a-zA-Z0-9_] target:ShowCreateTarget
    preSettings:( _ SettingsClause )?
    format:( _ FormatClause )?
    postSettings:( _ SettingsClause )? {
      const result = target;
      if (format !== null) result.format = format[1];
      const merged = [
        ...(preSettings !== null ? preSettings[1] : []),
        ...(postSettings !== null ? postSettings[1] : []),
      ];
      const LABELS = { TABLE: 'ShowCreateTableQuery', VIEW: 'ShowCreateViewQuery', DICTIONARY: 'ShowCreateDictionaryQuery' };
      let node;
      if (result.targetType === 'DATABASE') {
        node = { type: 'ShowCreateDatabaseQuery', database: loc(ident([result.database])) };
      } else {
        // The node `type` already encodes view/dictionary; no redundant
        // `is_view`/`is_dictionary` flag in the native AST.
        node = { type: LABELS[result.targetType] };
        if (result.temporary) node.temporary = true;
        setTableTarget(node, result.table);
      }
      if (merged.length > 0) node.settings = setNode(merged);
      if (result.format !== undefined) node.format = result.format;
      return loc(node);
    }

ShowCreateTarget
  = _ "DATABASE"i ![a-zA-Z0-9_] _ db:( QueryParamIdentifier / AliasName ) {
      return { kind: 'showCreate', targetType: 'DATABASE', database: db };
    }
  / temporary:( _ "TEMPORARY"i ![a-zA-Z0-9_] )? _ targetType:ShowCreateTargetKeyword _ table:TableRef {
      return { kind: 'showCreate', targetType, table, temporary: temporary !== null };
    }
  / _ "TEMPORARY"i ![a-zA-Z0-9_] _ table:TableRef {
      return { kind: 'showCreate', targetType: 'TABLE', table, temporary: true };
    }
  / _ !ShowCreateAccessControlKeyword table:TableRef {
      return { kind: 'showCreate', targetType: 'TABLE', table };
    }

// Keywords that indicate SHOW CREATE targeting an access-control object; these
// are excluded here so ShowStatement (which handles SHOW CREATE USER/ROLE/etc.)
// can parse them structurally instead.
ShowCreateAccessControlKeyword
  = "USER"i ![a-zA-Z0-9_]
  / "ROLE"i ![a-zA-Z0-9_]
  / "QUOTA"i ![a-zA-Z0-9_]
  / "ROW"i ![a-zA-Z0-9_] _ "POLICY"i
  / "POLICY"i ![a-zA-Z0-9_]
  / "SETTINGS"i ![a-zA-Z0-9_] _ "PROFILE"i
  / "PROFILE"i ![a-zA-Z0-9_]
  / "NAMED"i ![a-zA-Z0-9_] _ "COLLECTION"i
  / "WORKLOAD"i ![a-zA-Z0-9_]
  / "RESOURCE"i ![a-zA-Z0-9_]

ShowCreateTargetKeyword
  = "TABLE"i ![a-zA-Z0-9_] { return 'TABLE'; }
  / "VIEW"i ![a-zA-Z0-9_] { return 'VIEW'; }
  / "DICTIONARY"i ![a-zA-Z0-9_] { return 'DICTIONARY'; }

// ── DETACH ───────────────────────────────────────────────────────────────────
// DETACH [TABLE|VIEW|DICTIONARY] [IF EXISTS] [db.]name [ON CLUSTER ...] [PERMANENTLY] [SYNC]
// DETACH DATABASE [IF EXISTS] name [ON CLUSTER ...] [PERMANENTLY] [SYNC]
DetachStatement
  = "DETACH"i ![a-zA-Z0-9_] _ "DATABASE"i ![a-zA-Z0-9_]
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ database:( QueryParamIdentifier / AliasName )
    cluster:( _ OnClusterClause )?
    perm:( _ "PERMANENTLY"i ![a-zA-Z0-9_] )?
    sync:( _ "SYNC"i ![a-zA-Z0-9_] / _ "NO"i ![a-zA-Z0-9_] _ "DELAY"i ![a-zA-Z0-9_] )?
    &StatementEnd {
      const o = { targetType: 'DATABASE', database, location: location() };
      if (ifExists !== null) o.ifExists = true;
      if (cluster !== null) o.onCluster = cluster[1];
      if (perm !== null) o.permanently = true;
      if (sync !== null) o.sync = true;
      return loc(dropFamilyNode('DetachQuery', o));
    }
  / "DETACH"i ![a-zA-Z0-9_]
    targetType:DetachTableKeyword?
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ table:TableRef
    cluster:( _ OnClusterClause )?
    perm:( _ "PERMANENTLY"i ![a-zA-Z0-9_] )?
    sync:( _ "SYNC"i ![a-zA-Z0-9_] / _ "NO"i ![a-zA-Z0-9_] _ "DELAY"i ![a-zA-Z0-9_] )?
    &StatementEnd {
      const o = {
        targetType: targetType !== null ? targetType.target : 'TABLE',
        table,
      };
      if (targetType !== null && targetType.temporary) o.temporary = true;
      if (ifExists !== null) o.ifExists = true;
      if (cluster !== null) o.onCluster = cluster[1];
      if (perm !== null) o.permanently = true;
      if (sync !== null) o.sync = true;
      return loc(dropFamilyNode('DetachQuery', o));
    }

DetachTableKeyword
  = _ temp:( "TEMPORARY"i ![a-zA-Z0-9_] _ )? "TABLE"i ![a-zA-Z0-9_] { return { target: 'TABLE', temporary: temp !== null }; }
  / _ "VIEW"i ![a-zA-Z0-9_] { return { target: 'VIEW', temporary: false }; }
  / _ "DICTIONARY"i ![a-zA-Z0-9_] { return { target: 'DICTIONARY', temporary: false }; }

// ── UPDATE (lightweight) ────────────────────────────────────────────────────
// UPDATE [db.]name [ON CLUSTER cluster] SET col = expr [, ...] WHERE expr [SETTINGS ...]
UpdateStatement
  = "UPDATE"i ![a-zA-Z0-9_] _ table:TableRef
    cluster:( _ OnClusterClause )?
    _ "SET"i ![a-zA-Z0-9_] _ assignments:AlterAssignmentList
    _ "WHERE"i ![a-zA-Z0-9_] _ where:Expression
    settings:( _ SettingsClause )? {
      const node = { type: 'UpdateQuery' };
      setTableTarget(node, table);
      node.assignments = assignments.map((a) => withLoc({
        type: 'Assignment',
        column: a.column,
        expression: a.expr,
      }, a.location ?? spanOf([a.expr])));
      node.predicate = where;
      if (settings !== null && settings[1].length > 0) node.settings = setNode(settings[1]);
      if (cluster !== null) node.cluster = cluster[1];
      return loc(node);
    }

// ── DELETE FROM ──────────────────────────────────────────────────────────────
// DELETE FROM [db.]name [ON CLUSTER cluster] [IN PARTITION expr] WHERE expr [SETTINGS ...]
DeleteStatement
  = "DELETE"i ![a-zA-Z0-9_] _ "FROM"i ![a-zA-Z0-9_] _ table:TableRef
    cluster:( _ OnClusterClause )?
    partition:DeleteInPartitionClause?
    _ "WHERE"i ![a-zA-Z0-9_] _ where:Expression
    settings:( _ SettingsClause )? {
      const node = { type: 'DeleteQuery' };
      setTableTarget(node, table);
      if (cluster !== null) node.cluster = cluster[1];
      if (partition !== null) node.partition = partitionChildNode(partition);
      node.predicate = where;
      if (settings !== null && settings[1].length > 0) node.settings = setNode(settings[1]);
      return loc(node);
    }

DeleteInPartitionClause
  = _ "IN"i ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ "ID"i ![a-zA-Z0-9_] _ lit:StringLiteral {
      return { kind: 'id', id: lit.value };
    }
  / _ "IN"i ![a-zA-Z0-9_] _ "PARTITION"i ![a-zA-Z0-9_] _ expr:Expression {
      return { kind: 'expr', expr };
    }

// ── CHECK TABLE / CHECK DATABASE / CHECK ALL TABLES ──────────────────────────
CheckStatement
  = "CHECK"i ![a-zA-Z0-9_] _ "ALL"i ![a-zA-Z0-9_] _ "TABLES"i ![a-zA-Z0-9_]
    settings:( _ SettingsClause )? {
      const node = { type: 'CheckAllQuery' };
      if (settings !== null && settings[1].length > 0) node.settings = setNode(settings[1]);
      return loc(node);
    }
  / "CHECK"i ![a-zA-Z0-9_] _ "DATABASE"i ![a-zA-Z0-9_]
    _ database:( QueryParamIdentifier / AliasName )
    settings:( _ SettingsClause )? {
      const node = { type: 'CheckQuery', database: ident([database]) };
      if (settings !== null && settings[1].length > 0) node.settings = setNode(settings[1]);
      return loc(node);
    }
  / "CHECK"i ![a-zA-Z0-9_] ( _ "TABLE"i ![a-zA-Z0-9_] )?
    _ table:TableRef
    partition:CheckPartitionClause?
    preSettings:( _ SettingsClause )?
    format:( _ FormatClause )?
    postSettings:( _ SettingsClause )?
    &StatementEnd {
      const node = { type: 'CheckQuery' };
      setTableTarget(node, table);
      if (partition !== null) {
        if (partition.kind === 'part') node.part_name = partition.partName;
        else node.partition = alterPartitionNode(partition.part);
      }
      if (format !== null) node.format = format[1];
      const mergedSettings = [
        ...(preSettings !== null ? preSettings[1] : []),
        ...(postSettings !== null ? postSettings[1] : []),
      ];
      if (mergedSettings.length > 0) node.settings = setNode(mergedSettings);
      return loc(node);
    }

CheckPartitionClause
  = _ "PARTITION"i ![a-zA-Z0-9_] _ part:AlterPartitionExpr {
      return { kind: 'partition', part };
    }
  / _ "PART"i ![a-zA-Z0-9_] _ lit:StringLiteral {
      return { kind: 'part', partName: lit.value };
    }

// ── ATTACH ───────────────────────────────────────────────────────────────────
// ATTACH [TABLE|VIEW|DICTIONARY] [IF NOT EXISTS] [db.]name [UUID '...'] [ON CLUSTER ...]
// ATTACH DATABASE [IF NOT EXISTS] name [ON CLUSTER ...]
// Only matches SIMPLE ATTACH forms. ATTACH MATERIALIZED VIEW (with columns/
// ENGINE/AS SELECT) is handled by CreateMaterializedViewStatement.
AttachStatement
  = "ATTACH"i ![a-zA-Z0-9_] _ "DATABASE"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ database:( QueryParamIdentifier / AliasName )
    cluster:( _ OnClusterClause )?
    &StatementEnd {
      const node = {
        type: 'AttachQuery',
        attach: true,
        database: loc(ident([database])),
      };
      if (ifne !== null) node.if_not_exists = true;
      if (cluster !== null) node.cluster = cluster[1];
      return loc(node);
    }
  / "ATTACH"i ![a-zA-Z0-9_]
    targetType:AttachTableKeyword
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ table:TableRef
    uuid:( _ "UUID"i ![a-zA-Z0-9_] _ StringLiteral )?
    cluster:( _ OnClusterClause )?
    &StatementEnd {
      const node = { type: 'AttachQuery', attach: true };
      if (targetType.target === 'DICTIONARY') node.is_dictionary = true;
      else if (targetType.target === 'VIEW') node.is_view = true;
      if (targetType.temporary) node.temporary = true;
      setTableTarget(node, table);
      if (ifne !== null) node.if_not_exists = true;
      if (uuid !== null) node.uuid = uuid[4].value;
      if (cluster !== null) node.cluster = cluster[1];
      return loc(node);
    }

// Positive lookahead: current position is the end of a statement (whitespace
// followed by `;` or EOF). Used by simple statement rules that must not
// over-consume when additional content (e.g. ENGINE, AS SELECT) follows.
StatementEnd
  = _ (";" / !.)

AttachTableKeyword
  = _ temp:( "TEMPORARY"i ![a-zA-Z0-9_] _ )? "TABLE"i ![a-zA-Z0-9_] { return { target: 'TABLE', temporary: temp !== null }; }
  / _ "VIEW"i ![a-zA-Z0-9_] { return { target: 'VIEW', temporary: false }; }
  / _ "DICTIONARY"i ![a-zA-Z0-9_] { return { target: 'DICTIONARY', temporary: false }; }

// ── RENAME TABLE / RENAME DATABASE / RENAME DICTIONARY ───────────────────────
// The target keyword (TABLE/DATABASE/DICTIONARY) is optional for RENAME (defaults to TABLE).
RenameStatement
  = exchange:( "EXCHANGE"i ![a-zA-Z0-9_] { return true; } / "RENAME"i ![a-zA-Z0-9_] { return false; } )
    targetType:( _ RenameTargetKeyword )?
    ifExists:( _ "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ head:RenamePair tail:( _ "," _ RenamePair )*
    cluster:( _ OnClusterClause )?
    settings:( _ SettingsClause )?
    &StatementEnd {
      const pairs = [head, ...tail.map((t) => t[3])];
      const kind = targetType !== null ? targetType[1] : 'TABLE';
      const node = {
        type: 'Rename',
        elements: pairs.map((pair) => {
          if (kind === 'DATABASE') {
            // `RENAME DATABASE a TO b` carries the database names in the table
            // slot of `TableRef`; emit only the *_database fields.
            const dbEl = { from_database: pair.from.table, to_database: pair.to.table };
            if (ifExists !== null) dbEl.if_exists = true;
            return dbEl;
          }
          const el = {};
          if (pair.from.database !== undefined) el.from_database = pair.from.database;
          el.from_table = pair.from.table;
          if (pair.to.database !== undefined) el.to_database = pair.to.database;
          el.to_table = pair.to.table;
          // ClickHouse's native AST carries IF EXISTS on each rename element.
          if (ifExists !== null) el.if_exists = true;
          return el;
        }),
      };
      if (kind === 'DICTIONARY') node.dictionary = true;
      else if (kind === 'DATABASE') node.database = true;
      if (exchange) node.exchange = true;
      if (cluster !== null) node.cluster = cluster[1];
      if (settings !== null && settings[1].length > 0) node.settings = setNode(settings[1]);
      return loc(node);
    }

RenameTargetKeyword
  = "TABLES"i ![a-zA-Z0-9_] { return 'TABLE'; }
  / "TABLE"i ![a-zA-Z0-9_] { return 'TABLE'; }
  / "DATABASE"i ![a-zA-Z0-9_] { return 'DATABASE'; }
  / "DICTIONARIES"i ![a-zA-Z0-9_] { return 'DICTIONARY'; }
  / "DICTIONARY"i ![a-zA-Z0-9_] { return 'DICTIONARY'; }

RenamePair
  = from:TableRef _ ( "TO"i / "AND"i ) ![a-zA-Z0-9_] _ to:TableRef {
      return { from, to };
    }

// ── KILL QUERY / KILL MUTATION ───────────────────────────────────────────────
// KILL (QUERY|MUTATION) [ON CLUSTER cluster] WHERE expr [SYNC|ASYNC|TEST]
KillStatement
  = "KILL"i ![a-zA-Z0-9_]
    _ target:( "QUERY"i { return 'QUERY'; } / "MUTATION"i { return 'MUTATION'; } ) ![a-zA-Z0-9_]
    cluster:( _ OnClusterClause )?
    _ "WHERE"i ![a-zA-Z0-9_] _ where:Expression
    mode:( _ ( "SYNC"i / "ASYNC"i / "TEST"i ) ![a-zA-Z0-9_] )?
    settings:( _ SettingsClause )?
    format:( _ FormatClause )?
    &StatementEnd {
      const node = { type: 'KillQueryQuery', kill_type: target, where };
      if (settings !== null && settings[1].length > 0) node.settings = setNode(settings[1]);
      if (format !== null) {
        node.format = format[1];
      }
      if (cluster !== null) node.cluster = cluster[1];
      if (mode !== null) {
        // SYNC → sync; TEST → test; ASYNC is the default (no flag).
        const m = mode[1].toUpperCase();
        if (m === 'SYNC') node.sync = true;
        else if (m === 'TEST') node.test = true;
      }
      return loc(node);
    }

// ── EXISTS TABLE / VIEW / DATABASE / DICTIONARY ──────────────────────────────
ExistsStatement
  = "EXISTS"i ![a-zA-Z0-9_] _ "DATABASE"i ![a-zA-Z0-9_]
    _ database:( QueryParamIdentifier / AliasName )
    settings:( _ SettingsClause )? {
      const node = { type: 'ExistsDatabaseQuery', database: loc(ident([database])) };
      if (settings !== null && settings[1].length > 0) node.settings = setNode(settings[1]);
      return loc(node);
    }
  / "EXISTS"i ![a-zA-Z0-9_]
    temp:( _ "TEMPORARY"i ![a-zA-Z0-9_] )?
    targetType:ExistsTableKeyword?
    _ table:TableRef
    settings:( _ SettingsClause )?
    &StatementEnd {
      const LABELS = { TABLE: 'ExistsTableQuery', VIEW: 'ExistsViewQuery', DICTIONARY: 'ExistsDictionaryQuery' };
      const eff = targetType !== null ? targetType : 'TABLE';
      // The node `type` already encodes view/dictionary; no redundant
      // `is_view`/`is_dictionary` flag in the native AST.
      const node = { type: LABELS[eff] };
      if (temp !== null) node.temporary = true;
      setTableTarget(node, table);
      if (settings !== null && settings[1].length > 0) node.settings = setNode(settings[1]);
      return loc(node);
    }

ExistsTableKeyword
  = _ "TABLE"i ![a-zA-Z0-9_] { return 'TABLE'; }
  / _ "VIEW"i ![a-zA-Z0-9_] { return 'VIEW'; }
  / _ "DICTIONARY"i ![a-zA-Z0-9_] { return 'DICTIONARY'; }

// Unified entry point for all CREATE/REPLACE statements
CreateStatement
  = CreateFunctionStatement
  / CreateViewStatement
  / CreateMaterializedViewStatement
  / CreateDatabaseStatement
  / CreateIndexStatement
  / CreateDictionaryStatement
  / CreateWorkloadStatement
  / CreateUserStatement
  / CreateRoleStatement
  / CreateRowPolicyStatement
  / CreateQuotaStatement
  / CreateSettingsProfileStatement
  / CreateNamedCollectionStatement
  / CreateResourceStatement
  / CreateWindowViewStatement
  / CreateLiveViewStatement
  / CreateTableStatement

// CreateFunctionStatement: CREATE [OR REPLACE] FUNCTION [IF NOT EXISTS] name [ON CLUSTER cluster] AS lambda
CreateFunctionStatement
  = "CREATE"i ![a-zA-Z0-9_] _ orReplace:( "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] _ )? "FUNCTION"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:( x:AliasName { return { value: x, location: location() }; } ) cluster:( _ OnClusterClause )? _ KW_AS _ expr:Expression {
      const stmt = { kind: 'createFunction', name: name.value, location: name.location, functionExpr: expr };
      if (orReplace !== null) stmt.orReplace = true;
      if (ifne !== null) stmt.ifNotExists = true;
      if (cluster !== null) stmt.onCluster = cluster[1];
      return loc(createFunctionNode(stmt));
    }

// CreateViewStatement: CREATE [OR REPLACE] [TEMPORARY] VIEW [IF NOT EXISTS] [db.]name [(columns)] [ON CLUSTER ...] AS query
CreateViewStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    temp:( _ "TEMPORARY"i ![a-zA-Z0-9_] )?
    _ "VIEW"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ table:TableRef
    cluster:( _ OnClusterClause )?
    schema:( _ CreateTableSchema )?
    _ KW_AS _ query:UnionQuery {
      const result = { kind: 'createView', table };
      if (orReplace !== null) result.orReplace = true;
      if (temp !== null) result.temporary = true;
      if (ifne !== null) result.ifNotExists = true;
      if (cluster !== null) result.onCluster = cluster[1];
      if (schema !== null) Object.assign(result, schema[1]);
      result.asQuery = query;
      return loc(createViewNode(result));
    }

// CreateMaterializedViewStatement: CREATE MATERIALIZED VIEW [IF NOT EXISTS] [db.]name [REFRESH ...] [TO [db.]table] [ENGINE ...] [POPULATE] AS query
// Also matches ATTACH MATERIALIZED VIEW ... (with attach: true).
CreateMaterializedViewStatement
  = leadKw:( "CREATE"i / "ATTACH"i ) ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ "MATERIALIZED"i ![a-zA-Z0-9_] _ "VIEW"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ table:TableRef
    uuid:( _ "UUID"i ![a-zA-Z0-9_] _ StringLiteral )?
    cluster:( _ OnClusterClause )?
    refresh:( _ RefreshClause )?
    toInnerUuid:( _ "TO"i ![a-zA-Z0-9_] _ "INNER"i ![a-zA-Z0-9_] _ "UUID"i ![a-zA-Z0-9_] _ StringLiteral )?
    toTable:( _ "TO"i ![a-zA-Z0-9_] _ TableRef )?
    schema:( _ CreateTableSchema )?
    engine:( _ EngineClause )?
    clauses:CreateTableClauses
    populate:( _ "POPULATE"i ![a-zA-Z0-9_] )?
    empty:( _ "EMPTY"i ![a-zA-Z0-9_] )?
    _ KW_AS _ query:UnionQuery
    format:( _ FormatClause )? {
      const result = { kind: 'createMaterializedView', table };
      if (leadKw.toUpperCase() === 'ATTACH') result.attach = true;
      if (orReplace !== null) result.orReplace = true;
      if (ifne !== null) result.ifNotExists = true;
      if (uuid !== null) result.uuid = uuid[4].value;
      if (cluster !== null) result.onCluster = cluster[1];
      if (refresh !== null) result.refresh = refresh[1];
      if (toTable !== null) result.toTable = toTable[4];
      if (schema !== null) Object.assign(result, schema[1]);
      if (engine !== null) result.engine = engine[1];
      Object.assign(result, clauses);
      if (populate !== null) result.populate = true;
      if (empty !== null) result.empty = true;
      result.asQuery = query;
      if (format !== null) result.format = format[1];
      return loc(createMaterializedViewNode(result));
    }

// CreateDatabaseStatement: CREATE DATABASE [IF NOT EXISTS] name [ON CLUSTER ...] [ENGINE ...] [COMMENT ...]
// Also accepts ORDER BY / SETTINGS (which ClickHouse may reject but should parse)
CreateDatabaseStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ "DATABASE"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:( x:( QueryParamIdentifier / AliasName ) { return { value: x, location: location() }; } )
    cluster:( _ OnClusterClause )?
    engine:( _ EngineClause )?
    clauses:CreateTableClauses
    comment:( _ CreateCommentClause )?
    format:( _ FormatClause )? {
      const result = { kind: 'createDatabase', name: name.value, location: name.location };
      if (orReplace !== null) result.orReplace = true;
      if (ifne !== null) result.ifNotExists = true;
      if (cluster !== null) result.onCluster = cluster[1];
      if (engine !== null) result.engine = engine[1];
      if (comment !== null) result.comment = comment[1];
      if (clauses.orderBy) result.orderBy = clauses.orderBy;
      if (clauses.settings) result.settings = clauses.settings;
      if (format !== null) result.format = format[1];
      return loc(createDatabaseNode(result));
    }

// CreateIndexStatement: CREATE [UNIQUE] INDEX name ON [db.]table (expr) [TYPE type] [GRANULARITY n]
CreateIndexStatement
  = "CREATE"i ![a-zA-Z0-9_] unique:( _ "UNIQUE"i ![a-zA-Z0-9_] )?
    _ "INDEX"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName _ "ON"i ![a-zA-Z0-9_] _ table:TableRef
    _ indexExpr:CreateIndexExprs
    indexType:( _ "TYPE"i ![a-zA-Z0-9_] _ IndexTypeSpec )?
    gran:( _ "GRANULARITY"i ![a-zA-Z0-9_] _ n:$[0-9]+ { return parseInt(n, 10); } )? {
      const result = { kind: 'createIndex', table, indexName: name, indexExpr: indexExpr };
      if (indexType !== null) result.indexType = indexType[4];
      if (gran !== null) result.granularity = gran;
      if (ifne !== null) result.ifNotExists = true;
      if (unique !== null) result.unique = true;
      return loc(createIndexNode(result));
    }

CreateIndexExprs
  = "(" _ head:IndexColumnExpr tail:(_ "," _ IndexColumnExpr)* _ ")" {
      const exprs = [head, ...tail.map(t => t[3])];
      return exprs.length > 1 ? loc(fn('tuple', exprs)) : exprs[0];
    }
  / expr:TernaryExpr { return expr; }

// CreateDictionaryStatement: CREATE [OR REPLACE] DICTIONARY [IF NOT EXISTS] [db.]name (attrs) PRIMARY KEY ... SOURCE(...) LIFETIME(...) LAYOUT(...)
// Also matches REPLACE DICTIONARY (sets replace: true).
CreateDictionaryStatement
  = "REPLACE"i ![a-zA-Z0-9_] _ "DICTIONARY"i ![a-zA-Z0-9_]
    _ table:TableRef
    cluster:( _ OnClusterClause )?
    _ "(" _ attrs:DictAttrList _ ")"
    _ dictDef:DictDefinition {
      const result = { kind: 'createDictionary', table, replace: true };
      if (cluster !== null) result.onCluster = cluster[1];
      result.dictAttrs = attrs;
      result.dictDef = dictDef;
      return loc(createDictionaryNode(result));
    }
  / "CREATE"i ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ "DICTIONARY"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ table:TableRef
    cluster:( _ OnClusterClause )?
    _ "(" _ attrs:DictAttrList _ ")"
    _ dictDef:DictDefinition {
      const result = { kind: 'createDictionary', table };
      if (orReplace !== null) result.orReplace = true;
      if (ifne !== null) result.ifNotExists = true;
      if (cluster !== null) result.onCluster = cluster[1];
      result.dictAttrs = attrs;
      result.dictDef = dictDef;
      return loc(createDictionaryNode(result));
    }

DictAttrList
  = head:DictAttr tail:(_ "," _ DictAttr)* (_ ",")? { return [head, ...tail.map(t => t[3])]; }

DictAttr
  = name:AliasName _ type:ColumnDataType
    def:( _ "DEFAULT"i ![a-zA-Z0-9_] _ TernaryExpr )?
    expr:( _ "EXPRESSION"i ![a-zA-Z0-9_] _ TernaryExpr )?
    injective:( _ "INJECTIVE"i ![a-zA-Z0-9_] )?
    isObjMap:( _ "IS_OBJECT_ID"i ![a-zA-Z0-9_] )?
    hierarch:( _ "HIERARCHICAL"i ![a-zA-Z0-9_] )?
    bidirect:( _ "BIDIRECTIONAL"i ![a-zA-Z0-9_] )? {
      const result = { name, type };
      if (def !== null) result.defaultValue = def[4];
      if (expr !== null) result.expression = expr[4];
      if (injective !== null) result.injective = true;
      if (isObjMap !== null) result.isObjectId = true;
      if (hierarch !== null) result.hierarchical = true;
      if (bidirect !== null) result.bidirectional = true;
      return result;
    }

DictDefinition
  = clauses:( _ DictClause )+ {
      const result = {};
      for (const c of clauses) {
        const clause = c[1];
        if (clause.primaryKey) result.primaryKey = clause.primaryKey;
        else if (clause.source) result.source = clause.source;
        else if (clause.lifetime) result.lifetime = clause.lifetime;
        else if (clause.layout) result.layout = clause.layout;
        else if (clause.range) result.range = clause.range;
        else if (clause.settings) result.settings = clause.settings;
        else if (clause.comment !== undefined) result.comment = clause.comment;
      }
      return result;
    }

DictClause
  = "PRIMARY"i ![a-zA-Z0-9_] _ "KEY"i ![a-zA-Z0-9_] _ head:Expression tail:(_ "," _ Expression)* {
      return { primaryKey: [head, ...tail.map(t => t[3])] };
    }
  / "SOURCE"i ![a-zA-Z0-9_] _ "(" _ name:AliasName _ "(" _ pairs:DictKeyValueList? _ ")" _ ")" {
      return { source: { name: name.toLowerCase(), pairs: pairs || [] } };
    }
  / "LIFETIME"i ![a-zA-Z0-9_] _ "(" _ items:DictLifetimeItems _ ")" {
      return { lifetime: items };
    }
  / "LIFETIME"i ![a-zA-Z0-9_] _ "(" _ val:$[0-9]+ _ ")" {
      return { lifetime: { value: parseInt(val, 10) } };
    }
  / "LAYOUT"i ![a-zA-Z0-9_] _ "(" _ name:AliasName args:( _ "(" _ DictKeyValueList? _ ")" )? _ ")" {
      return { layout: { name: name.toUpperCase(), pairs: args !== null ? (args[3] || []) : [] } };
    }
  / "RANGE"i ![a-zA-Z0-9_] _ "(" _ items:DictKeyValueList _ ")" {
      return { range: items };
    }
  / KW_SETTINGS _ items:SettingsList {
      return { settings: items };
    }
  / "SETTINGS"i ![a-zA-Z0-9_] _ "(" _ items:SettingsList? _ ")" {
      return { settings: items || [] };
    }
  / "COMMENT"i ![a-zA-Z0-9_] _ str:StringLiteral {
      return { comment: str.value };
    }

DictLifetimeItems
  = head:DictLifetimeItem tail:( _ DictLifetimeItem )* {
      const result = {};
      const items = [head, ...tail.map(t => t[1])];
      for (const item of items) Object.assign(result, item);
      return result;
    }

DictLifetimeItem
  = "MIN"i ![a-zA-Z0-9_] _ val:$[0-9]+ { return { min: parseInt(val, 10) }; }
  / "MAX"i ![a-zA-Z0-9_] _ val:$[0-9]+ { return { max: parseInt(val, 10) }; }

DictKeyValueList
  = head:DictKeyValuePair tail:( _ DictKeyValuePair )* { return [head, ...tail.map(t => t[1])]; }

DictKeyValuePair
  = name:AliasName _ value:Expression { return { name, value }; }
  / name:AliasName _ "(" _ pairs:DictStructurePairList _ ")" { return { name, value: pairs }; }
  / name:AliasName _ value:ClickHouseTypeArgs { return { name, value: loc(strLit(value)) }; }

// Structure pairs inside dictionary SOURCE: "a String\n b Decimal(18,8)"
DictStructurePairList
  = head:DictStructurePair tail:( _ DictStructurePair )* { return [head, ...tail.map(t => t[1])]; }

DictStructurePair
  = name:AliasName _ type:ColumnDataType { return { name, type }; }

// Index column expression: expression with optional ASC/DESC (DESC is ignored in explain output)
IndexColumnExpr
  = expr:Expression dir:( _ ("ASC"i / "DESC"i) ![a-zA-Z0-9_] )? { return expr; }

// CreateWorkloadStatement: CREATE [OR REPLACE] WORKLOAD name [IN parent] [SETTINGS ...]
CreateWorkloadStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ "WORKLOAD"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    parent:( _ "IN"i ![a-zA-Z0-9_] _ AliasName )?
    settings:( _ SettingsClause )? {
      const result = { kind: 'createWorkload', name };
      if (orReplace !== null) result.orReplace = true;
      if (ifne !== null) result.ifNotExists = true;
      if (parent !== null) result.parentWorkload = parent[4];
      if (settings !== null) result.settings = settings[1];
      return loc(accessQueryNode(result, location()));
    }

// Individual CREATE statement rules for access control and other object types.

// ── CREATE USER ──────────────────────────────────────────────────────────────
CreateUserStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplacePre:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ "USER"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    orReplacePost:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ names:CreateUserNameList
    clauses:( _ CreateUserClause )*
    {
      const result = { kind: 'createUser', names };
      if (orReplacePre !== null || orReplacePost !== null) result.orReplace = true;
      if (ifne !== null) result.ifNotExists = true;
      for (const c of clauses) {
        const clause = c[1];
        if (clause.auth !== undefined) result.auth = clause.auth;
        if (clause.host !== undefined) result.host = clause.host;
        if (clause.settings !== undefined) result.settings = clause.settings;
        if (clause.defaultRole !== undefined) result.defaultRole = clause.defaultRole;
        if (clause.defaultDatabase !== undefined) result.defaultDatabase = clause.defaultDatabase;
        if (clause.grantees !== undefined) result.grantees = clause.grantees;
        if (clause.validUntil !== undefined) result.validUntil = clause.validUntil;
        if (clause.onCluster !== undefined) result.onCluster = clause.onCluster;
      }
      return loc(accessQueryNode(result, location()));
    }

CreateUserClause
  = CreateUserIdentifiedClause
  / CreateUserHostClause
  / CreateUserSettingsClause
  / CreateUserDefaultRoleClause
  / CreateUserDefaultDatabaseClause
  / CreateUserGranteesClause
  / CreateUserValidUntilClause
  / CreateUserOnClusterClause

CreateUserIdentifiedClause
  = "NOT"i ![a-zA-Z0-9_] _ "IDENTIFIED"i ![a-zA-Z0-9_] { return { auth: [{}] }; }
  / "IDENTIFIED"i ![a-zA-Z0-9_] _ auth:CreateUserAuthMethods { return { auth }; }

CreateUserHostClause
  = "HOST"i ![a-zA-Z0-9_] _ items:HostItemList { return { host: items }; }

CreateUserSettingsClause
  = "SETTINGS"i ![a-zA-Z0-9_] _ "NONE"i ![a-zA-Z0-9_] { return { settings: 'NONE' }; }
  / "SETTINGS"i ![a-zA-Z0-9_] _ items:AccessControlSettingsList { return { settings: items }; }

CreateUserDefaultRoleClause
  = "DEFAULT"i ![a-zA-Z0-9_] _ "ROLE"i ![a-zA-Z0-9_] _ roles:SetRoleList { return { defaultRole: roles }; }

CreateUserDefaultDatabaseClause
  = "DEFAULT"i ![a-zA-Z0-9_] _ "DATABASE"i ![a-zA-Z0-9_] _ db:AliasName { return { defaultDatabase: db }; }

CreateUserGranteesClause
  = "GRANTEES"i ![a-zA-Z0-9_] _ target:SetRoleList { return { grantees: target }; }

CreateUserValidUntilClause
  = "VALID"i ![a-zA-Z0-9_] _ "UNTIL"i ![a-zA-Z0-9_] _ str:StringLiteral { return { validUntil: str.value }; }

CreateUserOnClusterClause
  = "ON"i ![a-zA-Z0-9_] _ "CLUSTER"i ![a-zA-Z0-9_] _ name:( StringLiteral { return text(); } / AliasName ) { return { onCluster: name }; }

CreateUserNameList
  = head:CreateUserNameItem tail:( _ "," _ CreateUserNameItem )* { return [head, ...tail.map(t => t[3])]; }

CreateUserNameItem
  = name:CreateUserNameValue host:( "@" host:( "'" chars:$[^']* "'" { return "'" + chars + "'"; } / $[a-zA-Z0-9_.%:]+ ) { return host; } )? {
      const result = { name };
      if (host !== null) result.host = host;
      return result;
    }

CreateUserNameValue
  = "{" body:$[^}]* "}" { return '{' + body + '}'; }
  / "'" chars:SingleQuotedUserChar* "'" { return "'" + chars.join("") + "'"; }
  / AliasName

SingleQuotedUserChar
  = "''" { return "'"; }
  / "\\'" { return "'"; }
  / "\\\\" { return "\\"; }
  / !"'" c:. { return c; }

CreateUserAuthMethods
  // SSH key auth: all KEY...TYPE... entries are one method
  = "WITH"i ![a-zA-Z0-9_] _ "ssh_key"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ keys:CreateUserSSHKeyList {
      return [{ sshKeys: keys }];
    }
  // Comma-separated auth methods
  / head:CreateUserAuthMethod tail:( _ "," _ CreateUserAuthMethod )* {
      return [head, ...tail.map(t => t[3])];
    }

CreateUserAuthMethod
  // WITH type_name BY/REALM/SERVER 'secret'
  = "WITH"i ![a-zA-Z0-9_] _ t:$([a-zA-Z_][a-zA-Z0-9_]*) _ secret:CreateUserAuthSecret { return { ...secret, authType: t.toLowerCase() }; }
  // WITH type_name (no secret, e.g. no_password)
  / "WITH"i ![a-zA-Z0-9_] _ t:$([a-zA-Z_][a-zA-Z0-9_]*) { return { authType: t.toLowerCase() }; }
  // type_name BY/REALM/SERVER 'secret' (after comma, no WITH keyword)
  / t:$([a-zA-Z_][a-zA-Z0-9_]*) _ secret:CreateUserAuthSecret { return { ...secret, authType: t.toLowerCase() }; }
  // bare BY 'secret' (implicit continuation of previous type)
  / secret:CreateUserAuthSecret { return secret; }

CreateUserAuthSecret
  = "BY"i ![a-zA-Z0-9_] _ str:CreateUserAuthSecretValue { return { secret: str }; }
  / "REALM"i ![a-zA-Z0-9_] _ str:CreateUserAuthSecretValue { return { secret: str }; }
  / "SERVER"i ![a-zA-Z0-9_] _ str:CreateUserAuthSecretValue { return { secret: str }; }

CreateUserAuthSecretValue
  = str:StringLiteral { return str.value; }
  / "{" body:$[^}]* "}" { return '{' + body + '}'; }

CreateUserSSHKeyList
  = head:CreateUserSSHKey tail:( _ "," _ CreateUserSSHKey )* { return [head, ...tail.map(t => t[3])]; }

CreateUserSSHKey
  = "KEY"i ![a-zA-Z0-9_] _ key:StringLiteral _ "TYPE"i ![a-zA-Z0-9_] _ type:StringLiteral {
      return { key: key.value, type: type.value };
    }

// ── HOST items ───────────────────────────────────────────────────────────────
HostItemList
  = head:HostItems tail:( _ "," _ HostItems )* {
      const result = [];
      for (const items of [head, ...tail.map(t => t[3])]) {
        if (Array.isArray(items)) result.push(...items);
        else result.push(items);
      }
      return result;
    }

HostItems
  = "ANY"i ![a-zA-Z0-9_] { return { kind: 'any' }; }
  / "NONE"i ![a-zA-Z0-9_] { return { kind: 'none' }; }
  / "LOCAL"i ![a-zA-Z0-9_] { return { kind: 'local' }; }
  / "NAME"i ![a-zA-Z0-9_] _ strs:HostStringList { return strs.map(s => ({ kind: 'name', value: s })); }
  / "REGEXP"i ![a-zA-Z0-9_] _ strs:HostStringList { return strs.map(s => ({ kind: 'regexp', value: s })); }
  / "LIKE"i ![a-zA-Z0-9_] _ strs:HostStringList { return strs.map(s => ({ kind: 'like', value: s })); }
  / "IP"i ![a-zA-Z0-9_] _ strs:HostStringList { return strs.map(s => ({ kind: 'ip', value: s })); }

HostStringList
  = head:StringLiteral tail:( _ "," _ StringLiteral )* { return [head.value, ...tail.map(t => t[3].value)]; }

// ── Access Control SETTINGS ──────────────────────────────────────────────────
AccessControlSettingsList
  = head:AccessControlSettingsItem tail:( _ "," _ AccessControlSettingsItem )* { return [head, ...tail.map(t => t[3])]; }

AccessControlSettingsItem
  = "PROFILE"i ![a-zA-Z0-9_] _ name:( StringLiteral { return text(); } / AliasName ) { return { kind: 'profile', name }; }
  / "INHERIT"i ![a-zA-Z0-9_] _ name:( StringLiteral { return text(); } / AliasName ) { return { kind: 'inherit', name }; }
  / name:AccessControlSettingName val:( _ "=" _ Expression )? min:( _ "MIN"i ![a-zA-Z0-9_] _ ( "=" _ )? Expression )? max:( _ "MAX"i ![a-zA-Z0-9_] _ ( "=" _ )? Expression )? mod:( _ ("CONST"i / "WRITABLE"i / "READONLY"i) ![a-zA-Z0-9_] )? {
      const result = { kind: 'setting', name };
      if (val !== null) result.value = val[3];
      if (min !== null) result.min = min[5];
      if (max !== null) result.max = max[5];
      if (mod !== null) result.modifier = mod[1].toUpperCase();
      return result;
    }

AccessControlSettingName
  = head:AliasName tail:( "." AliasName )* { return tail.length > 0 ? head + tail.map(t => '.' + t[1]).join('') : head; }

// ── CREATE ROLE ──────────────────────────────────────────────────────────────
CreateRoleStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ "ROLE"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ names:CreateUserNameList
    settings:( _ CreateRoleSettingsClause )?
    {
      const result = { kind: 'createRole', names };
      if (orReplace !== null) result.orReplace = true;
      if (ifne !== null) result.ifNotExists = true;
      if (settings !== null) result.settings = settings[1];
      return loc(accessQueryNode(result, location()));
    }

CreateRoleSettingsClause
  = "SETTINGS"i ![a-zA-Z0-9_] _ "NONE"i ![a-zA-Z0-9_] { return 'NONE'; }
  / "SETTINGS"i ![a-zA-Z0-9_] _ items:AccessControlSettingsList { return items; }

// ── CREATE ROW POLICY ────────────────────────────────────────────────────────
CreateRowPolicyStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplacePre:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ hasRow:( "ROW"i ![a-zA-Z0-9_] _ )? "POLICY"i ![a-zA-Z0-9_]
    orReplacePost:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ targetsResult:RowPolicyTargets
    clauses:( _ RowPolicyClause )*
    {
      const result = { kind: 'createRowPolicy', targets: targetsResult.targets };
      if (orReplacePre !== null || orReplacePost !== null) result.orReplace = true;
      if (hasRow !== null) result.hasRowKeyword = true;
      if (ifne !== null) result.ifNotExists = true;
      if (targetsResult.onCluster) result.onCluster = targetsResult.onCluster;
      for (const c of clauses) {
        const clause = c[1];
        if (clause.using !== undefined) result.using = clause.using;
        if (clause.restrictive !== undefined) result.restrictive = clause.restrictive;
        if (clause.to !== undefined) result.to = clause.to;
        if (clause.onCluster !== undefined) result.onCluster = clause.onCluster;
      }
      return loc(accessQueryNode(result, location()));
    }

RowPolicyTargets
  = head:RowPolicyTarget tail:( _ "," _ RowPolicyTarget )* {
      const result = { targets: [], onCluster: null };
      for (const target of [head, ...tail.map(t => t[3])]) {
        if (target.onCluster) result.onCluster = target.onCluster;
        for (const table of target.tables) {
          result.targets.push({ names: target.names, table });
        }
      }
      return result;
    }

RowPolicyTarget
  = names:RowPolicyNameList cluster:( _ OnClusterClause )? _ "ON"i ![a-zA-Z0-9_] _ tables:RowPolicyTableList {
      const result = { names, tables };
      if (cluster !== null) result.onCluster = cluster[1];
      return result;
    }

RowPolicyTableList
  = head:RowPolicyTableRef tail:( _ "," _ !RowPolicyTargetLookahead RowPolicyTableRef )* { return [head, ...tail.map(t => t[4])]; }

RowPolicyTableRef
  = db:( QueryParamIdentifier / AliasName ) _ "." _ table:( "*" { return '*'; } / QueryParamIdentifier / AliasName ) {
      return loc({ kind: 'tableRef', database: db, table: table });
    }
  / table:( QueryParamIdentifier / AliasName ) {
      return loc({ kind: 'tableRef', table: table });
    }

RowPolicyTargetLookahead
  = AliasName _ "ON"i ![a-zA-Z0-9_]

RowPolicyNameList
  = head:AliasName tail:( _ "," _ AliasName !( _ "." ) )* { return [head, ...tail.map(t => t[3])]; }

RowPolicyClause
  = "FOR"i ![a-zA-Z0-9_] _ "SELECT"i ![a-zA-Z0-9_] { return {}; }
  / "USING"i ![a-zA-Z0-9_] _ expr:Expression { return rowPolicyUsingClause(expr); }
   / "AS"i ![a-zA-Z0-9_] _ mode:("RESTRICTIVE"i / "PERMISSIVE"i) ![a-zA-Z0-9_] { return { restrictive: mode.toUpperCase() }; }
  / "TO"i ![a-zA-Z0-9_] _ target:SetRoleList { return { to: target }; }
  / "ON"i ![a-zA-Z0-9_] _ "CLUSTER"i ![a-zA-Z0-9_] _ name:( StringLiteral { return text(); } / AliasName ) { return { onCluster: name }; }

// ── CREATE QUOTA ─────────────────────────────────────────────────────────────
CreateQuotaStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ "QUOTA"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ names:QuotaNameList
    clauses:( _ ","? _ QuotaClause )*
    {
      const result = { kind: 'createQuota', names };
      if (orReplace !== null) result.orReplace = true;
      if (ifne !== null) result.ifNotExists = true;
      const intervals = [];
      for (const c of clauses) {
        const clause = c[3];
        if (clause.keyed !== undefined) result.keyed = clause.keyed;
        if (clause.interval !== undefined) intervals.push(clause.interval);
        if (clause.to !== undefined) result.to = clause.to;
      }
      if (intervals.length > 0) result.intervals = intervals;
      return loc(accessQueryNode(result, location()));
    }

QuotaNameList
  = head:AccessControlNameValue tail:( _ "," _ AccessControlNameValue )* { return [head, ...tail.map(t => t[3])]; }

AccessControlNameValue
  = "'" chars:SingleQuotedUserChar* "'" { return "'" + chars.join("") + "'"; }
  / AliasName

QuotaClause
  = QuotaKeyedClause
  / QuotaIntervalClause
  / "TO"i ![a-zA-Z0-9_] _ target:SetRoleList { return { to: target }; }

QuotaKeyedClause
  = "NOT"i ![a-zA-Z0-9_] _ "KEYED"i ![a-zA-Z0-9_] { return { keyed: { notKeyed: true } }; }
  / ("KEYED"i / "KEY"i) ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ keys:QuotaKeyList { return { keyed: { keys } }; }

QuotaKeyList
  = head:QuotaKeyName tail:( _ "," _ QuotaKeyName )* { return [head, ...tail.map(t => t[3])]; }

QuotaKeyName
  = StringLiteral { return text(); }
  / AliasName

QuotaIntervalClause
  = "FOR"i ![a-zA-Z0-9_] _ randomized:( "RANDOMIZED"i ![a-zA-Z0-9_] _ )? ( "INTERVAL"i ![a-zA-Z0-9_] _ )? duration:QuotaDuration _ unit:QuotaTimeUnit body:( _ QuotaIntervalBody )? {
      const result = { duration, unit: unit.toUpperCase() };
      if (randomized !== null) result.randomized = true;
      if (body !== null) {
        const b = body[1];
        if (b.trackingOnly) result.trackingOnly = true;
        if (b.noLimits) result.noLimits = true;
        if (b.limits) result.limits = b.limits;
      }
      return { interval: result };
    }

QuotaDuration
  = $( [0-9]+ ( "." [0-9]+ )? )

QuotaTimeUnit
  = ("SECOND"i / "MINUTE"i / "HOUR"i / "DAY"i / "WEEK"i / "MONTH"i / "QUARTER"i / "YEAR"i) ("S"i)? ![a-zA-Z0-9_] { return text().replace(/s$/i, ''); }

QuotaIntervalBody
  = "TRACKING"i ![a-zA-Z0-9_] _ "ONLY"i ![a-zA-Z0-9_] { return { trackingOnly: true }; }
  / "NO"i ![a-zA-Z0-9_] _ "LIMITS"i ![a-zA-Z0-9_] { return { noLimits: true }; }
  / limits:QuotaLimitList { return { limits }; }

QuotaLimitList
  = head:QuotaLimitItem tail:( _ "," _ !QuotaLimitListEnd QuotaLimitItem )* { return [head, ...tail.map(t => t[4])]; }

QuotaLimitListEnd
  = "FOR"i ![a-zA-Z0-9_]
  / "TO"i ![a-zA-Z0-9_]
  / "KEYED"i ![a-zA-Z0-9_]
  / "KEY"i ![a-zA-Z0-9_]
  / "NOT"i ![a-zA-Z0-9_] _ "KEYED"i ![a-zA-Z0-9_]

QuotaLimitItem
  // MAX name = value / MAX name value / name MAX value / name = value / name value
  = "MAX"i ![a-zA-Z0-9_] _ name:QuotaLimitName _ ( "=" _ )? value:Expression { return { name: name.toUpperCase(), value }; }
  / name:QuotaLimitName _ "MAX"i ![a-zA-Z0-9_] _ value:Expression { return { name: name.toUpperCase(), value }; }
  / name:QuotaLimitName _ "=" _ value:Expression { return { name: name.toUpperCase(), value }; }
  / name:QuotaLimitName _ value:Expression { return { name: name.toUpperCase(), value }; }

QuotaLimitName
  = ("RESULT"i / "READ"i / "EXECUTION"i) " " ("ROWS"i / "BYTES"i / "TIME"i) { return text().toUpperCase().replace(/ /g, '_'); }
  / $( [a-zA-Z_]+ ( "_" [a-zA-Z_]+ )* )

// ── CREATE SETTINGS PROFILE ──────────────────────────────────────────────────
CreateSettingsProfileStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplacePre:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ hasSK:( "SETTINGS"i ![a-zA-Z0-9_] _ )? "PROFILE"i ![a-zA-Z0-9_]
    orReplacePost:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ names:QuotaNameList
    settings:( _ CreateRoleSettingsClause )?
    to:( _ "TO"i ![a-zA-Z0-9_] _ SetRoleList )?
    {
      const result = { kind: 'createSettingsProfile', names };
      if (orReplacePre !== null || orReplacePost !== null) result.orReplace = true;
      if (hasSK !== null) result.hasSettingsKeyword = true;
      if (ifne !== null) result.ifNotExists = true;
      if (settings !== null) result.settings = settings[1];
      if (to !== null) result.to = to[4];
      return loc(accessQueryNode(result, location()));
    }

// ── CREATE NAMED COLLECTION ──────────────────────────────────────────────────
CreateNamedCollectionStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ "NAMED"i ![a-zA-Z0-9_] _ "COLLECTION"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    cluster:( _ OnClusterClause )?
    _ "AS"i ![a-zA-Z0-9_] _ items:NamedCollectionItemList
    {
      const result = { kind: 'createNamedCollection', name, items };
      if (orReplace !== null) result.orReplace = true;
      if (ifne !== null) result.ifNotExists = true;
      if (cluster !== null) result.onCluster = cluster[1];
      return loc(accessQueryNode(result, location()));
    }

NamedCollectionItemList
  = head:NamedCollectionItem tail:( _ "," _ NamedCollectionItem )* { return [head, ...tail.map(t => t[3])]; }

NamedCollectionItem
  = key:AliasName _ "=" _ value:Expression
    ovr:( _ not:( "NOT"i ![a-zA-Z0-9_] _ )? "OVERRIDABLE"i ![a-zA-Z0-9_] )? {
      const item = { key, value };
      if (ovr !== null) item.overridable = ovr[1] === null;
      return item;
    }

// ── CREATE RESOURCE ──────────────────────────────────────────────────────────
CreateResourceStatement
  = "CREATE"i ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    _ "RESOURCE"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ name:AliasName
    _ "(" _ specs:ResourceSpecList _ ")"
    {
      const result = { kind: 'createResource', name, specs };
      if (orReplace !== null) result.orReplace = true;
      if (ifne !== null) result.ifNotExists = true;
      return loc(accessQueryNode(result, location()));
    }

ResourceSpecList
  = head:ResourceSpec tail:( _ "," _ ResourceSpec )* { return [head, ...tail.map(t => t[3])]; }

// A single resource operation: `READ`/`WRITE` against either a named `DISK`
// or `ANY DISK` (the latter carries no disk name, matching ClickHouse, whose
// native AST records `{ mode, disk? }` with `disk` omitted for `ANY DISK`).
ResourceSpec
  = operation:$("READ"i / "WRITE"i) ![a-zA-Z0-9_] _
    disk:( "ANY"i ![a-zA-Z0-9_] _ "DISK"i ![a-zA-Z0-9_] { return undefined; }
         / "DISK"i ![a-zA-Z0-9_] _ name:AliasName { return name; } ) {
      const spec = { mode: operation.toUpperCase() };
      if (disk !== undefined && disk !== null) spec.disk = disk;
      return spec;
    }

// ── CREATE WINDOW VIEW (raw body) ───────────────────────────────────────────
CreateWindowViewStatement
  = "CREATE"i ![a-zA-Z0-9_] _ ( "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] _ )? "WINDOW"i ![a-zA-Z0-9_] _ "VIEW"i ![a-zA-Z0-9_] body:$( ![;] . )* {
      return loc({ kind: 'createWindowView', rawBody: body.trim() });
    }

// ── CREATE LIVE VIEW (raw body) ─────────────────────────────────────────────
CreateLiveViewStatement
  = "CREATE"i ![a-zA-Z0-9_] _ ( "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] _ )? "LIVE"i ![a-zA-Z0-9_] _ "VIEW"i ![a-zA-Z0-9_] body:$( ![;] . )* {
      return loc({ kind: 'createLiveView', rawBody: body.trim() });
    }

// CreateTableStatement: handles all CREATE TABLE and REPLACE TABLE forms
// (and ATTACH TABLE forms via the ATTACH alternative in CreateTableHeader).
// The optional FROM 'path' clause is only valid for ATTACH but accepted here.
CreateTableStatement
  = header:CreateTableHeader
    fromPath:( _ "FROM"i ![a-zA-Z0-9_] _ StringLiteral )?
    _ body:CreateTableBody format:( _ FormatClause )? {
      const result = { ...header, ...body };
      if (fromPath !== null) result.attachFromPath = fromPath[4].value;
      if (format !== null) result.format = format[1];
      // Promote column-level PRIMARY KEY to primaryKey if no explicit PRIMARY KEY clause
      if (result.columnPrimaryKeys && !result.primaryKey) {
        result.primaryKey = result.columnPrimaryKeys;
      }
      delete result.columnPrimaryKeys;
      return loc(createTableNode(result));
    }

// Header: CREATE [OR REPLACE] [TEMPORARY] TABLE [IF NOT EXISTS] [db.]table [ON CLUSTER ...]
// Also: REPLACE TABLE [db.]table [ON CLUSTER ...]
// Also: ATTACH TABLE [IF NOT EXISTS] [db.]table [ON CLUSTER ...] (with attach: true flag)
CreateTableHeader
  = "REPLACE"i ![a-zA-Z0-9_]
    temp:( _ "TEMPORARY"i ![a-zA-Z0-9_] )?
    _ "TABLE"i ![a-zA-Z0-9_] _ table:TableRef cluster:( _ OnClusterClause )? {
      const result = { kind: 'createTable', replace: true, table };
      if (temp !== null) result.temporary = true;
      if (cluster !== null) result.onCluster = cluster[1];
      return result;
    }
  / leadKw:( "CREATE"i / "ATTACH"i ) ![a-zA-Z0-9_] orReplace:( _ "OR"i ![a-zA-Z0-9_] _ "REPLACE"i ![a-zA-Z0-9_] )?
    temp:( _ "TEMPORARY"i ![a-zA-Z0-9_] )?
    _ "TABLE"i ![a-zA-Z0-9_]
    ifne:( _ "IF"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] )?
    _ table:TableRef
    cluster:( _ OnClusterClause )? {
      const result = { kind: 'createTable', table };
      if (leadKw.toUpperCase() === 'ATTACH') result.attach = true;
      if (orReplace !== null) result.orReplace = true;
      if (temp !== null) result.temporary = true;
      if (ifne !== null) result.ifNotExists = true;
      if (cluster !== null) result.onCluster = cluster[1];
      return result;
    }

OnClusterClause
  = "ON"i ![a-zA-Z0-9_] _ "CLUSTER"i ![a-zA-Z0-9_] _ name:( s:StringLiteral { return s.value; } / AliasName ) { return name; }

// RefreshClause: REFRESH EVERY|AFTER <interval> [OFFSET <interval>]
//   [RANDOMIZE FOR <interval>] [DEPENDS ON tbl, ...] [SETTINGS ...] [APPEND]
RefreshClause
  = "REFRESH"i ![a-zA-Z0-9_] _
    kind:( "EVERY"i { return 'EVERY'; } / "AFTER"i { return 'AFTER'; } ) ![a-zA-Z0-9_] _
    period:RefreshInterval
    offset:( _ "OFFSET"i ![a-zA-Z0-9_] _ iv:RefreshInterval { return iv; } )?
    spread:( _ "RANDOMIZE"i ![a-zA-Z0-9_] _ "FOR"i ![a-zA-Z0-9_] _ iv:RefreshInterval { return iv; } )?
    deps:( _ "DEPENDS"i ![a-zA-Z0-9_] _ "ON"i ![a-zA-Z0-9_] _ list:RefreshDependsList { return list; } )?
    settings:( _ s:SettingsClause { return s; } )?
    append:( _ "APPEND"i ![a-zA-Z0-9_] )? {
      const r = { schedule_kind: kind, period };
      if (offset !== null) r.offset = offset;
      if (spread !== null) r.spread = spread;
      if (deps !== null) r.dependencies = exprList(deps);
      if (settings !== null) r.settings = settings;
      if (append !== null) r.append = true;
      return r;
    }

// A single `<number> <unit>` interval → native TimeInterval.
RefreshInterval
  = value:$[0-9]+ _ unit:IntervalUnit {
      return loc({ type: 'TimeInterval', interval: [{ kind: unit, value }] });
    }

RefreshDependsList
  = head:TableRef tail:( _ "," _ TableRef )* {
      return [head, ...tail.map(t => t[3])].map(refreshDepIdent);
    }

// Body: the various syntax forms after the header
CreateTableBody
  // Form: CLONE AS [db.]table [ENGINE ...] [clauses]
  = "CLONE"i ![a-zA-Z0-9_] _ "AS"i ![a-zA-Z0-9_] _ asTable:TableRef engine:( _ EngineClause )? clauses:CreateTableClauses {
      const result = { clone: true, asTable };
      if (engine !== null) result.engine = engine[1];
      Object.assign(result, clauses);
      return result;
    }
  // UUID clause: `CREATE TABLE t UUID '...' (...)`
  / "UUID"i ![a-zA-Z0-9_] _ id:StringLiteral _ body:CreateTableBody { return { ...body, uuid: id.value }; }
  // Form: (columns) ENGINE ... [clauses] [AS SELECT ...]
  / schema:CreateTableSchema _ engine:EngineClause clauses:CreateTableClauses asQuery:( _ KW_AS _ UnionQuery )? {
      const result = { ...schema, engine };
      Object.assign(result, clauses);
      if (asQuery !== null) result.asQuery = asQuery[3];
      return result;
    }
  // Form: (columns) [clauses] AS table_function(...) — explicit columns with table function
  / schema:CreateTableSchema clauses:CreateTableClauses _ "AS"i ![a-zA-Z0-9_] _ name:AliasName _ "(" _ args:EngineArgList? _ ")" {
      const result = { ...schema, asTableFunction: { name, args: args || [] } };
      Object.assign(result, clauses);
      return result;
    }
  // Form: (columns) — no ENGINE (for TEMPORARY tables etc.)
  / schema:CreateTableSchema clauses:CreateTableClauses empty:( _ "EMPTY"i ![a-zA-Z0-9_] )? asQuery:( _ KW_AS _ &( KW_SELECT / KW_WITH / "(" ) UnionQuery )? {
      const result = { ...schema };
      Object.assign(result, clauses);
      if (empty !== null) result.empty = true;
      if (asQuery !== null) result.asQuery = asQuery[4];
      return result;
    }
  // Form: ENGINE ... [clauses] [EMPTY] AS SELECT ... (no explicit column schema)
  / engine:EngineClause clauses:CreateTableClauses empty:( _ "EMPTY"i ![a-zA-Z0-9_] )? _ KW_AS _ asQuery:UnionQuery {
      const result = { engine, asQuery };
      Object.assign(result, clauses);
      if (empty !== null) result.empty = true;
      return result;
    }
  // Form: ENGINE ... [clauses] AS table_name — schema from another table with explicit engine
  / engine:EngineClause clauses:CreateTableClauses _ "AS"i ![a-zA-Z0-9_] _ asTable:TableRef {
      const result = { engine, asTable };
      Object.assign(result, clauses);
      return result;
    }
  // Form: ENGINE ... [clauses] (no columns, no AS — empty table with engine)
  / engine:EngineClause clauses:CreateTableClauses {
      const result = { engine };
      Object.assign(result, clauses);
      return result;
    }
  // Form: [clauses] AS SELECT ... (no schema, no engine, e.g. default engine with ORDER BY)
  / &( "ORDER"i / "PARTITION"i / "PRIMARY"i / "SAMPLE"i / "TTL"i ) clauses:CreateTableClauses _ KW_AS _ asQuery:UnionQuery {
      const result = { asQuery };
      Object.assign(result, clauses);
      return result;
    }
  // Form: "EMPTY AS table_name" — ClickHouse extension (table ref, not SELECT)
  / "EMPTY"i ![a-zA-Z0-9_] _ "AS"i ![a-zA-Z0-9_] _ !( KW_SELECT / KW_WITH / "(" ) asTable:TableRef {
      return { empty: true, asTable };
    }
  // Form: "EMPTY AS SELECT ..." — ClickHouse extension
  / "EMPTY"i ![a-zA-Z0-9_] _ KW_AS _ asQuery:UnionQuery {
      return { empty: true, asQuery };
    }
  // Form: AS SELECT ... (no engine, for temporary tables)
  / KW_AS _ &( KW_SELECT / KW_WITH / "(" ) asQuery:UnionQuery {
      return { asQuery };
    }
  // Form: AS table_function(...) — must check before AS [db.]table
  / "AS"i ![a-zA-Z0-9_] _ name:AliasName _ "(" _ args:EngineArgList? _ ")" {
      const result = { asTableFunction: { name, args: args || [] } };
      return result;
    }
  // Form: AS [db.]table [ENGINE ...] [clauses] — schema from another table
  / "AS"i ![a-zA-Z0-9_] _ asTable:TableRef engine:( _ EngineClause )? clauses:CreateTableClauses {
      const result = { asTable };
      if (engine !== null) result.engine = engine[1];
      Object.assign(result, clauses);
      return result;
    }

// Schema: parenthesized column definitions
CreateTableSchema
  = "(" _ elements:TableElementList _ ")" {
      // Separate primary key from other elements
      const tableElements = [];
      let primaryKeyInSchema = null;
      const columnPrimaryKeys = [];
      for (const el of elements) {
        if (el.primaryKeyExprs) {
          primaryKeyInSchema = el.primaryKeyExprs;
        } else {
          tableElements.push(el);
          if (el.kind === 'columnDef' && el.primaryKey) {
            columnPrimaryKeys.push(withLoc(ident([el.name]), el.location));
          }
        }
      }
      const result = {};
      if (tableElements.length > 0) result.tableElements = tableElements;
      if (primaryKeyInSchema !== null) result.primaryKeyInSchema = primaryKeyInSchema;
      if (columnPrimaryKeys.length > 0) result.columnPrimaryKeys = columnPrimaryKeys;
      return result;
    }

TableElementList
  = head:TableElement tail:(_ "," _ TableElement)* trailing_comma:(_ ",")? {
      return [head, ...tail.map(t => t[3])];
    }

TableElement
  = ConstraintElement
  / ForeignKeyElement
  / ProjectionIndexElement
  / IndexElement
  / ProjectionElement
  / PrimaryKeyElement
  / ColumnElement

// PROJECTION with INDEX: e.g. "PROJECTION region_proj INDEX region TYPE basic"
ProjectionIndexElement
  = "PROJECTION"i ![a-zA-Z0-9_] _ name:AliasName _ "INDEX"i ![a-zA-Z0-9_] _ indexExpr:IndexExpr _ "TYPE"i ![a-zA-Z0-9_] _ indexType:IndexTypeSpec {
      return loc({ kind: 'projectionDef', name, indexExpr, indexType });
    }

ColumnElement
  = name:AliasName
    type:( _ !("DEFAULT"i ![a-zA-Z0-9_] / "MATERIALIZED"i ![a-zA-Z0-9_] / "EPHEMERAL"i ![a-zA-Z0-9_] / "ALIAS"i ![a-zA-Z0-9_] / "COMMENT"i ![a-zA-Z0-9_] / "CODEC"i ![a-zA-Z0-9_] / "TTL"i ![a-zA-Z0-9_] / "STATISTICS"i ![a-zA-Z0-9_] / "SETTINGS"i ![a-zA-Z0-9_] / "NULL"i ![a-zA-Z0-9_] / "NOT"i ![a-zA-Z0-9_] _ "NULL"i ![a-zA-Z0-9_] / "AUTO_INCREMENT"i ![a-zA-Z0-9_] / "COLLATE"i ![a-zA-Z0-9_] / "PRIMARY"i ![a-zA-Z0-9_] / "," / ")") ColumnDataType )?
    collate:( _ "COLLATE"i ![a-zA-Z0-9_] _ AliasName )?
    nullable1:( _ NullableModifier )?
    autoIncrement:( _ "AUTO_INCREMENT"i ![a-zA-Z0-9_] )?
    primaryKey:( _ "PRIMARY"i ![a-zA-Z0-9_] _ "KEY"i ![a-zA-Z0-9_] )?
    def:( _ ColumnDefault )?
    nullable2:( _ NullableModifier )?
    comment:( _ ColumnComment )?
    codec:( _ ColumnCodec )?
    stats:( _ ColumnStatistics )?
    ttl:( _ ColumnTTL )?
    colSettings:( _ ColumnSettings )? {
      const result = loc({ kind: 'columnDef', name });
      if (type !== null) result.type = type[2];
      else if (autoIncrement !== null) result.type = { name: 'INT', args: [], location: location() };
      if (autoIncrement !== null) result.autoIncrement = true;
      const nullable = nullable2 !== null ? nullable2[1] : (nullable1 !== null ? nullable1[1] : null);
      if (collate !== null) result.collate = collate[4];
      if (nullable !== null) result.nullable = nullable;
      if (primaryKey !== null) result.primaryKey = true;
      if (def !== null) { result.defaultKind = def[1].kind; if (def[1].expr) result.defaultExpr = def[1].expr; }
      if (comment !== null) result.comment = comment[1];
      if (codec !== null) result.codec = codec[1];
      if (stats !== null) result.statistics = stats[1];
      if (ttl !== null) result.ttl = ttl[1];
      if (colSettings !== null) result.columnSettings = colSettings[1];
      return result;
    }

NullableModifier
  = "NOT"i ![a-zA-Z0-9_] _ "NULL"i ![a-zA-Z0-9_] { return 'NOT NULL'; }
  / "NULL"i ![a-zA-Z0-9_] { return 'NULL'; }

ColumnDefault
  = "DEFAULT"i ![a-zA-Z0-9_] _ expr:TernaryExpr { return { kind: 'DEFAULT', expr }; }
  / "MATERIALIZED"i ![a-zA-Z0-9_] _ expr:TernaryExpr { return { kind: 'MATERIALIZED', expr }; }
  / "ALIAS"i ![a-zA-Z0-9_] _ expr:TernaryExpr { return { kind: 'ALIAS', expr }; }
  / "EPHEMERAL"i ![a-zA-Z0-9_] expr:( _ !("COMMENT"i ![a-zA-Z0-9_] / "CODEC"i ![a-zA-Z0-9_] / "TTL"i ![a-zA-Z0-9_] / "STATISTICS"i ![a-zA-Z0-9_] / "SETTINGS"i ![a-zA-Z0-9_] / "NULL"i ![a-zA-Z0-9_] / "NOT"i ![a-zA-Z0-9_] _ "NULL"i ![a-zA-Z0-9_] / "," / ")") TernaryExpr )? {
      const result = { kind: 'EPHEMERAL' };
      if (expr !== null) result.expr = expr[2];
      return result;
    }

ColumnComment
  = "COMMENT"i ![a-zA-Z0-9_] _ str:StringLiteral { return str.value; }

ColumnCodec
  = "CODEC"i ![a-zA-Z0-9_] _ "(" _ items:CodecItemList _ ")" { return items; }

CodecItemList
  = head:CodecItemEntry tail:( _ "," _ CodecItemEntry )* { return [head, ...tail.map(t => t[3])]; }

CodecItemEntry
  = name:$([a-zA-Z_][a-zA-Z0-9_-]*) args:( _ "(" _ ExpressionList? _ ")" )? {
      const result = { name };
      if (args !== null) result.args = args[3] || [];
      return result;
    }
  // Quoted codec name like 'AES-128-GCM-SIV'
  / "'" name:$[^']+ "'" args:( _ "(" _ ExpressionList? _ ")" )? {
      const result = { name };
      if (args !== null) result.args = args[3] || [];
      return result;
    }
  // Backtick-quoted codec name like `@`
  / "`" name:$[^`]+ "`" args:( _ "(" _ ExpressionList? _ ")" )? {
      const result = { name };
      if (args !== null) result.args = args[3] || [];
      return result;
    }

ColumnStatistics
  = "STATISTICS"i ![a-zA-Z0-9_] _ "(" _ items:CodecItemList _ ")" { return items; }

ColumnTTL
  = "TTL"i ![a-zA-Z0-9_] _ expr:Expression { return expr; }

ColumnSettings
  = "SETTINGS"i ![a-zA-Z0-9_] _ "(" _ head:ColumnSettingItem tail:( _ "," _ ColumnSettingItem )* _ ")" {
      return [head, ...tail.map(t => t[3])];
    }

ColumnSettingItem
  = name:$([a-zA-Z_][a-zA-Z0-9_]*) _ "=" _ val:TernaryExpr {
      return { name, value: val };
    }

ConstraintElement
  = "CONSTRAINT"i ![a-zA-Z0-9_] _ name:AliasName _ ct:("CHECK"i / "ASSUME"i) ![a-zA-Z0-9_] _ expr:Expression {
      return loc({ kind: 'constraintDef', name, constraintType: ct.toUpperCase(), expr });
    }

// FOREIGN KEY: parsed and ignored (ClickHouse accepts but ignores foreign keys)
ForeignKeyElement
  = "FOREIGN"i ![a-zA-Z0-9_] _ "KEY"i ![a-zA-Z0-9_] _ "(" _ cols:ExpressionList _ ")"
    _ "REFERENCES"i ![a-zA-Z0-9_] _ table:TableRef _ "(" _ refCols:ExpressionList _ ")"
    actions:( _ ForeignKeyAction )* {
      return loc({ kind: 'foreignKeyDef', columns: cols, refTable: table, refColumns: refCols });
    }

ForeignKeyAction
  = "ON"i ![a-zA-Z0-9_] _ ("DELETE"i / "UPDATE"i) ![a-zA-Z0-9_] _
    ("CASCADE"i / "RESTRICT"i / "SET"i ![a-zA-Z0-9_] _ "NULL"i / "NO"i ![a-zA-Z0-9_] _ "ACTION"i) ![a-zA-Z0-9_]

IndexElement
  = "INDEX"i ![a-zA-Z0-9_] _ name:AliasName _ expr:IndexExpr _ "TYPE"i ![a-zA-Z0-9_] _ indexType:IndexTypeSpec
    gran:( _ "GRANULARITY"i ![a-zA-Z0-9_] _ n:$[0-9]+ { return parseInt(n, 10); } )? {
      const result = loc({ kind: 'indexDef', name, expr, indexType });
      if (gran !== null) result.granularity = gran;
      return result;
    }

// Index expression: either a parenthesized expression or a regular expression
IndexExpr
  = "(" _ head:Expression tail:(_ "," _ Expression)* _ ")" {
      if (tail.length === 0) return head;
      return loc(fn('tuple', [head, ...tail.map(t => t[3])], { is_operator: true }));
    }
  / Expression

// Index type: name with optional args. Args can contain settings like tokenizer = ngrams(3)
IndexTypeSpec
  = name:$([a-zA-Z_][a-zA-Z0-9_]*) args:( _ "(" _ IndexTypeArgList? _ ")" )? {
      const result = { name, location: location() };
      if (args !== null) result.args = args[3] || [];
      return result;
    }

IndexTypeArgList
  = head:IndexTypeArgEntry tail:( _ "," _ IndexTypeArgEntry )* { return [head, ...tail.map(t => t[3])]; }

// Each index type arg is parsed as an Expression (handles tokenizer = ngrams(3) as equals expr)
IndexTypeArgEntry = Expression

ProjectionElement
  = "PROJECTION"i ![a-zA-Z0-9_] _ name:AliasName _ "(" _ query:SelectStatement _ ")"
    projSettings:( _ "WITH"i ![a-zA-Z0-9_] _ "SETTINGS"i ![a-zA-Z0-9_] _ "(" _ SettingsList _ ")" )? {
      const result = loc({ kind: 'projectionDef', name, query });
      if (projSettings !== null) result.projectionSettings = projSettings[9];
      return result;
    }

PrimaryKeyElement
  = "PRIMARY"i ![a-zA-Z0-9_] _ "KEY"i ![a-zA-Z0-9_] _ exprs:PrimaryKeyExprs {
      exprs.location = location();
      return { primaryKeyExprs: exprs };
    }

PrimaryKeyExprs
  = "(" _ ")" { return []; }
  / "(" _ head:Expression tail:(_ "," _ Expression)* _ ")" {
      return [head, ...tail.map(t => t[3])];
    }
  / expr:Expression { return [expr]; }

// Engine clause: ENGINE [=] name[(args)]
EngineClause
  = "ENGINE"i ![a-zA-Z0-9_] _ "="? _ name:AliasName args:( _ "(" _ EngineArgList? _ ")" )? {
      const result = { name, location: location() };
      if (args !== null) result.args = args[3] !== null ? args[3] : [];
      return result;
    }

EngineArgList
  = head:Expression tail:(_ "," _ Expression)* {
      return [head, ...tail.map(t => t[3])];
    }

// Clauses that follow the ENGINE clause in a CREATE TABLE statement
// Order is flexible — clauses can appear in any order
CreateTableClauses
  = clauses:( _ CreateTableClause )* {
      const result = {};
      let sawOrdering = false; // true after ORDER BY or PRIMARY KEY
      let sawComment = false;
      for (const c of clauses) {
        const clause = c[1];
        if (clause.orderBy) { result.orderBy = clause.orderBy; sawOrdering = true; }
        else if (clause.partitionBy) result.partitionBy = clause.partitionBy;
        else if (clause.primaryKey) { result.primaryKey = clause.primaryKey; if (sawOrdering) result.primaryKeyAfterOrderBy = true; sawOrdering = true; }
        else if (clause.sampleBy) result.sampleBy = clause.sampleBy;
        else if (clause.ttl) result.ttl = clause.ttl;
        else if (clause.settings) {
          if (result.settings || sawComment) { result.querySettings = clause.settings; }
          else { result.settings = clause.settings; if (sawOrdering) result.settingsAfterOrderBy = true; }
        }
        else if (clause.comment !== undefined) { result.comment = clause.comment; sawComment = true; }
      }
      return result;
    }

CreateTableClause
  = c:CreateOrderByClause { return { orderBy: c }; }
  / c:CreatePartitionByClause { return { partitionBy: c }; }
  / c:CreatePrimaryKeyClause { return { primaryKey: c }; }
  / c:CreateSampleByClause { return { sampleBy: c }; }
  / c:CreateTTLClause { return { ttl: c }; }
  / c:SettingsClause { return { settings: c }; }
  / c:CreateCommentClause { return { comment: c }; }

CreateOrderByClause
  = "ORDER"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ "(" _ head:CreateOrderByItem tail:(_ "," _ CreateOrderByItem)* _ ")" !( _ [*/%+\-] ) {
      const items = [head, ...tail.map(t => t[3])];
      items.parenthesized = true;
      return items;
    }
  / "ORDER"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ head:CreateOrderByItem tail:(_ "," _ CreateOrderByItem)* {
      return [head, ...tail.map(t => t[3])];
    }

CreateOrderByItem
  = expr:TernaryExpr dir:( _ ("ASC"i / "DESC"i) ![a-zA-Z0-9_] )? { return { expr, dir: dir ? dir[1].toUpperCase() : undefined }; }

CreatePartitionByClause
  = "PARTITION"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ "(" _ ")" {
      return loc(fn('tuple', [], { is_operator: true }));
    }
  / "PARTITION"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ expr:TernaryExpr { return expr; }

CreatePrimaryKeyClause
  = "PRIMARY"i ![a-zA-Z0-9_] _ "KEY"i ![a-zA-Z0-9_] _ "(" _ ")" {
      return [];
    }
  / "PRIMARY"i ![a-zA-Z0-9_] _ "KEY"i ![a-zA-Z0-9_] _ "(" _ head:Expression tail:(_ "," _ Expression)* _ ")" {
      return [head, ...tail.map(t => t[3])];
    }
  / "PRIMARY"i ![a-zA-Z0-9_] _ "KEY"i ![a-zA-Z0-9_] _ expr:TernaryExpr {
      return [expr];
    }

CreateSampleByClause
  = "SAMPLE"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ expr:TernaryExpr { return expr; }

CreateTTLClause
  = "TTL"i ![a-zA-Z0-9_] _ head:TTLItem tail:( _ "," _ TTLItem )* {
      return [head, ...tail.map(t => t[3])];
    }

TTLItem
  = expr:TernaryExpr suffix:( _ TTLSuffix )? {
      const item = { expr };
      if (suffix !== null) Object.assign(item, suffix[1]);
      return item;
    }

// TTL suffixes — capture the structured mode/destination/recompression info
// the native AST exposes on each TTLElement.
TTLSuffix
  = "DELETE"i ![a-zA-Z0-9_] w:( _ "WHERE"i ![a-zA-Z0-9_] _ TernaryExpr )? { return w !== null ? { mode: 'DELETE', where: w[4] } : { mode: 'DELETE' }; }
  / "TO"i ![a-zA-Z0-9_] _ dest:("DISK"i / "VOLUME"i) ![a-zA-Z0-9_] _ ifExists:( "IF"i ![a-zA-Z0-9_] _ "EXISTS"i ![a-zA-Z0-9_] _ )? name:StringLiteral {
      return { mode: 'MOVE', destinationType: dest.toUpperCase(), destinationName: name.value, ifExists: ifExists !== null };
    }
  / "RECOMPRESS"i ![a-zA-Z0-9_] _ codec:ColumnCodec { return { mode: 'RECOMPRESS', codec }; }
  / "WHERE"i ![a-zA-Z0-9_] _ w:TernaryExpr { return { mode: 'DELETE', where: w }; }
  / "GROUP"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ groupBy:TTLGroupByList set:( _ "SET"i ![a-zA-Z0-9_] _ TTLSetList )? { return { mode: 'GROUP_BY', groupBy, set: set !== null ? set[4] : undefined }; }

TTLGroupByList
  = head:TernaryExpr tail:( _ "," _ TernaryExpr )* { return [head, ...tail.map(t => t[3])]; }

TTLSetList
  = head:TTLSetItem tail:( _ "," _ TTLSetItem )* { return [head, ...tail.map(t => t[3])]; }

TTLSetItem
  = name:AddExpr _ "=" _ value:TernaryExpr { return { name, value }; }

CreateCommentClause
  = "COMMENT"i ![a-zA-Z0-9_] _ str:StringLiteral { return str.value; }

// ExplainStatement: EXPLAIN [AST|SYNTAX|QUERY TREE|PLAN|PIPELINE|ESTIMATE|TABLE OVERRIDE] [settings] [query] [FORMAT ...]
// Settings are key=value pairs without the SETTINGS keyword (e.g. EXPLAIN actions=1 SELECT ...).
// The inner query can be any explainable statement (SELECT, INSERT, CREATE, ALTER, SYSTEM, etc.).
ExplainStatement
  = "EXPLAIN"i ![a-zA-Z0-9_] _
    type:ExplainType? _
    settings:ExplainSettingsList? _
    query:ExplainInnerStatement?
    format:( _ FormatClause )?
    postSettings:( _ SettingsClause )? {
      // ClickHouse's native AST stores the full EXPLAIN phrase in `kind`
      // ("EXPLAIN", "EXPLAIN AST", "EXPLAIN PIPELINE", ...). `PLAN` collapses
      // to a bare "EXPLAIN" in `kind` matching ClickHouse; the formatter
      // canonicalizes `EXPLAIN PLAN` to bare `EXPLAIN` (semantically equal).
      const kindSuffix = type !== null ? type : null;
      const kindStr = kindSuffix !== null && kindSuffix !== 'PLAN'
        ? `EXPLAIN ${kindSuffix}` : 'EXPLAIN';
      const node = loc({ type: 'Explain', kind: kindStr });
      if (settings !== null && settings.length > 0) node.settings = setNode(settings);
      if (query !== null) node.query = query;
      if (format !== null) node.format = format[1];
      if (postSettings !== null && postSettings[1].length > 0) {
        node.output_settings = setNode(postSettings[1]);
      }
      return node;
    }

// ExplainInnerStatement: any statement that can appear as the body of an EXPLAIN.
// The order mirrors TopLevelStatement (non-SELECT statements first, then SELECT/UNION).
ExplainInnerStatement
  = CreateStatement
  / AlterStatement
  / SystemStatement
  / InsertStatement
  / DropStatement
  / UndropStatement
  / BackupStatement
  / TruncateStatement
  / OptimizeStatement
  / DescribeStatement
  / DeleteStatement
  / UpdateStatement
  / UnionQuery

// ExplainType: the keyword identifying the EXPLAIN output type
ExplainType
  = "QUERY"i ![a-zA-Z0-9_] _ "TREE"i ![a-zA-Z0-9_] { return 'QUERY TREE'; }
  / "TABLE"i ![a-zA-Z0-9_] _ "OVERRIDE"i ![a-zA-Z0-9_] { return 'TABLE OVERRIDE'; }
  / "CURRENT"i ![a-zA-Z0-9_] _ "TRANSACTION"i ![a-zA-Z0-9_] { return 'CURRENT TRANSACTION'; }
  / "AST"i ![a-zA-Z0-9_] { return 'AST'; }
  / "SYNTAX"i ![a-zA-Z0-9_] { return 'SYNTAX'; }
  / "PLAN"i ![a-zA-Z0-9_] { return 'PLAN'; }
  / "PIPELINE"i ![a-zA-Z0-9_] { return 'PIPELINE'; }
  / "ESTIMATE"i ![a-zA-Z0-9_] { return 'ESTIMATE'; }

// ExplainSettingsList: comma-separated key=value pairs immediately after EXPLAIN [type], without the SETTINGS keyword
ExplainSettingsList
  = head:ExplainSettingItem tail:(_ "," _ ExplainSettingItem)* {
      return [head, ...tail.map((t) => t[3])];
    }

// ExplainSettingItem: key = value pair (must be followed by '=' to avoid consuming SELECT as a setting name)
ExplainSettingItem
  = name:SettingName _ "=" _ value:UnaryExpr {
      return { name, value };
    }

// FORMAT clause - specifies the output format
FormatClause
  = KW_FORMAT _ name:FormatName { return name; }

// Format name: an identifier or backtick-quoted identifier (e.g. FORMAT `Null`)
FormatName
  = chars:$([a-zA-Z_][a-zA-Z0-9_]*) { return chars; }
  / '`' chars:BacktickChar* '`' { return chars.join(''); }

// UnionQuery: UNION and EXCEPT at lowest precedence (left-assoc), INTERSECT at higher precedence.
// ClickHouse precedence: INTERSECT > EXCEPT = UNION (left-to-right).
// 1 EXCEPT 2 INTERSECT 3  →  1 EXCEPT (2 INTERSECT 3)
UnionQuery
  = head:IntersectQuery tail:( _ UnionExceptOp _ IntersectQuery )* {
      if (tail.length === 0) {
        if (head.type === 'SelectQuery' || head.type === 'SelectIntersectExceptQuery' ||
            head.type === 'SelectWithUnionQuery') {
          return loc(finalizeQuery(head));
        }
        return head; // EXPLAIN statements pass through unwrapped
      }
      let result = head;
      for (const t of tail) {
        const op = t[1];
        const right = addLeading(t[3], [...flattenWs(t[0]), ...flattenWs(t[2])]);
        if (op.kw === 'UNION') {
          if (op.mode === 'DISTINCT') {
            // UNION DISTINCT chains flatten deeply into one DISTINCT wrapper
            result = loc(wrapSWU([...deepMembers(result), ...deepMembers(right)], { union_mode: 'UNION_DISTINCT' }));
          } else {
            // UNION ALL flattens unmoded wrappers on both sides; a nested
            // DISTINCT group forces the outer mode to UNION_ALL.
            const members = [...unionAllMembers(result), ...unionAllMembers(right)];
            const hasGroup = members.some((m) => m.type === 'SelectWithUnionQuery');
            result = loc(wrapSWU(members, hasGroup ? { union_mode: 'UNION_ALL' } : undefined));
          }
        } else {
          result = loc(intersectNode(op.kw, op.mode, result, right));
        }
      }
      return loc(finalizeQuery(result));
    }

// IntersectQuery: INTERSECT at higher precedence than EXCEPT/UNION (left-assoc).
IntersectQuery
  = head:UnionQueryAtom tail:( _ IntersectOp _ UnionQueryAtom )* {
      if (tail.length === 0) return head;
      let result = head;
      for (const t of tail) {
        const right = addLeading(t[3], [...flattenWs(t[0]), ...flattenWs(t[2])]);
        result = loc(intersectNode('INTERSECT', t[1].mode, result, right));
      }
      return result;
    }

// UnionExceptOp: UNION [ALL|DISTINCT] or EXCEPT [ALL|DISTINCT]
UnionExceptOp
  = KW_UNION _ mode:UnionAllOrDistinct? {
      return { kw: 'UNION', mode: mode === 'DISTINCT' ? 'DISTINCT' : null };
    }
  / "EXCEPT"i   ![a-zA-Z0-9_] mode:( _ UnionAllOrDistinct )? {
      const m = mode !== null ? mode[1] : null;
      return { kw: 'EXCEPT', mode: m === 'DISTINCT' ? 'DISTINCT' : (m === 'ALL' ? 'ALL' : null) };
    }

// IntersectOp: INTERSECT [ALL|DISTINCT]
IntersectOp
  = "INTERSECT"i ![a-zA-Z0-9_] mode:( _ UnionAllOrDistinct )? {
      const m = mode !== null ? mode[1] : null;
      return { mode: m === 'DISTINCT' ? 'DISTINCT' : (m === 'ALL' ? 'ALL' : null) };
    }

// UnionAllOrDistinct: supports UNION ALL and UNION DISTINCT
UnionAllOrDistinct
  = KW_ALL { return 'ALL'; }
  / "DISTINCT"i ![a-zA-Z0-9_] { return 'DISTINCT'; }
  / "EXCEPT"i   ![a-zA-Z0-9_] ( _ UnionAllOrDistinct )? { return 'EXCEPT'; }

// UnionQueryAtom: a single SELECT or EXPLAIN statement, optionally wrapped in parentheses
UnionQueryAtom
  = "(" beforeQuery:_ query:UnionQuery afterQuery:_ ")" {
      query = addSurroundingWs(query, beforeQuery, afterQuery);
      // A parenthesized single-select wrapper dissolves: the parens mark the
      // inner select so the enclosing union composes it directly.
      if (
        query.type === 'SelectWithUnionQuery' &&
        query.union_mode === undefined &&
        query.selects.length === 1 &&
        (query.selects[0].type === 'SelectQuery' || query.selects[0].type === 'SelectIntersectExceptQuery')
      ) {
        let result = { ...query.selects[0], parenthesized: true };
        if (query.leadingComments !== undefined) result = addLeading(result, query.leadingComments);
        if (query.trailingComments !== undefined) result = addTrailing(result, query.trailingComments);
        return result;
      }
      if (query.type === 'SelectWithUnionQuery' || query.type === 'SelectIntersectExceptQuery') {
        return { ...query, parenthesized: true };
      }
      return query;
    }
  / ExplainStatement
  / SelectStatement

// FromFirstSelectStatement: ClickHouse extension — FROM comes before SELECT
// e.g. FROM numbers(1) SELECT number
// e.g. WITH 1 as n FROM numbers(1) SELECT number * n
FromFirstSelectStatement
  = withClause:( CTEClause _ )?
    from:FromClause _
    KW_SELECT selectComments:_ distinct:( DistinctClause _ )?
    select:SelectItemList selectTrailing:_HWS
    prewhere:( _ PrewhereClause )?
    where:( _ WhereClause )?
    groupBy:( _ GroupByClause )?
    having:( _ HavingClause )?
    orderBy:( _ OrderByClause )?
    limitBy:( _ LimitByClause )?
    limit:( _ LimitClause )?
    offset:( _ OffsetClause )?
    settings:( _ SettingsClause )? {
      return loc(buildSelectQuery({
        withClause: withClause,
        distinct: distinct,
        select: select,
        selectComments: selectComments,
        selectTrailing: selectTrailing,
        from: from,
        prewhere: prewhere !== null ? prewhere[1] : null,
        where: where !== null ? where[1] : null,
        groupBy: groupBy,
        having: having !== null ? having[1] : null,
        orderBy: orderBy !== null ? orderBy[1] : null,
        limitBy: limitBy !== null ? limitBy[1] : null,
        limit: limit !== null ? limit[1] : null,
        offset: offset !== null ? offset[1] : null,
        settings: settings !== null ? settings[1] : null,
      }));
    }

// SelectStatement: the core SELECT query rule with all optional clauses.
// Clause order follows ClickHouse syntax: WITH, SELECT, FROM, PREWHERE, WHERE, GROUP BY, HAVING,
// WINDOW, QUALIFY, ORDER BY, LIMIT BY, LIMIT, OFFSET, FETCH, SETTINGS.
// Some clauses can appear in multiple positions (WINDOW, QUALIFY, WITH TOTALS/CUBE/ROLLUP).
// e.g. SELECT a, b FROM t WHERE x > 1 GROUP BY a ORDER BY b LIMIT 10
// e.g. WITH cte AS (SELECT 1) SELECT * FROM cte
// e.g. SELECT TOP 5 WITH TIES * FROM t ORDER BY score DESC
SelectStatement
  = FromFirstSelectStatement
  / withClause:( CTEClause _ )?
    KW_SELECT selectComments:_ distinct:( DistinctClause _ )? top:( "TOP"i ![a-zA-Z0-9_] _ UnaryExpr _ ( KW_WITH _ "TIES"i ![a-zA-Z0-9_] _ )? )?
    select:SelectItemList selectTrailing:_HWS
    withModifier1:( _ WithModifierClause )?
    from:( _ FromClause )?
    prewhere:( _ PrewhereClause )?
    where:( _ WhereClause )?
    withModifier2:( _ WithModifierClause )?
    groupBy:( _ GroupByClause )?
    having:( _ HavingClause )?
    window1:( _ WindowClause )?
    qualify1:( _ QualifyClause )?
    orderBy:( _ OrderByClause )?
    limitBy:( _ LimitByClause )?
    limit:( _ LimitClause )?
    offset:( _ OffsetClause )?
    fetch:( _ FetchClause )?
    window2:( _ WindowClause )?
    qualify2:( _ QualifyClause )?
    settings:( _ SettingsClause )? {
      const windows = window1 !== null ? window1[1] : (window2 !== null ? window2[1] : null);
      const qualify = qualify1 !== null ? qualify1 : qualify2;
      const wm = withModifier1 !== null ? withModifier1[1] : (withModifier2 !== null ? withModifier2[1] : null);
      return loc(buildSelectQuery({
        withClause: withClause,
        distinct: distinct,
        top: top !== null ? { count: top[3], withTies: top[5] !== null } : null,
        select: select,
        selectComments: selectComments,
        selectTrailing: selectTrailing,
        from: from !== null ? from[1] : null,
        fromLeading: from !== null ? flattenWs(from[0]) : undefined,
        prewhere: prewhere !== null ? addWsLeading(prewhere[1], prewhere[0]) : null,
        where: where !== null ? addWsLeading(where[1], where[0]) : null,
        withModifier: wm,
        groupBy: groupBy,
        having: having !== null ? addWsLeading(having[1], having[0]) : null,
        windows: windows,
        windowsAfterLimit: window1 === null && window2 !== null,
        qualify: qualify !== null ? addWsLeading(qualify[1], qualify[0]) : null,
        qualifyAfterLimit: qualify1 === null && qualify2 !== null,
        orderBy: orderBy !== null ? orderBy[1] : null,
        limitBy: limitBy !== null ? limitBy[1] : null,
        limit: limit !== null ? limit[1] : null,
        offset: offset !== null ? offset[1] : null,
        fetch: fetch !== null ? fetch[1] : null,
        settings: settings !== null ? settings[1] : null,
      }));
    }

// DistinctClause: DISTINCT [ON (cols)] or ALL
// DISTINCT ON (cols) is a PostgreSQL-style DISTINCT ON extension supported by ClickHouse.
DistinctClause
  = KW_DISTINCT _ "ON"i ![a-zA-Z0-9_] _ "(" _ cols:ExpressionList _ ")" {
      return { kind: 'distinctOn', on: cols };
    }
  / KW_DISTINCT { return 'DISTINCT'; }
  / KW_ALL { return 'ALL'; }

// ── Clauses ──────────────────────────────────────────────────────────────────

CTEClause
  // Tuple CTE: WITH ((expr) AS a, (expr) AS b) SELECT ... — parenthesized list of aliased expressions
  = KW_WITH wc:_ "(" _ head:TupleCTEElement _ "," _ second:TupleCTEElement tail:(_ "," _ TupleCTEElement)* _ ")" {
      const elements = [head, second, ...tail.map(t => t[3])];
      return { items: [{ kind: 'cteTuple', elements, location: location() }], keywordComments: wc };
    }
  / KW_WITH wc:_ "RECURSIVE"i ![a-zA-Z0-9_] _ items:CTEItemList { return { items: items, keywordComments: wc, recursive: true }; }
  / KW_WITH wc:_ items:CTEItemList { return { items: items, keywordComments: wc }; }

TupleCTEElement
  = expr:TernaryExpr afterExpr:_ KW_AS _ name:AliasName {
      return loc(applyAlias(addTrailing(expr, flattenWs(afterExpr)), name));
    }

CTEItemList
  = head:CTEItem tail:(_ "," _ CTEItem)* lastWs:_HWS {
      const items = buildCommaList(head, tail);
      if (lastWs.length > 0) {
        items[items.length - 1] = addTrailing(items[items.length - 1], lastWs);
      }
      return items;
    }

CTEItem
// Subquery CTE with column aliases: name (col1, col2) AS (SELECT ...)
  = name:CTEName _ "(" _ head:AliasName tail:(_ "," _ AliasName)* _ ")" _ KW_AS _ "(" beforeQuery:_ query:UnionQuery afterQuery:_ ")" {
      const result = { kind: 'cteSubquery', name, location: location(), query: addSurroundingWs(query, beforeQuery, afterQuery) };
      result.columnAliases = [head, ...tail.map(t => t[3])];
      return result;
    }
// Subquery CTE: name AS (SELECT ...)
  / name:CTEName _ KW_AS _ "(" beforeQuery:_ query:UnionQuery afterQuery:_ ")" {
      return { kind: 'cteSubquery', name, location: location(), query: addSurroundingWs(query, beforeQuery, afterQuery) };
    }
  // Lambda CTE with parens: (x, y) -> body AS name
  / "(" _ head:LambdaParamName tail:(_ "," _ LambdaParamName)* _ ")" _ "->" _ body:TernaryExpr afterExpr:_ KW_AS _ name:AliasName {
      const expr = loc(lambdaFn([head, ...tail.map(t => t[3])], body, location()));
      return { kind: 'cteExpr', name, expr: addTrailing(expr, flattenWs(afterExpr)) };
    }
  // Lambda CTE: x -> body AS name (single param without parens)
  / param:LambdaParamName _ "->" _ body:TernaryExpr afterExpr:_ KW_AS _ name:AliasName {
      const expr = loc(lambdaFn([param], body, location()));
      return { kind: 'cteExpr', name, expr: addTrailing(expr, flattenWs(afterExpr)) };
    }
  // Expression CTE: expr AS name (ClickHouse extension — name can be a keyword like 'from')
  / expr:TernaryExpr afterExpr:_ KW_AS _ name:AliasName {
      return { kind: 'cteExpr', name, expr: addTrailing(expr, flattenWs(afterExpr)) };
    }
  // Anonymous expression CTE: just `expr` with no alias (e.g. `WITH 1 SELECT 1`).
  // ClickHouse accepts this as a no-op WITH clause that still appears in the AST.
  / expr:TernaryExpr {
      return { kind: 'cteExpr', expr };
    }

// CTEName: the bound name of a subquery CTE (`WITH <name> AS (...)`). ClickHouse
// allows any reserved keyword here (e.g. `WITH ORDER AS (SELECT 1) SELECT * FROM ORDER`),
// so this accepts a normal Identifier plus any reserved keyword word. (Soft keywords
// are already accepted by Identifier, which only excludes the KEYWORDS set.)
CTEName
  = Identifier
  / word:$([a-zA-Z_] [a-zA-Z0-9_]*) &{ return KEYWORDS.has(word.toUpperCase()); } { return word; }

// SelectItemList: supports optional trailing comma (ClickHouse extension).
// The !SelectClauseKeyword guard only prevents a trailing-comma FROM from being
// consumed as a select item via the last-resort AliasName rule. All other clause
// keywords (ORDER, GROUP, WHERE, LIMIT, ...) are valid bare column identifiers
// after a comma in ClickHouse (e.g. "SELECT A, ORDER FROM T" yields columns A and
// ORDER); they only start a clause when they are NOT preceded by a select-list comma.
SelectItemList
  = head:SelectItem tail:(_ "," _ !SelectClauseKeyword SelectItem)* (_ "," _)? {
      return buildCommaList(head, tail, 4);
    }

// SelectClauseKeyword: negative lookahead used in SelectItemList to support a
// trailing comma before the FROM clause (e.g. "SELECT a, FROM t"). Only FROM is
// listed: ClickHouse treats every other clause keyword after a comma as a column
// identifier rather than a clause start, so "SELECT a, ORDER BY x" is a syntax
// error there (ORDER parses as a column, then BY is unexpected), matching ClickHouse.
// The trailing lookahead lets FROM still act as a column when an operator follows
// (e.g. "SELECT a, FROM + 1").
SelectClauseKeyword
  = "FROM"i ![a-zA-Z0-9_] _ !( "+" / "-" / "*" / "/" / "," / "IN"i ![a-zA-Z0-9_] / "AND"i ![a-zA-Z0-9_] / "OR"i ![a-zA-Z0-9_] )

SelectItem
  = expr:TernaryExpr alias:SelectItemAlias? {
      if (alias !== null) {
        // applyAlias overrides any auto-alias (e.g. from @@varname)
        return loc(applyAlias(expr, alias));
      }
      return expr;
    }

SelectItemAlias
  = _ KW_AS _ alias:AliasName { return alias; }
  / _ !KW_FORMAT !("PARALLEL"i ![a-zA-Z0-9_] _ "WITH"i ![a-zA-Z0-9_]) alias:ColumnImplicitAlias { return alias; }

// ColumnImplicitAlias: a column alias written without the AS keyword. Like
// Identifier, but additionally accepts the reserved keywords ClickHouse permits as
// implicit column aliases (see COLUMN_IMPLICIT_ALIAS_KEYWORDS), so `SELECT a DESC
// FROM t` and `SELECT a SELECT FROM t` parse the keyword as the alias.
ColumnImplicitAlias
  = Identifier
  / word:$([a-zA-Z_] [a-zA-Z0-9_]*) &{ return COLUMN_IMPLICIT_ALIAS_KEYWORDS.has(word.toUpperCase()); } { return word; }

FromClause
  = KW_FROM comments:_ expr:JoinExpr { return addWsLeading(expr, comments); }

JoinExpr
  = head:FromAtom tail:( _ JoinPart )* {
      return tail.reduce((acc, t) => ({ left: acc, ...t[1] }), head);
    }

// FromAtom: a single table source — subquery, table function, or table reference.
// Each can have an optional alias, FINAL modifier (for ReplacingMergeTree dedup), and SAMPLE clause.
// e.g. (SELECT 1) AS t, numbers(10), system.one FINAL, my_table SAMPLE 0.1
FromAtom
  = "(" beforeQuery:_ query:UnionQuery afterQuery:_ ")" alias:FromAtomAlias? final:( _ KW_FINAL )? sample:( _ SampleClause )? {
      const result = loc({ kind: 'subqueryFrom', query: addSurroundingWs(query, beforeQuery, afterQuery) });
      if (final !== null) result.final = true;
      if (sample !== null) result.sample = sample[1];
      if (alias !== null) {
        if (typeof alias === 'object') {
          if (alias.alias !== undefined) result.alias = alias.alias;
          if (alias.columnAliases !== undefined) result.columnAliases = alias.columnAliases;
        } else {
          result.alias = alias;
        }
      }
      return result;
    }
  / table:TableFunctionRef alias:FromAtomAlias? final:( _ KW_FINAL )? sample:( _ SampleClause )? {
      let result = final !== null ? { ...table, final: true } : table;
      if (sample !== null) result = { ...result, sample: sample[1] };
      if (alias !== null) result = { ...result, alias: typeof alias === 'object' ? alias.alias : alias };
      return result;
    }
  / table:TableRef alias:FromAtomAlias? final:( _ KW_FINAL )? sample:( _ SampleClause )? {
      let result = final !== null ? { ...table, final: true } : table;
      if (sample !== null) result = { ...result, sample: sample[1] };
      if (alias !== null) result = { ...result, alias: typeof alias === 'object' ? alias.alias : alias };
      return result;
    }

// SampleClause: SAMPLE ratio [OFFSET ratio]
// Supports integer (e.g., SAMPLE 100), float (e.g., SAMPLE 0.1), and fraction (e.g., SAMPLE 1/10) forms,
// with an optional OFFSET ratio for sharding.
SampleClause
  = "SAMPLE"i ![a-zA-Z0-9_] _ ratio:SampleRatioExpr offset:( _ "OFFSET"i ![a-zA-Z0-9_] _ SampleRatioExpr )? {
      const result = { ratio };
      if (offset !== null) result.offset = offset[4];
      return result;
    }

// SampleRatioExpr: a ratio value, either a fraction (num/den) or a simple number
SampleRatioExpr
  = num:SampleNumber _ "/" _ den:SampleNumber { return { num, den, location: location() }; }
  / num:SampleNumber { return { num, location: location() }; }

// SampleNumber: a non-negative integer or float literal (no leading sign)
SampleNumber
  = digits:$([0-9][0-9_]*) "." frac:$([0-9_]*)? exp:SampleExponent? {
      return digits.replace(/_/g, '') + '.' + (frac !== null ? frac.replace(/_/g, '') : '') + (exp !== null ? exp : '');
    }
  / "." digits:$([0-9_]+) exp:SampleExponent? {
      return '.' + digits.replace(/_/g, '') + (exp !== null ? exp : '');
    }
  / digits:$([0-9][0-9_]*) exp:SampleExponent {
      return digits.replace(/_/g, '') + exp;
    }
  / digits:$([0-9][0-9_]*) { return digits.replace(/_/g, ''); }

SampleExponent
  = e:$[eE] sign:$[+-]? digits:$[0-9]+ { return e + (sign !== null ? sign : '') + digits; }

// Alias for FROM atoms. Without AS keyword, we exclude join-starting keywords
// to prevent them from being consumed as aliases (e.g., "... ) ANY LEFT JOIN")
// Also exclude FORMAT so it isn't consumed as an alias (FORMAT is not in Keyword to allow use as table function).
// Optional column alias list after the table alias: AS x (a, b) — standard SQL subquery column aliases.
FromAtomAlias
  = _ KW_AS _ alias:AliasName cols:( _ "(" _ head:AliasName tail:( _ "," _ AliasName )* _ ")" { return [head, ...tail.map((t) => t[3])]; } )? {
      return cols !== null ? { alias, columnAliases: cols } : alias;
    }
  // Column aliases without table alias: (n1, n2) or (n1) — standard SQL subquery column aliases
  / _ "(" _ !( KW_SELECT / KW_WITH / "EXPLAIN"i ![a-zA-Z0-9_] ) head:AliasName tail:( _ "," _ AliasName )* _ ")" {
      return { columnAliases: [head, ...tail.map((t) => t[3])] };
    }
  / _ !JoinKeyword !ArrayJoinKeyword !KW_FORMAT !("PARALLEL"i ![a-zA-Z0-9_] _ "WITH"i ![a-zA-Z0-9_]) alias:TableImplicitAlias { return alias; }

// TableImplicitAlias: a table alias written without the AS keyword. Like Identifier,
// plus the reserved keywords ClickHouse permits as table aliases
// (TABLE_IMPLICIT_ALIAS_KEYWORDS, which includes the operator words AND/OR/IN that
// cannot appear after a table except as an alias).
//
// `SELECT` gets a dedicated branch: ClickHouse treats a trailing `SELECT` as a table
// alias (`SELECT x FROM t SELECT`), but the same token also begins the FROM-first
// form `FROM numbers(1) SELECT number`. The `!(_ SelectItem)` guard resolves the
// ambiguity exactly as ClickHouse does — `SELECT` is only an alias when no select
// item follows it (so `FROM numbers(1) SELECT number` stays FROM-first).
TableImplicitAlias
  = Identifier
  / "SELECT"i ![a-zA-Z0-9_] !(_ SelectItem) { return 'SELECT'; }
  / word:$([a-zA-Z_] [a-zA-Z0-9_]*) &{ return TABLE_IMPLICIT_ALIAS_KEYWORDS.has(word.toUpperCase()); } { return word; }

TableFunctionRef
  = name:FunctionName _ "(" _ args:TableFunctionArgList? settings:( ( _ "," )? _ KW_SETTINGS _ SettingsList )? _ ")" {
      const result = loc({ kind: 'tableFunctionRef', name, args: args !== null ? args : [] });
      if (settings !== null) result.settings = settings[4];
      return result;
    }

// TableFunctionArgList: like FunctionCallArgList but stops before a trailing ", SETTINGS ..."
TableFunctionArgList
  = head:FunctionCallArgGuarded tail:(_ "," _ FunctionCallArgGuarded)* {
      return buildCommaList(head, tail);
    }

JoinPart
  = join_type:ArrayJoinKeyword exprs:( _ ExpressionList )? {
      return loc({ kind: 'arrayJoinExpr', joinType: join_type, expressions: exprs ? exprs[1] : [] });
    }
  / join_type:JoinKeyword _ right:FromAtom _ constraint:JoinConstraint {
      return loc({ kind: 'joinExpr', joinType: join_type.dir, strictness: join_type.strictness,
        global: join_type.global, outer: join_type.outer, strictnessAfter: join_type.strictnessAfter,
        right, constraint });
    }
  / join_type:JoinKeyword _ right:FromAtom {
      return loc({ kind: 'joinExpr', joinType: join_type.dir, strictness: join_type.strictness,
        global: join_type.global, outer: join_type.outer, strictnessAfter: join_type.strictnessAfter,
        right });
    }
  // Comma-separated tables: implicit cross join (COMMA kind, as ClickHouse stores it)
  / "," _ right:FromAtom {
      return loc({ kind: 'joinExpr', joinType: 'COMMA', right });
    }

// JoinKeyword: [GLOBAL] [strictness] [direction] [OUTER] JOIN — returns direction string.
// Structured as optional qualifiers to avoid ~80 brute-force alternatives.
JoinKeyword
  // PASTE JOIN (special case): [ANY|ALL] PASTE JOIN
  = s:(JoinStrictness _)? "PASTE"i ![a-zA-Z0-9_] _ KW_JOIN {
      return { dir: 'PASTE', strictness: s !== null ? s[0] : undefined, global: false };
    }
  // Standard joins: [GLOBAL] [strictness-before] [direction] [strictness-after] [OUTER] JOIN
  / g:(KW_GLOBAL _)?
    s1:(JoinStrictness _)?
    dir:(
      KW_CROSS { return "CROSS"; }
      / KW_FULL { return "FULL"; }
      / KW_LEFT { return "LEFT"; }
      / KW_RIGHT { return "RIGHT"; }
      / KW_INNER { return "INNER"; }
    )?
    // Handle strictness/qualifier after direction: LEFT ANY JOIN, LEFT ASOF JOIN, etc.
    s2:(_ JoinStrictness)?
    o:(_ KW_OUTER)?
    _ KW_JOIN {
      const strictness = s1 !== null ? s1[0] : (s2 !== null ? s2[1] : undefined);
      // SEMI / ANTI JOIN defaults to LEFT when no direction is given (ClickHouse semantics).
      const defaultDir = (strictness === 'SEMI' || strictness === 'ANTI') ? 'LEFT' : 'INNER';
      return {
        dir: dir !== null ? dir : defaultDir,
        strictness,
        global: g !== null,
        outer: o !== null,
        strictnessAfter: s1 === null && s2 !== null,
      };
    }

// JoinStrictness: any/all/semi/anti/asof qualifier
JoinStrictness
  = KW_ANY { return 'ANY'; }
  / KW_ALL { return 'ALL'; }
  / KW_SEMI { return 'SEMI'; }
  / KW_ANTI { return 'ANTI'; }
  / KW_ASOF { return 'ASOF'; }

ArrayJoinKeyword
  = KW_LEFT _ KW_ARRAY _ KW_JOIN { return "LEFT ARRAY"; }
  / KW_ARRAY _ KW_JOIN { return "ARRAY"; }

// JoinConstraint: ON expr, USING (cols), USING cols (no parens, one or more)
// USING () with empty list is valid in ClickHouse (treated as a full cross join with renaming)
// USING also supports aliased columns: USING (a AS b) — the alias is discarded for AST purposes
JoinConstraint
  = KW_ON comments:_ expr:Expression { return { kind: 'on', expr: addWsLeading(expr, comments) }; }
  / KW_USING _ "(" _ cols:UsingColumnList? _ ")" { return { kind: 'using', columns: cols !== null ? cols : [] }; }
  // USING * — wildcard join key (ClickHouse extension)
  / KW_USING _ "*" { return { kind: 'using', columns: [loc({ type: 'Asterisk' })] }; }
  / KW_USING _ cols:UsingColumnList { return { kind: 'using', columns: cols, noParens: true }; }

// UsingColumnList: comma-separated identifiers with optional AS alias
UsingColumnList
  = head:UsingColumn tail:( _ "," _ UsingColumn )* {
      return [head, ...tail.map((t) => t[3])];
    }

UsingColumn
  = name:Identifier _ KW_AS _ alias:AliasName { return loc(applyAlias(ident([name]), alias)); }
  / name:Identifier { return loc(ident([name])); }

// PrewhereClause: PREWHERE expr (treated same as WHERE for AST purposes)
PrewhereClause
  = KW_PREWHERE comments:_ expr:Expression { return addWsLeading(expr, comments); }

WhereClause
  = KW_WHERE comments:_ expr:Expression { return addWsLeading(expr, comments); }

GroupByClause
  = KW_GROUP _ KW_BY _ KW_ALL modifiers:GroupByModifier* {
      const withTotals = modifiers.some((m) => m === 'TOTALS');
      const withCube = modifiers.some((m) => m === 'CUBE');
      const withRollup = modifiers.some((m) => m === 'ROLLUP');
      return { all: true, withTotals, withCube, withRollup };
    }
  / KW_GROUP _ KW_BY _ "GROUPING"i ![a-zA-Z0-9_] _ "SETS"i ![a-zA-Z0-9_] _ "(" _ sets:GroupingSets _ ")" modifiers:GroupByModifier* {
      const withTotals = modifiers.some((m) => m === 'TOTALS');
      const withCube = modifiers.some((m) => m === 'CUBE');
      const withRollup = modifiers.some((m) => m === 'ROLLUP');
      return { groupingSets: sets, withTotals, withCube, withRollup };
    }
  / KW_GROUP _ KW_BY keywordComments:_ exprList:ExpressionList modifiers:GroupByModifier* {
      const withTotals = modifiers.some((m) => m === 'TOTALS');
      const withCube = modifiers.some((m) => m === 'CUBE');
      const withRollup = modifiers.some((m) => m === 'ROLLUP');
      // Attach keyword comments as leadingComments on the first item
      const items = exprList;
      const kc = flattenWs(keywordComments);
      if (kc.length > 0 && items.length > 0) {
        items[0] = addLeading(items[0], kc);
      }
      return { items, withTotals, withCube, withRollup };
    }

// GroupingSets: comma-separated list of grouping sets (each set is a parenthesized list or bare expr)
GroupingSets
  = head:GroupingSet tail:(_ "," _ GroupingSet)* {
      return [head, ...tail.map((t) => t[3])];
    }

// GroupingSet: either a parenthesized list of expressions or a single bare expression
GroupingSet
  = "(" _ items:ExpressionList _ ")" { return items; }
  / "(" _ ")" { const a = []; a.location = location(); return a; }
  / expr:TernaryExpr { return [expr]; }

// GroupByModifier: WITH ROLLUP, WITH CUBE, or WITH TOTALS
GroupByModifier
  = _ KW_WITH _ KW_TOTALS { return 'TOTALS'; }
  / _ KW_WITH _ "ROLLUP"i ![a-zA-Z0-9_] { return 'ROLLUP'; }
  / _ KW_WITH _ "CUBE"i ![a-zA-Z0-9_] { return 'CUBE'; }

// WithModifierClause: standalone WITH TOTALS/ROLLUP/CUBE (can appear after SELECT list without GROUP BY)
WithModifierClause
  = KW_WITH _ KW_TOTALS { return 'TOTALS'; }
  / KW_WITH _ "ROLLUP"i ![a-zA-Z0-9_] { return 'ROLLUP'; }
  / KW_WITH _ "CUBE"i   ![a-zA-Z0-9_] { return 'CUBE'; }

HavingClause
  = KW_HAVING comments:_ expr:Expression { return addWsLeading(expr, comments); }

// QualifyClause: QUALIFY expr — filters rows after window functions, analogous to HAVING for aggregations
QualifyClause
  = "QUALIFY"i ![a-zA-Z0-9_] comments:_ expr:Expression { return addWsLeading(expr, comments); }

OrderByClause
  = KW_ORDER _ KW_BY _ items:OrderByItemList { return items; }

// LimitByClause: LIMIT [offset,] count BY expr_list or LIMIT count OFFSET offset BY expr_list
// LIMIT n BY ALL means no per-column limit — store an empty by list.
LimitByClause
  = KW_LIMIT _ count:TernaryExpr _ KW_BY _ KW_ALL { return { count: count, by: [] }; }
  / KW_LIMIT _ offset:TernaryExpr _ "," _ count:TernaryExpr _ KW_BY _ KW_ALL {
      return { count: count, by: [], limitByOffset: offset };
    }
  / KW_LIMIT _ count:TernaryExpr _ KW_OFFSET _ offset:TernaryExpr _ KW_BY _ KW_ALL {
      return { count: count, by: [], limitByOffset: offset };
    }
  / KW_LIMIT _ offset:TernaryExpr _ "," _ count:TernaryExpr _ KW_BY _ by:ExpressionList {
      return { count: count, by: by, limitByOffset: offset };
    }
  / KW_LIMIT _ count:TernaryExpr _ KW_OFFSET _ offset:TernaryExpr _ KW_BY _ by:ExpressionList {
      return { count: count, by: by, limitByOffset: offset };
    }
  / KW_LIMIT _ count:TernaryExpr _ KW_BY _ by:ExpressionList {
      return { count: count, by: by };
    }

// LimitClause: LIMIT count [WITH TIES] or LIMIT count, offset [WITH TIES]
// The comma syntax (LIMIT count, offset) is a ClickHouse extension where count comes first.
// WITH TIES returns additional rows that tie with the last row in ORDER BY.
// e.g. LIMIT 10, LIMIT 10 WITH TIES, LIMIT 5, 10 (5 rows starting at offset 10)
LimitClause
  = KW_LIMIT _ count:TernaryExpr _ "," _ offset:TernaryExpr _ KW_WITH _ "TIES"i ![a-zA-Z0-9_] { return { count: count, offset: offset, comma: true, withTies: true }; }
  / KW_LIMIT _ count:TernaryExpr _ "," _ offset:TernaryExpr { return { count: count, offset: offset, comma: true }; }
  / KW_LIMIT _ count:TernaryExpr _ KW_WITH _ "TIES"i ![a-zA-Z0-9_] { return { count: count, comma: false, withTies: true }; }
  / KW_LIMIT _ count:TernaryExpr { return { count: count, comma: false }; }

// OffsetClause: OFFSET n [ROW[S]] — SQL standard allows ROWS/ROW keyword after offset value
OffsetClause
  = KW_OFFSET _ count:TernaryExpr ( _ ( "ROWS"i / "ROW"i ) ![a-zA-Z0-9_] )? { return count; }

// FetchClause: FETCH {FIRST|NEXT} n {ROW[S]|ROW} {ONLY|WITH TIES} — SQL standard pagination
FetchClause
  = "FETCH"i ![a-zA-Z0-9_] _ ( "FIRST"i / "NEXT"i ) ![a-zA-Z0-9_] _ count:TernaryExpr _ ( "ROWS"i / "ROW"i ) ![a-zA-Z0-9_] _ ties:( "ONLY"i / KW_WITH _ "TIES"i ) ![a-zA-Z0-9_] {
      return { count: count, withTies: typeof ties === 'string' ? false : true };
    }

SettingsClause
  = KW_SETTINGS _ items:SettingsList { return items; }

// WindowClause: WINDOW name AS (...) [, name AS (...)] - named window definitions
WindowClause
  = KW_WINDOW _ items:WindowItemList { return items; }

WindowItemList
  = head:WindowItem tail:(_ "," _ WindowItem)* {
      return [head, ...tail.map((t) => t[3])];
    }

// WindowItem: name AS (window_spec) - single named window definition
// The spec may optionally start with a base window identifier (window inheritance).
WindowItem
  = name:Identifier _ KW_AS _ "(" _ baseWindow:Identifier _ spec:WindowSpec _ ")" {
      spec.parent_window_name = baseWindow;
      return { name, spec };
    }
  / name:Identifier _ KW_AS _ "(" _ spec:WindowSpec _ ")" {
      return { name, spec };
    }

SettingsList
  = head:SettingItem tail:(_ "," _ SettingItem)* {
      return [head, ...tail.map((t) => t[3])];
    }

// SettingName allows any identifier including reserved keywords (e.g. SETTINGS limit=5)
// Also supports compound names like custom_compound.identifier.v1 and param_$1
SettingName
  = head:[a-zA-Z_] tail:[a-zA-Z0-9_$.]* { return head + tail.join(''); }
  / '"' chars:DoubleQuotedChar* '"' { return chars.join(''); }
  / '`' chars:BacktickChar* '`' { return chars.join(''); }

SettingItem
  = name:SettingName _ "=" _ value:UnaryExpr forResource:( _ "FOR"i ![a-zA-Z0-9_] _ AliasName )? {
      const result = { name, value };
      if (forResource !== null) result.forResource = forResource[4];
      return result;
    }
  // Bare setting name without value (e.g. SETTINGS force_index_by_date) — boolean true
  / name:SettingName {
      return { name, value: loc(lit('Bool', true)) };
    }

// ── ORDER BY items ────────────────────────────────────────────────────────────

OrderByItemList
  = head:OrderByItem tail:(_ "," _ OrderByItem)* {
      return [head, ...tail.map((t) => t[3])];
    }

// OrderByItem: expr [AS alias] [ASC|DESC] [NULLS FIRST|LAST] [COLLATE 'locale'] [WITH FILL [FROM a] [TO b] [STEP n]]
// The optional AS alias creates an alias expression (e.g. ORDER BY f(x) AS y DESC).
OrderByItem
  = expr:TernaryExpr
    alias:( _ KW_AS _ AliasName )?
    dir:( _ ( KW_DESC / KW_ASC ) )?
    nulls:( _ "NULLS"i ![a-zA-Z0-9_] _ ( "FIRST"i / "LAST"i ) ![a-zA-Z0-9_] )?
    collate:( _ "COLLATE"i ![a-zA-Z0-9_] _ StringLiteral )?
    fill:( _ "WITH"i ![a-zA-Z0-9_] _ "FILL"i ![a-zA-Z0-9_] fillArgs:WithFillArgs? )?
    {
      const resolvedExpr = alias !== null ? loc(applyAlias(expr, alias[3])) : expr;
      const result = loc({ type: 'OrderByElement', expression: resolvedExpr, direction: dir !== null ? dir[1].toUpperCase() : 'ASC' });
      if (nulls !== null) {
        // `NULLS FIRST/LAST` is the only way the parser sets nulls_first. Default
        // direction handling is done by ClickHouse; the formatter just re-emits
        // whatever was written.
        result.nulls_first = nulls[4].toUpperCase() === 'FIRST';
      }
      if (collate !== null) result.collation = collate[4];
      if (fill !== null) {
        result.with_fill = true;
        const fillArgs = fill[6];
        if (fillArgs !== null) {
          if (fillArgs.fillFrom !== undefined) result.fill_from = fillArgs.fillFrom;
          if (fillArgs.fillTo !== undefined) result.fill_to = fillArgs.fillTo;
          if (fillArgs.fillStep !== undefined) result.fill_step = fillArgs.fillStep;
          if (fillArgs.fillStaleness !== undefined) result.fill_staleness = fillArgs.fillStaleness;
          if (fillArgs.interpolate !== undefined) result._interpolate = fillArgs.interpolate;
        }
      }
      return result;
    }

// WITH FILL optional sub-clauses: FROM expr TO expr STEP expr STALENESS expr [INTERPOLATE (...)]
WithFillArgs
  = from:( _ "FROM"i ![a-zA-Z0-9_] _ TernaryExpr )?
    to:( _ "TO"i ![a-zA-Z0-9_] _ TernaryExpr )?
    step:( _ "STEP"i ![a-zA-Z0-9_] _ TernaryExpr )?
    staleness:( _ "STALENESS"i ![a-zA-Z0-9_] _ TernaryExpr )?
    interp:( _ "INTERPOLATE"i ![a-zA-Z0-9_] _ "(" _ InterpolateList _ ")" )? {
      const result = {};
      if (from !== null && from[4] !== null) result.fillFrom = from[4];
      if (to !== null && to[4] !== null) result.fillTo = to[4];
      if (step !== null && step[4] !== null) result.fillStep = step[4];
      if (staleness !== null && staleness[4] !== null) result.fillStaleness = staleness[4];
      if (interp !== null) result.interpolate = interp[6];
      return result;
    }

// InterpolateList: list of column [AS expr] items inside INTERPOLATE (...)
InterpolateList
  = head:InterpolateItem tail:( _ "," _ InterpolateItem )* { return [head, ...tail.map((t) => t[3])]; }
  / _ { return []; }

InterpolateItem
  = col:Identifier _ KW_AS _ expr:Expression { return loc({ type: 'InterpolateElement', column: col, expr: expr }); }
  / col:Identifier {
      // `INTERPOLATE (x)` is sugar for `INTERPOLATE (x AS x)`. We always emit
      // the AS form (canonical); both produce identical ASTs.
      return loc({ type: 'InterpolateElement', column: col, expr: loc(ident([col])) });
    }

// ── Expressions (precedence: ternary < OR < AND < comparison < add < mul < unary < primary) ────

ExpressionList
  = head:Expression tail:(_ "," _ Expression)* { return buildCommaList(head, tail); }

// Expression: alias form or ternary expression
Expression
  = expr:TernaryExpr asWs:_ KW_AS _ alias:AliasName {
      // Auto-aliases (e.g. @@varname) are overridden by an explicit AS alias
      return loc(applyAlias(addTrailing(expr, flattenWs(asWs)), alias));
    }
  / TernaryExpr

// ExpressionWithImplicitAlias: like Expression but also supports bare alias without AS keyword
// (ClickHouse extension). Used in function call args and special function syntax (SUBSTRING, TRIM, etc.)
// The implicit alias must be followed by a delimiter (, ) FROM FOR) to avoid ambiguity.
ExpressionWithImplicitAlias
  = expr:TernaryExpr asWs:_ KW_AS _ alias:AliasName {
      return loc(applyAlias(addTrailing(expr, flattenWs(asWs)), alias));
    }
  // Bare alias without AS: must be followed by , ) FROM FOR (as delimiter of the argument context)
  / expr:TernaryExpr aliasWs:_ alias:Identifier &( _ ( "," / ")" / "FROM"i ![a-zA-Z0-9_] / "FOR"i ![a-zA-Z0-9_] ) ) {
      return loc(applyAlias(addTrailing(expr, flattenWs(aliasWs)), alias));
    }
  / TernaryExpr

// TernaryExpr: ternary ? : operator, maps to Function if(cond, then, else)
TernaryExpr
  = cond:OrExpr ws1:_ "?" ws2:_ then:TernaryExpr ws3:_ ":" ws4:_ else_:TernaryExpr {
      return loc(fn('if', [
        cond,
        addLeading(then, [...flattenWs(ws1), ...flattenWs(ws2)]),
        addLeading(else_, [...flattenWs(ws3), ...flattenWs(ws4)])
      ], { is_operator: true }));
    }
  / OrExpr

// OrExpr: n-ary OR expression. Multiple OR operands at the same level are collected
// into a flat list, matching ClickHouse's EXPLAIN AST behavior. Parenthesized sub-expressions
// remain as separate nodes.
OrExpr
  = head:AndExpr tail:(_ KW_OR _ AndExpr)+ {
      const operands = [head, ...tail.map((t) => addLeading(t[3], [...flattenWs(t[0]), ...flattenWs(t[2])]))];
      return loc(opFn('OR', operands));
    }
  / AndExpr

// AndExpr: n-ary AND expression. Multiple AND operands at the same level are collected
// into a flat list, matching ClickHouse's EXPLAIN AST behavior.
AndExpr
  = head:NotExpr tail:(_ KW_AND _ NotExpr)+ {
      const operands = [head, ...tail.map((t) => addLeading(t[3], [...flattenWs(t[0]), ...flattenWs(t[2])]))];
      return loc(opFn('AND', operands));
    }
  / NotExpr

NotExpr
  // NOT followed by "(" is handled as a high-precedence function-call-like NOT in PrimaryBase;
  // exclude that case here so NOT (0) + NOT (0) parses as plus(not(0), not(0)) like ClickHouse does.
  = KW_NOT !( _ "(" ) comments:_ expr:NotExpr {
      return loc(fn('not', [addWsLeading(expr, comments)], { is_operator: true }));
    }
  / CompareExpr

// CompareExpr: handles IN, LIKE, IS, BETWEEN, and comparison operators.
// IN/LIKE/IS/BETWEEN results can optionally be followed by a comparison operator (e.g. k IN (100) = 1).
// CompareExpr: left-associative chain of comparison operators.
// Uses CompareRightExpr (not NotExpr) to avoid right-associativity — the right operand must not
// start a new comparison chain. E.g. k = (100) = 1 → equals(equals(k,100), 1).
// ExtendedCompareOp also matches `IS [NOT] DISTINCT FROM` as a comparison-level operator so
// `x IS NOT DISTINCT FROM y IN (...)` parses as `<=>(x, in(y, [...]))`.
CompareExpr
  = base:CompareBase tail:CompareExprTail* {
      return tail.reduce((acc, f) => f(acc), base);
    }

// CompareExprTail: one step of the comparison chain — either a comparison operator
// with its right operand, or a postfix IS [NOT] NULL that wraps the whole comparison
// so far. IS [NOT] NULL binds looser than the comparison operators, so `a = b IS NULL`
// parses as `isNull(equals(a, b))`: the right operand `b` does not absorb the suffix
// (CompareRightExpr uses CompareRightSuffix, which excludes IS [NOT] NULL), and the
// suffix instead applies to the accumulated comparison here.
CompareExprTail
  = ws1:_ op:ExtendedCompareOp ws2:_ right:CompareRightExpr {
      return (left) => {
        const r = addLeading(right, [...flattenWs(ws1), ...flattenWs(ws2)]);
        const rewritten = tryAnyAllRewrite(op, left, r);
        if (rewritten !== null) return loc(rewritten);
        return loc(opFn(op, [left, r]));
      };
    }
  / s:IsNullSuffix { return s; }

// CompareBase: parse AddExpr once, then apply zero or more chainable suffixes
// (IN, LIKE, BETWEEN, IS [NOT] NULL, :: cast). Chained suffixes let us parse:
//   `x IS NULL :: Int32`        → cast(isNull(x), Int32)
//   `x IS NULL + 1 IS NOT NULL` → isNotNull(plus(isNull(x), 1))
//   `x IN (1, 2) IN (...)`      → in(in(x, [1, 2]), [...])
CompareBase
  = left:AddExpr suffixes:CompareBaseSuffix* {
      return suffixes.reduce((acc, s) => s(acc), left);
    }

// CompareBaseSuffix: a chainable suffix that takes the left expression and produces a new expression.
// Returns a function that takes the left expression and produces the full expression.
// Used by the leftmost operand (CompareBase), where a standalone `x IS NULL` is valid;
// the comparison right operand uses CompareRightSuffix (no IS [NOT] NULL) instead.
CompareBaseSuffix
  = CompareRightSuffix
  / IsNullSuffix

// CompareRightSuffix: the chainable suffixes that bind to a single operand — IN, LIKE,
// REGEXP, BETWEEN, and `::` cast. Excludes IS [NOT] NULL, which binds looser than the
// comparison operators (handled at CompareExpr level) rather than to the bare operand.
CompareRightSuffix
  // IN variants: [GLOBAL] [NOT] IN (array / parens / bare)
  = _ global:(KW_GLOBAL _)? negated:(KW_NOT _)? KW_IN _ target:InTarget {
      const name = global !== null
        ? (negated !== null ? 'globalNotIn' : 'globalIn')
        : (negated !== null ? 'notIn' : 'in');
      return (left) => loc(fn(name, [left, inRhs(target.values)], { is_operator: true }));
    }
  // LIKE / ILIKE
  / _ negated:(KW_NOT _)? KW_ILIKE _ right:AddExpr {
      const name = negated !== null ? 'notILike' : 'ilike';
      return (left) => (loc(fn(name, [left, right], { is_operator: true })));
    }
  / _ negated:(KW_NOT _)? KW_LIKE _ right:AddExpr {
      const name = negated !== null ? 'notLike' : 'like';
      return (left) => (loc(fn(name, [left, right], { is_operator: true })));
    }
  // REGEXP
  / _ "REGEXP"i ![a-zA-Z0-9_] _ right:AddExpr {
      return (left) => (loc(fn('match', [left, right], { is_operator: true })));
    }
  // BETWEEN expands to operator-form comparisons, as ClickHouse stores it.
  // The synthesized n-ary wrapper is marked `parenthesized: true` so the
  // formatted output `x >= a AND x <= b` reparses to an equivalent node
  // structure (the explicit parens that wrap_nary would emit are recorded
  // here).
  / _ KW_NOT _ KW_BETWEEN _ low:AddExpr _ KW_AND _ high:AddExpr {
      return (left) => (loc(fn('or', [
        loc(opFn('<', [left, low])),
        loc(opFn('>', [left, high]))
      ], { is_operator: true, parenthesized: true })));
    }
  / _ KW_BETWEEN _ low:AddExpr _ KW_AND _ high:AddExpr {
      return (left) => (loc(fn('and', [
        loc(opFn('>=', [left, low])),
        loc(opFn('<=', [left, high]))
      ], { is_operator: true, parenthesized: true })));
    }
  // :: cast operator at comparison level so `x IS NULL :: Type` works as cast(isNull(x), Type).
  // (At PrimaryExpr level, `x::Type` is also handled for tighter-binding casts on bare values.)
  / _ "::" _ type:TypeCastIdentifier {
      return (left) => (loc(castOpFn(left, type)));
    }

// IsNullSuffix: postfix IS [NOT] NULL with an optional arithmetic continuation
// ("x IS NOT NULL + 1" parses as plus(isNotNull(x), 1) — arithmetic binds tighter
// than IS NULL, matching ClickHouse precedence). Kept separate from
// CompareRightSuffix so it can wrap a whole comparison at CompareExpr level rather
// than binding only to a comparison's right operand.
IsNullSuffix
  = _ "IS"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "NULL"i ![a-zA-Z0-9_] arith:( _ op:AddOp _ right:NotPrefixExpr )* {
      return (left) => {
        const base = loc(fn('isNotNull', [left], { is_operator: true }));
        return arith.reduce((acc, t) => (loc(opFn(t[1], [acc, t[3]]))), base);
      };
    }
  / _ "IS"i ![a-zA-Z0-9_] _ "NULL"i ![a-zA-Z0-9_] arith:( _ op:AddOp _ right:NotPrefixExpr )* {
      return (left) => {
        const base = loc(fn('isNull', [left], { is_operator: true }));
        return arith.reduce((acc, t) => (loc(opFn(t[1], [acc, t[3]]))), base);
      };
    }

// ExtendedCompareOp: a comparison-level binary operator.
// Includes the simple symbolic operators plus `IS [NOT] DISTINCT FROM`, which behave
// the same as `<=>` / `IS DISTINCT FROM` but use multi-word syntax. Putting these at
// the chained operator level lets the right operand consume a full CompareRightExpr
// (so `x IS NOT DISTINCT FROM y IN (...)` parses as `<=>(x, in(y, [...]))`).
ExtendedCompareOp
  = "IS"i ![a-zA-Z0-9_] _ "NOT"i ![a-zA-Z0-9_] _ "DISTINCT"i ![a-zA-Z0-9_] _ "FROM"i ![a-zA-Z0-9_] { return '<=>'; }
  / "IS"i ![a-zA-Z0-9_] _ "DISTINCT"i ![a-zA-Z0-9_] _ "FROM"i ![a-zA-Z0-9_] { return 'IS DISTINCT FROM'; }
  / op:CompareOp { return op; }

// InTarget: the target expression for IN — array literal, parenthesized list, or bare expression
InTarget
  = arr:ArrayLiteral { return { values: [arr] }; }
  / "(" beforeValues:_ values:InValues afterValues:_ ")" {
      // Attach comments to first/last value if they are expression nodes
      if (Array.isArray(values)) {
        const bv = flattenWs(beforeValues);
        const av = flattenWs(afterValues);
        if ((bv.length > 0 || av.length > 0) && values.length > 0) {
          values = values.slice();
          values[0] = addLeading(values[0], bv);
          values[values.length - 1] = addTrailing(values[values.length - 1], av);
        }
      } else if (values && values.type === 'Subquery') {
        values = addSurroundingWs(values, beforeValues, afterValues);
      }
      return { values };
    }
  / single:PrimaryExpr { return { values: [single] }; }

CompareOp = "<=>" / ">=" / "<=" / "<>" / "!=" / "==" / ">" / "<" / "="

// CompareRightExpr: right-hand side of a comparison operator.
// Includes AddExpr (arithmetic) and boolean NOT prefix, but NOT comparison operators.
// This ensures comparisons are left-associative: k = (100) = 1 → equals(equals(k,100), 1).
// Allows: 1 != NOT 1, k = x + y, k > -5. Does not allow: k = (a = b) unless in parens.
CompareRightExpr
  = KW_NOT _ expr:CompareRightExpr { return loc(fn('not', [expr], { is_operator: true })); }
  / left:AddExpr suffixes:CompareRightSuffix* {
      return suffixes.reduce((acc, s) => s(acc), left);
    }

InValues
  = query:UnionQuery { return loc(subqueryNode(query)); }
  / ExpressionList

// ── Arithmetic expressions ────────────────────────────────────────────────────

// AddExpr: +/- operators; right side allows NotPrefixExpr so NOT can appear as a right operand
// (e.g. NOT 0 + NOT 0 = NOT(0 + NOT(0)), consistent with ClickHouse precedence rules)
AddExpr
  = head:ConcatExpr tail:(_ op:AddOp _ right:NotPrefixExpr)* {
      return tail.reduce((acc, t) => (loc(opFn(t[1], [
        acc,
        addLeading(t[3], [...flattenWs(t[0]), ...flattenWs(t[2])])
      ]))), head);
    }

// NotPrefixExpr: allows NOT as a prefix, but only wrapping arithmetic-level expressions (no comparison).
// Used as right-hand side of + and - so that NOT has lower precedence than arithmetic operators.
NotPrefixExpr
  = KW_NOT _ expr:NotPrefixExpr { return loc(fn('not', [expr], { is_operator: true })); }
  / ConcatExpr

AddOp
  = "+"
  / "-" !">" { return "-"; }
  / "\u2212" { return "-"; }  // Unicode MINUS SIGN (U+2212), used in some ClickHouse SQL files

// ConcatExpr handles the || string concatenation operator, producing a flat concat() call
ConcatExpr
  = head:MulExpr tail:(_ "||" _ MulExpr)* {
      if (tail.length === 0) return head;
      const parts = [head, ...tail.map((t) => addLeading(t[3], [...flattenWs(t[0]), ...flattenWs(t[2])]))];
      return loc(fn('concat', parts, { is_operator: true }));
    }

MulExpr
  = head:UnaryExpr tail:(_ op:MulOp _ right:UnaryExpr)* {
      return tail.reduce((acc, t) => (loc(opFn(t[1], [
        acc,
        addLeading(t[3], [...flattenWs(t[0]), ...flattenWs(t[2])])
      ]))), head);
    }

// MulOp: multiplication-level binary operators including keyword variants DIV and MOD
MulOp
  = $[*/%]
  / "DIV"i ![a-zA-Z0-9_] { return 'DIV'; }
  / "MOD"i ![a-zA-Z0-9_] { return 'MOD'; }

// UnaryExpr: unary minus and plus — minus negates, plus is identity.
// Recurses to support double-negative (e.g. - -1).
// Literal folding: -5 becomes Int64(-5) rather than negate(UInt64(5)), matching ClickHouse EXPLAIN behavior.
// For :: cast chains (e.g. -1::Int32::String), the minus is folded into the innermost literal
// by walking down the cast chain to avoid wrapping the whole expression in negate().
// Falls back to negate(expr) for non-literal or already-negative expressions.
UnaryExpr
  = "+" _ expr:UnaryExpr { return expr; }
  / ("-" / "\u2212") _ expr:UnaryExpr {
      // Don't fold across explicit parentheses: -(1) must produce negate(1), not Int64_-1.
      // (-1) without an outer minus stays as a UInt64 literal — only `-` immediately before a
      // bare literal folds. A parenthesized inner expression always wraps in negate().
      if (expr.parenthesized) {
        return loc(fn('negate', [expr], { is_operator: true }));
      }
      if (expr.type === 'Literal' && expr.value_type === 'UInt64' && expr.neg_folded === undefined) {
        // Negate a non-negative integer literal: compute decimal value using BigInt for precision.
        // A UInt64 carrying `neg_folded` is itself a folded `-0` — `- -0` stays negate(0).
        const bigNeg = -BigInt(expr.value);
        // Check if fits in Int64 range [-2^63, 0]
        const INT64_MIN = BigInt('-9223372036854775808');
        if (bigNeg >= INT64_MIN) {
          // -0 stays a UInt64 in ClickHouse; mark with `neg_folded` so the
          // outer minus of `- -0` doesn't re-fold. The marker is parse-time
          // only and is stripped before the AST is returned (see
          // `stripParseTimeMarkers` in src/index.ts).
          const intResult = loc(bigNeg === BigInt(0) ? uintLit('0') : intLit(String(bigNeg)));
          if (bigNeg === BigInt(0)) intResult.neg_folded = true;
          return intResult;
        }
        // Overflows Int64: use Float64 (loses precision like ClickHouse does)
        return loc(floatLit(String(Number(bigNeg))));
      }
      if (expr.type === 'Literal' && expr.value_type === 'Float64' && isNonNegNumericLit(expr)) {
        // Negate a positive float literal (works from `value`/`nonfinite`).
        return loc(negateNumericLit(expr));
      }
      // Identify a `::`-form CAST: either the structured-operand form
      // (is_operator: true) or the folded pure-literal form (operand is a
      // String literal carrying the parse-time `cast_operand` marker —
      // stripped from the final AST, but visible during parsing).
      const isOpCast = (e) => {
        if (e.type !== 'Function' || e.name !== 'CAST') return false;
        if (e.is_operator === true) return true;
        const a0 = e.arguments[0];
        return a0 !== undefined && a0.type === 'Literal' && a0.cast_operand !== undefined;
      };
      if (isOpCast(expr)) {
        // -value::Type: fold the minus sign into the cast's innermost literal (for :: operator casts)
        // Recurse through nested casts to find the innermost literal
        let innermost = expr;
        while (isOpCast(innermost) && isOpCast(innermost.arguments[0])) {
          innermost = innermost.arguments[0];
        }
        const inner = innermost.arguments[0];
        // The operand may have been stringified (pure-literal :: casts)
        if (inner.type === 'Literal' && inner.value_type === 'String' && inner.cast_operand !== undefined) {
          const orig = inner.cast_operand;
          if (isNonNegNumericLit(orig)) {
            const negOrig = negateNumericLit(orig);
            const negInner = { ...inner, value: '-' + inner.value, cast_operand: negOrig };
            let result = { ...innermost, arguments: [negInner, innermost.arguments[1]] };
            const stack = [];
            let cur = expr;
            while (cur !== innermost) {
              stack.push(cur);
              cur = cur.arguments[0];
            }
            for (let si = stack.length - 1; si >= 0; si--) {
              result = { ...stack[si], arguments: [result, stack[si].arguments[1]] };
            }
            return result;
          }
        }
        if (isNonNegNumericLit(inner)) {
          const negInner = negateNumericLit(inner);
          // Rebuild the cast chain with the negated innermost literal
          let result = { ...innermost, arguments: [negInner, innermost.arguments[1]] };
          const stack = [];
          let cur = expr;
          while (cur !== innermost) {
            stack.push(cur);
            cur = cur.arguments[0];
          }
          for (let si = stack.length - 1; si >= 0; si--) {
            result = { ...stack[si], arguments: [result, stack[si].arguments[1]] };
          }
          return result;
        }
      }
      // For all other cases (non-literal, already-negative literal, etc.), wrap in negate()
      return loc(fn('negate', [expr], { is_operator: true }));
    }
  / PrimaryExpr

// ── Primary expressions ───────────────────────────────────────────────────────

// PrimaryExpr: a base expression followed by zero or more postfix operators and optional window clause.
// Postfix operators (PrimaryExprSuffix) are left-associative and include:
//   :: (type cast), [index] (array subscript), .N (tuple element by index),
//   .name (tuple element by name), .:Type (JSON subcolumn), .* (tuple expansion)
// e.g. arr[1], tuple.2, expr::Int32, json.:String, row.*
PrimaryExpr
  = base:PrimaryBase suffixes:PrimaryExprSuffix* nulls:NullsHandlingClause? over:OverClause? {
      const baseStart = base !== null && base.location !== undefined
        ? base.location.start.offset
        : location().start.offset;
      let result = suffixes.reduce((acc, s) => {
        if (s.kind === 'subscript') {
          return loc(fn('arrayElement', [acc, s.index], { is_operator: true }));
        } else if (s.kind === 'tuple_element') {
          let idxArg;
          const absIndex = s.index.charAt(0) === '-' ? s.index.substring(1) : s.index;
          // Large numbers that exceed UInt64 range are treated as Float64
          let idxLiteral;
          if (absIndex.length > 18) {
            const fval = Number(absIndex);
            idxLiteral = loc(floatLit(fval.toExponential().replace('+', '')));
          } else {
            idxLiteral = loc(uintLit(absIndex));
          }
          if (s.index.charAt(0) === '-') {
            // Negative index: wrap as negate(literal)
            idxArg = loc(fn('negate', [idxLiteral], { is_operator: true }));
          } else {
            idxArg = idxLiteral;
          }
          return loc(fn('tupleElement', [acc, idxArg], { is_operator: true }));
        } else if (s.kind === 'field_access') {
          // Named field access: expr.name — tuple element by name
          return loc(fn('tupleElement', [acc, loc(strLit(s.name))], { is_operator: true }));
        } else if (s.kind === 'json_subcolumn') {
          // .:Type or .:`QuotedType` — JSON subcolumn type annotation appended to the
          // identifier path (ClickHouse treats json.a.:Int64 as one identifier).
          // The base must be an Identifier; ClickHouse only supports `.:Type` on
          // JSON-typed column references. The `:`Type`` marker becomes a part of
          // `name_parts`, and the formatter recognizes `:`-prefixed parts to
          // re-emit the JSON subcolumn syntax.
          if (acc.type !== 'Identifier') {
            error('JSON subcolumn syntax .:Type requires an identifier base');
          }
          const typeMarker = ':`' + s.type + '`';
          const baseParts = acc.name_parts !== undefined ? acc.name_parts : [acc.name];
          // Path elements (after `.:Type`) accept the same source-form sugar
          // as base parts (`^name`, `name[]`); normalize them the same way so
          // they land in `name_parts` in their canonical shape.
          const normalizedPath = (s.path || []).flatMap(normalizeIdentPart);
          const pathName = normalizedPath.length > 0 ? '.' + normalizedPath.map(partName).join('.') : '';
          return loc({
            type: 'Identifier',
            name: acc.name + '.' + typeMarker + pathName,
            name_parts: [...baseParts, typeMarker, ...normalizedPath],
          });
        } else if (s.kind === 'asterisk_access') {
          // expr.* — tuple/expression wildcard expansion
          const node = loc({ type: 'Asterisk', expression: acc });
          if (s.transformers && s.transformers.length > 0) {
            node.transformers = s.transformers;
          }
          return node;
        } else {
          // :: cast operator; structured operands get `is_operator: true`
          // distinguishing from `CAST(x AS T)`. Pure-literal operands fold
          // to a String literal (matching ClickHouse's AST) and become
          // indistinguishable from a user-written `CAST('1','UInt8')`; the
          // formatter accepts that canonicalization. The operand's
          // verbatim source text is sliced from `input` (using
          // base→suffix offsets) so ClickHouse's byte-exact serialization
          // of the cast operand is preserved without a sidecar `_source`.
          const operandText = input.substring(baseStart, s.suffixStart);
          return loc(castOpFn(acc, s.type, operandText));
        }
      }, base);
      if (result !== null && result.type === 'Function') {
        // RESPECT/IGNORE NULLS modifier (aggregate or window functions)
        if (nulls !== null && nulls !== undefined) {
          result = { ...result, nulls_action: nulls };
        }
        // Attach window info for OVER clauses
        if (over !== null && over !== undefined) {
          result = { ...result, is_window_function: true, kind: 'WINDOW_FUNCTION' };
          if (over.windowName !== undefined) {
            result.window_name = over.windowName;
          } else {
            result.window_definition = over.spec;
          }
        }
      }
      return result;
    }

// NullsHandlingClause: RESPECT NULLS or IGNORE NULLS modifier on window functions
NullsHandlingClause
  = _ which:("RESPECT"i / "IGNORE"i) ![a-zA-Z0-9_] _ "NULLS"i ![a-zA-Z0-9_] {
      return which.toUpperCase() + ' NULLS';
    }

// OverClause: window function OVER clause.
// Returns a WindowSpec for inline specs, or null for bare named-window references.
// Three cases:
//   OVER (name [additional_spec]) — window inheritance; returns additional spec or null if empty
//   OVER (spec)                   — inline window spec; returns spec (possibly empty {})
//   OVER name                     — bare window name reference; returns null
// The first alternative handles both OVER (w) and OVER (w additional_spec), disambiguating
// from OVER (spec) (e.g. OVER (PARTITION BY x)) via the closing ')' check after the identifier.
OverClause
  // OVER (identifier [spec]) — window inheritance; the identifier becomes parent_window_name.
  // Named windows with OVER (w) produce an empty WindowDefinition; OVER (w spec) adds the spec content.
  = _ "OVER"i ![a-zA-Z0-9_] _ "(" _ parent:Identifier _ spec:WindowSpec _ ")" {
      return { spec: { ...spec, parent_window_name: parent } };
    }
  // OVER (spec) — inline window spec
  / _ "OVER"i ![a-zA-Z0-9_] _ "(" _ spec:WindowSpec _ ")" { return { spec }; }
  // OVER name — bare window name reference; window_name only, no WindowDefinition
  / _ "OVER"i ![a-zA-Z0-9_] _ name:Identifier { return { windowName: name }; }

// WindowSpec: optional PARTITION BY, ORDER BY, and frame clause — builds a WindowDefinition node
WindowSpec
  = partitionBy:( "PARTITION"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ items:ExpressionList { return items; } )?
    _ orderBy:( "ORDER"i ![a-zA-Z0-9_] _ "BY"i ![a-zA-Z0-9_] _ items:OrderByItemList { return items; } )?
    _ frame:WindowFrameClause? {
      const spec = loc({ type: 'WindowDefinition' });
      if (partitionBy !== null) spec.partition_by = partitionBy;
      if (orderBy !== null) spec.order_by = orderBy;
      if (frame !== null) Object.assign(spec, frame);
      return spec;
    }

// WindowFrameClause: ROWS/RANGE/GROUPS BETWEEN start AND end, or ROWS/RANGE/GROUPS bound
// (single-bound form defaults the frame end to CURRENT ROW, as ClickHouse does)
WindowFrameClause
  = type:WindowFrameType _ "BETWEEN"i ![a-zA-Z0-9_] _ start:WindowFrameBound _ "AND"i ![a-zA-Z0-9_] _ end:WindowFrameBound {
      return { frame_type: type, frame_begin: frameBoundNode(start, true), frame_end: frameBoundNode(end, false) };
    }
  / type:WindowFrameType _ bound:WindowFrameBound {
      // Single-bound form (`ROWS 5 PRECEDING`) defaults the end to CURRENT
      // ROW, matching ClickHouse. The formatter always emits the BETWEEN
      // form (canonical); both produce identical ASTs.
      return {
        frame_type: type,
        frame_begin: frameBoundNode(bound, true),
        frame_end: { type: 'Current' },
      };
    }

WindowFrameType = ("ROWS"i / "RANGE"i / "GROUPS"i) ![a-zA-Z0-9_] { return text().toUpperCase(); }

// WindowFrameBound: UNBOUNDED PRECEDING/FOLLOWING, CURRENT ROW, or expr PRECEDING/FOLLOWING
WindowFrameBound
  = "UNBOUNDED"i ![a-zA-Z0-9_] _ "PRECEDING"i ![a-zA-Z0-9_] { return { boundType: 'Unbounded', preceding: true }; }
  / "UNBOUNDED"i ![a-zA-Z0-9_] _ "FOLLOWING"i ![a-zA-Z0-9_] { return { boundType: 'Unbounded', preceding: false }; }
  / "CURRENT"i ![a-zA-Z0-9_] _ "ROW"i ![a-zA-Z0-9_] { return { boundType: 'Current', preceding: null }; }
  / expr:TernaryExpr _ "PRECEDING"i ![a-zA-Z0-9_] { return { boundType: 'Offset', preceding: true, offset: expr }; }
  / expr:TernaryExpr _ "FOLLOWING"i ![a-zA-Z0-9_] { return { boundType: 'Offset', preceding: false, offset: expr }; }

// OverBody: balanced parentheses content (used in WindowItem for named window body text)
OverBody
  = "(" OverBody* ")"
  / [^()]

// PrimaryExprSuffix: postfix operators applied left-to-right after PrimaryBase.
// Multiple suffixes can chain: expr::Int32[1].name.:String
PrimaryExprSuffix
  = _ "::" _ type:TypeCastIdentifier { return { kind: 'cast', type: type, suffixStart: location().start.offset }; }
  // JSON subcolumn type annotation: .:TypeName or .:`QuotedType` with optional trailing .field access
  / "." ":" type:JsonSubcolumnType path:( "." name:ColumnRefCont { return name; } )* {
      return { kind: 'json_subcolumn', type: type, path: path };
    }
  / _ "[" _ index:Expression _ "]" { return { kind: 'subscript', index: index }; }
  / _ "." _ index:$[0-9]+ { return { kind: 'tuple_element', index: index }; }
  // Negative tuple element index: expr.-N (e.g. tuple.-1)
  / _ "." _ "-" index:$[0-9]+ { return { kind: 'tuple_element', index: '-' + index }; }
  // Named field access: expr.name — tuple element access by name (e.g. reverse(t).a)
  // Guard against ":N" (JSON subcolumn), "*" (qualified asterisk), digits (integer index above), and "-" (negative index)
  / _ "." _ ![:*0-9\-] name:AliasName { return { kind: 'field_access', name: name }; }
  // Tuple/expression asterisk: expr.* — expands all fields (e.g. tuple(1,'a').* or CAST(...).*).
  // Must come after field_access and before other rules to avoid conflicts.
  / _ "." _ "*" transformers:( _ ColumnTransformer )* {
      return { kind: 'asterisk_access', transformers: transformers.map((t) => t[1]) };
    }

// JSON subcolumn type: either a backtick-quoted type string (for complex types with parens)
// or an unquoted ClickHouse type identifier.
JsonSubcolumnType
  = "`" chars:BacktickChar* "`" { return chars.join(''); }
  / ClickHouseType

TypeCastIdentifier = ClickHouseType

// MySQL-compatible multiword type aliases used in CAST expressions.
// Only truly multi-word types are listed here (single-word aliases pass through unchanged).
// Tries the longest match first to avoid partial matches.
// Returns the type keyword normalized to uppercase with single spaces, matching ClickHouse EXPLAIN output.
// All alternatives return text() normalized to uppercase with single spaces.
MultiWordType
  = MultiWordTypeInner { return text().toUpperCase().replace(/\s+/g, ' ').trim(); }

MultiWordTypeInner
  = "DOUBLE"i _ "PRECISION"i ![a-zA-Z0-9_]
  / "NATIONAL"i _ ( "CHARACTER"i / "CHAR"i ) _ "LARGE"i _ "OBJECT"i ![a-zA-Z0-9_]
  / "NATIONAL"i _ ( "CHARACTER"i / "CHAR"i ) _ "VARYING"i ![a-zA-Z0-9_]
  / "NATIONAL"i _ ( "CHARACTER"i / "CHAR"i ) ![a-zA-Z0-9_]
  / "NCHAR"i _ "LARGE"i _ "OBJECT"i ![a-zA-Z0-9_]
  / "NCHAR"i _ "VARYING"i ![a-zA-Z0-9_]
  / ( "CHARACTER"i / "CHAR"i / "BINARY"i ) _ "LARGE"i _ "OBJECT"i ![a-zA-Z0-9_]
  / ( "CHARACTER"i / "CHAR"i / "BINARY"i ) _ "VARYING"i ![a-zA-Z0-9_]
  / "INT1"i _ ( "SIGNED"i / "UNSIGNED"i ) ![a-zA-Z0-9_]
  / ( "TINYINT"i / "SMALLINT"i / "BIGINT"i ) _ ( "SIGNED"i / "UNSIGNED"i ) ![a-zA-Z0-9_]
  / ( "MEDIUMINT"i / "INTEGER"i / "INT"i ) _ ( "SIGNED"i / "UNSIGNED"i ) ![a-zA-Z0-9_]

// ── Structured data type parsing (for column definitions) ────────────────────

// ColumnDataType: returns a structured { name, args?, location } object. The
// `location` is captured here (a rule, so `location()` spans exactly the type
// text) and threaded onto the materialized node by `dtNode`/`dtArgNode`.
ColumnDataType
  = mw:MultiWordType args:( _ "(" _ ColumnDataTypeArgList? _ ")" )? {
      const result = { name: mw, location: location() };
      if (args !== null) result.args = args[3] !== null ? args[3] : [];
      return result;
    }
  / "`" name:$[^`]+ "`" { return { name, location: location() }; }
  / "\"" name:$[^"]+ "\"" { return { name, location: location() }; }
  // Enum types: parse values as structured list
  / name:$("Enum8"i / "Enum16"i / "Enum"i ![a-zA-Z0-9_]) _ "(" _ values:EnumValueList _ ")" {
      return { name: name.trim(), args: [{ kind: 'enumValues', values }], location: location() };
    }
  / name:$("Enum8"i / "Enum16"i / "Enum"i ![a-zA-Z0-9_]) {
      return { name: name.trim(), location: location() };
    }
  / name:$([a-zA-Z_][a-zA-Z0-9_]*) args:( _ "(" _ ColumnDataTypeArgList? _ ")" )? suffix:( _ ("SIGNED"i / "UNSIGNED"i) ![a-zA-Z0-9_] )? {
      let typeName = name;
      if (suffix !== null) typeName = (name + ' ' + suffix[1]).toUpperCase();
      const result = { name: typeName, location: location() };
      if (args !== null) result.args = args[3] || [];
      return result;
    }

EnumValueList
  = head:EnumValue tail:( _ "," _ EnumValue )* {
      return [head, ...tail.map(t => t[3])];
    }

EnumValue
  = name:StringLiteral _ "=" _ value:$("-"? _ [0-9]+) { return { name: name.value, value: value.replace(/\s/g, '') }; }
  / "NULL"i ![a-zA-Z0-9_] { return { name: null, value: null }; }
  / name:StringLiteral { return { name: name.value }; }

ColumnDataTypeArgList
  = head:ColumnDataTypeArg tail:( _ "," _ ColumnDataTypeArg )* trailing_comma:( _ "," )? {
      return [head, ...tail.map(t => t[3])];
    }

// A single type argument: could be a sub-type, a named field (Nested/Tuple), a literal, a setting, or a SKIP/REGEXP spec
// Each alternative captures `location()` so `dtArgNode`/`jsonArgNode` can stamp
// the materialized node (NameTypePair, ObjectTypeArgument, ...) with its span.
ColumnDataTypeArg
  // SKIP REGEXP 'pattern' (for JSON type)
  = "SKIP"i ![a-zA-Z0-9_] _ "REGEXP"i ![a-zA-Z0-9_] _ str:$("'" [^']* "'") {
      return { kind: 'literal', value: 'SKIP REGEXP ' + str, location: location() };
    }
  // SKIP path (for JSON type)
  / "SKIP"i ![a-zA-Z0-9_] _ path:TypeArgFieldName {
      return { kind: 'literal', value: 'SKIP ' + path, location: location() };
    }
  // Named field: "name Type" (for Nested, named Tuple, JSON typed paths)
  / name:TypeArgFieldName _ &([a-zA-Z_`] / "(" / "'" / "\"") type:ColumnDataType {
      return { kind: 'namedField', name: name.replace(/[`"]/g, ''), type, location: location() };
    }
  // String literal
  / str:$("'" [^']* "'") { return { kind: 'literal', value: str, location: location() }; }
  // Numeric literal (possibly negative, with decimal)
  / val:$("-"? [0-9]+ ("." [0-9]*)?) { return { kind: 'literal', value: val, location: location() }; }
  // Setting: name = value  (for Dynamic(max_types=3), JSON(max_dynamic_paths=10))
  / name:$([a-zA-Z_][a-zA-Z0-9_]*) _ "=" _ val:TernaryExpr {
      return { kind: 'setting', name: name, value: val, location: location() };
    }
  // Subtype (must be after named field to avoid consuming the name)
  / type:ColumnDataType { return { kind: 'type', type, location: location() }; }
  // Raw text for other specials
  / raw:$([^ ,)]+) { return { kind: 'literal', value: raw, location: location() }; }

// Field name for type args: supports bare identifiers, dotted paths, backtick-quoted, and double-quoted identifiers
TypeArgFieldName
  = parts:( TypeArgFieldPart ( "." TypeArgFieldPart )* ) { return text(); }

TypeArgFieldPart
  = "`" [^`]+ "`"
  / '"' [^"]+ '"'
  / [a-zA-Z_\u0080-\uffff][a-zA-Z0-9_\u0080-\uffff]*

// ── Raw data type parsing (for CAST and expression contexts) ─────────────────

// ClickHouseType: a type identifier with optional parenthesized arguments (balanced).
// e.g. Int32, Nullable(String), Enum8('Hello' = 0, 'World' = 1), Tuple(Int32, String),
//      Map(String, UInt64), Array(Nullable(Float64)), DOUBLE PRECISION
// Type arguments are captured as raw text (not parsed as expressions) because they can
// contain non-expression syntax like enum value assignments ('Hello' = 0).
ClickHouseType
  = mw:MultiWordType { return mw; }
  / "`" name:$[^`]+ "`" { return name; }
  / "\"" name:$[^"]+ "\"" { return name; }
  / name:$([a-zA-Z_][a-zA-Z0-9_]*) _ args:ClickHouseTypeArgs? {
      return name + (args !== null ? args : '');
    }
// Parenthesized type arguments (balanced)
ClickHouseTypeArgs
  = "(" parts:ClickHouseTypeArgPart* ")" {
      return "(" + parts.join("") + ")";
    }

ClickHouseTypeArgPart
  = nested:ClickHouseTypeArgs { return nested; }
  / str:$("'" [^']* "'") { return str; }
  / chars:$[^()']+ { return chars; }

// ── Compound expressions ──────────────────────────────────────────────────────

// PrimaryBase: atomic expressions — the leaves and compound literals of the expression tree.
// Order matters: alternatives are tried top-to-bottom with PEG ordered choice.
// Keyword-starting rules (NOT, CASE, INTERVAL, DATE, TIMESTAMP, etc.) must come before
// the fallback AliasName rules at the bottom to prevent keywords being consumed as column names.
PrimaryBase
  = MySQLGlobalVariable
  // NOT(expr) and NOT (expr) — parenthesized NOT as a high-precedence unary operator.
  // This is distinct from NotExpr (low precedence): NOT (0) + NOT (0) → plus(not(0), not(0)).
  // NOT (a, b, c) — NOT applied to a multi-element tuple: not(tuple(a, b, c))
  / KW_NOT _ tuple:TupleLiteral {
      return loc(fn('not', [tupleAsFunction(tuple)], { is_operator: true }));
    }
  / KW_NOT _ "(" _ expr:ExpressionWithImplicitAlias _ ")" { return loc(fn('not', [expr], { is_operator: true })); }
  / ParenGroup
  / ArrayLiteral
  / LambdaExprNoParens
  // {QP:Identifier}.field.col — QueryParam used as a table/db qualifier in a dotted column ref.
  // Must come before QueryParam to prevent {QP:Identifier} being consumed as a bare query param.
  / first:QueryParamIdentifier rest:( _ "." _ part:ColumnRefCont { return part; } )+ {
      return loc(ident([first, ...rest]));
    }
  / QueryParam
  / MapLiteral
  / HeredocLiteral
  / BoolLiteral
  / NullLiteral
  / BinaryStringLiteral
  / HexStringLiteral
  / HexLiteral
  / BinaryNumLiteral
  / FloatLiteral
  / IntegerLiteral
  / StringLiteral
  / CaseExpr
  / IntervalExpr
  / ColumnsExpr
  / FunctionCall
  / QualifiedAsterisk
  // Bare keyword identifier used as column reference only when immediately followed by subscript '['.
  // This allows ClickHouse system-table columns like Settings['key'] where Settings is a reserved word.
  / name:AliasName &(_ "[") { return loc(ident([name])); }
  / ColumnRef
  // Last resort: allow reserved keywords as bare column references (e.g., GROUP BY in, SELECT count).
  // Only reached when all other PrimaryBase alternatives fail.
  / name:AliasName { return loc(ident([name])); }
  / Asterisk

// MapLiteral: {'key': value, ...} syntax — parsed as map() function call
// A map literal starts with '{' followed by an expression then ':' (not just an identifier or identifier:type which is QueryParam/Heredoc)
MapLiteral
  = "{" _ "}" { return loc(fn('map', [])); }
  / "{" _ first:MapEntry rest:( _ "," _ MapEntry )* _ "}" {
      const args = [first[0], first[1]];
      for (const r of rest) {
        args.push(r[3][0]);
        args.push(r[3][1]);
      }
      return loc(fn('map', args));
    }

MapEntry
  = key:TernaryExpr _ ":" _ value:TernaryExpr { return [key, value]; }

// MySQLGlobalVariable: @@varname or @@session.varname / @@global.varname syntax.
// Maps to globalVariable('varname') with alias @@varname (session./global. prefix is stripped).
MySQLGlobalVariable
  = "@@" ("session." / "global." / "local.")? name:$[a-zA-Z0-9_]+ {
      return loc(applyAlias(fn('globalVariable', [loc(strLit(name))]), '@@' + name));
    }

// ParenGroup: left-factored rule for all "("-prefixed expressions in PrimaryBase.
// After consuming "(", branches on what follows to avoid re-entering "(" for each alternative.
ParenGroup
  // Empty-arg lambda: () -> expr
  = "(" _ ")" _ "->" _ body:Expression {
      return loc(lambdaFn([], body, location()));
    }
  // Empty tuple: ()
  / "(" _ ")" { return loc(fn('tuple', [], { is_operator: true })); }
  // Subquery: (SELECT ...) / (WITH ... SELECT ...) / (EXPLAIN ...)
  / "(" beforeQuery:_ &(KW_SELECT / KW_WITH / "EXPLAIN"i ![a-zA-Z0-9_]) query:UnionQuery afterQuery:_ ")" {
      return loc(subqueryNode(addSurroundingWs(query, beforeQuery, afterQuery)));
    }
  // Lambda with parens: (x, y, ...) -> expr
  / "(" _ head:LambdaParamName tail:(_ "," _ LambdaParamName)* _ ")" _ "->" _ body:Expression {
      return loc(lambdaFn([head, ...tail.map((t) => t[3])], body, location()));
    }
  // Tuple or parenthesized expression: parse first expression, then branch on comma vs close paren
  / "(" beforeFirst:_ first:Expression rest:(_ "," _ Expression)* trailing:(_ ",")? afterLast:_ ")" {
      first = addLeading(first, flattenWs(beforeFirst));
      if (rest.length === 0 && trailing === null) {
        // (expr) — parenthesized expression
        first = addTrailing(first, flattenWs(afterLast));
        return { ...first, parenthesized: true };
      } else if (rest.length === 0) {
        // (expr,) — single-element tuple
        return loc(fn('tuple', [first], { is_operator: true }));
      } else {
        // (expr, expr, ...) — multi-element tuple
        const elems = [first, ...rest.map((r) => r[3])];
        return loc(tupleNode(elems));
      }
    }

// TupleLiteral: multi-element tuple (used by NOT-tuple rule in PrimaryBase)
TupleLiteral
  // Single-element tuple with trailing comma: (expr,)
  = "(" _ elem:Expression _ "," _ ")" {
      return loc(fn('tuple', [elem], { is_operator: true }));
    }
  // Multi-element tuple (optionally with trailing comma)
  / "(" _ first:Expression _ "," _ rest:ExpressionList _ ","? _ ")" {
      return loc(tupleNode([first, ...rest]));
    }

ArrayLiteral
  = "[" _ "]" {
      return loc(fn('array', [], { is_operator: true }));
    }
  / "[" beforeItems:_ items:ExpressionList afterItems:_ "]" {
      const bi = flattenWs(beforeItems);
      const ai = flattenWs(afterItems);
      if ((bi.length > 0 || ai.length > 0) && items.length > 0) {
        items = items.slice();
        items[0] = addLeading(items[0], bi);
        items[items.length - 1] = addTrailing(items[items.length - 1], ai);
      }
      return loc(arrayNode(items));
    }

QueryParam
  = "{" _ name:$( "$" [0-9]+ / [a-zA-Z_][a-zA-Z0-9_]* ) _ ":" _ type:$([^}]+) "}" {
      return loc({ type: 'QueryParameter', name: name, param_type: type.trim() });
    }

// HeredocLiteral: PostgreSQL-style dollar-quoted string: $tag$content$tag$ or $$content$$
// The end marker is found by scanning forward in the input (not via PEG backtracking).
// e.g. $$hello world$$, $heredoc$multi-line content$heredoc$
HeredocLiteral
  = "$" tag:$([^$]*) "$" {
      const endMarker = `$${tag}$`;
      const pos = input.indexOf(endMarker, peg$currPos);
      if (pos < 0) { error(`Unterminated heredoc $${tag}$`); }
      const content = input.substring(peg$currPos, pos);
      peg$currPos = pos + endMarker.length;
      return loc(strLit(content));
    }

// BoolLiteral: true and false keywords produce Bool literals
BoolLiteral
  = "true"i  ![a-zA-Z0-9_] { return loc(lit('Bool', true)); }
  / "false"i ![a-zA-Z0-9_] { return loc(lit('Bool', false)); }

NullLiteral
  = "NULL"i ![a-zA-Z0-9_] {
      return loc(lit('Null', null));
    }

// BinaryStringLiteral: b'01010...' syntax - binary digits converted to a UTF-8 string value
BinaryStringLiteral
  = [bB] "'" digits:$[01]* "'" {
      if (digits.length === 0) return loc(strLit(''));
      // Pad to multiple of 8 bits, MSB-first, then interpret as UTF-8 bytes
      const padded = digits.padStart(Math.ceil(digits.length / 8) * 8, '0');
      const bytes = [];
      for (let i = 0; i < padded.length; i += 8) {
        bytes.push(parseInt(padded.slice(i, i + 8), 2));
      }
      return loc(strLit(Buffer.from(bytes).toString('utf-8')));
    }

// HexStringLiteral: x'hexdigits...' syntax - hex digit pairs converted to a UTF-8 string value
HexStringLiteral
  = [xX] "'" digits:$[0-9a-fA-F]* "'" {
      if (digits.length === 0) return loc(strLit(''));
      const padded = digits.length % 2 === 1 ? '0' + digits : digits;
      return loc(strLit(Buffer.from(padded, 'hex').toString('utf-8')));
    }

HexLiteral
  // Hex float literal with fractional part: 0x1.234 or 0x1.234p+01
  // Uses proper separator pattern: no trailing underscore before '.' or 'p' exponent.
  // The ![a-zA-Z0-9_] guard prevents consuming partial tokens (e.g. 0x2_p2 → identifier).
  = "0x"i int:$([0-9a-fA-F]+("_"[0-9a-fA-F]+)*) "." frac:$([0-9a-fA-F]+("_"[0-9a-fA-F]+)*)? exp:HexExponentPart? ![a-zA-Z0-9_] {
      const cleanInt = int.replace(/_/g, '');
      const cleanFrac = (frac || '').replace(/_/g, '');
      const intVal = parseInt(cleanInt, 16);
      const fracVal = cleanFrac.length > 0 ? parseInt(cleanFrac, 16) / Math.pow(16, cleanFrac.length) : 0;
      const value = exp !== null ? (intVal + fracVal) * Math.pow(2, exp) : (intVal + fracVal);
      return loc(floatLit(value.toString()));
    }
  / "0x"i digits:$([0-9a-fA-F]+("_"[0-9a-fA-F]+)*) exp:HexExponentPart? ![a-zA-Z0-9_] {
      // Remove underscore digit separators
      const clean = digits.replace(/_/g, '');
      // Parse hex with optional exponent (e.g. 0x123p4) as float
      if (exp !== null) {
        return loc(floatLit(parseFloat(parseInt(clean, 16) * Math.pow(2, exp)).toString()));
      }
      // If significant hex digits exceed 16 (> 64 bits), overflows UInt64 → treat as Float64
      const significant = clean.replace(/^0+/, '') || '0';
      if (significant.length > 16) {
        return loc(floatLit(String(Number(BigInt('0x' + clean)))));
      }
      return loc(uintLit('0x' + clean));
    }

HexExponentPart
  = [pP] sign:$[+-]? digits:$([0-9]+("_"[0-9]+)*) { return (sign === '-' ? -1 : 1) * parseInt(digits.replace(/_/g, ''), 10); }

BinaryNumLiteral
  = "0b"i digits:$([01]+("_"[01]+)*) ![a-zA-Z0-9_] {
      // Remove underscore digit separators
      const clean = digits.replace(/_/g, '');
      return loc(uintLit('0b' + clean));
    }

// FloatLiteral: decimal float with optional underscore digit separators.
// Uses proper underscore separator pattern: digits must not start/end with _ and no double __.
// Note: "_ " in Peggy sequences is the whitespace rule; use "_" (quoted) for literal underscore.
// The ![a-zA-Z_] guard prevents partial consumption (e.g. 1e5_ must not match as 1e5).
FloatLiteral
  = "inf"i ![a-zA-Z0-9_] { return loc(floatLit('inf')); }
  / "nan"i ![a-zA-Z0-9_] { return loc(floatLit('nan')); }
  / digits:$([0-9]+("_"[0-9]+)*) "." frac:$([0-9]+("_"[0-9]+)*)? exp:ExponentPart? ![a-zA-Z_] {
      return loc(floatLit(digits.replace(/_/g, '') + '.' + (frac || '').replace(/_/g, '') + (exp || '')));
    }
  / "." digits:$([0-9]+("_"[0-9]+)*) exp:ExponentPart? ![a-zA-Z_] {
      return loc(floatLit('.' + digits.replace(/_/g, '') + (exp || '')));
    }
  / digits:$([0-9]+("_"[0-9]+)*) exp:ExponentPart ![a-zA-Z_] {
      return loc(floatLit(digits.replace(/_/g, '') + exp));
    }

// ExponentPart: e/E with optional sign and decimal digits (underscores allowed between digits).
ExponentPart
  = e:$[eE] sign:$[+-]? digits:$([0-9]+("_"[0-9]+)*) { return e + sign + digits.replace(/_/g, ''); }

// ── Lambda expressions ────────────────────────────────────────────────────────

LambdaExprNoParens
  = param:LambdaParamName _ "->" _ body:Expression {
      return loc(lambdaFn([param], body, location()));
    }

// IntervalExpr: INTERVAL expr unit - maps to toIntervalUnit(expr)
// CaseExpr: CASE expressions mapped to multiIf() or caseWithExpression()
// CASE WHEN cond THEN val ... [ELSE default] END → multiIf(cond, val, ..., default_or_null)
// CASE expr WHEN val THEN res ... [ELSE default] END → caseWithExpression(expr, val, res, ..., default_or_null)
// The no-subject form must come first so "CASE WHEN" doesn't try to parse WHEN as the subject expression
CaseExpr
  = "CASE"i ![a-zA-Z0-9_] _ branches:CaseWhenBranch+ elseClause:( _ "ELSE"i ![a-zA-Z0-9_] _ Expression )? _ "END"i ![a-zA-Z0-9_] {
      const args = [];
      for (const branch of branches) {
        args.push(branch[0]);
        args.push(branch[1]);
      }
      args.push(elseClause !== null ? elseClause[4] : loc(lit('Null', null)));
      return loc(fn('multiIf', args));
    }
  / "CASE"i ![a-zA-Z0-9_] _ subject:Expression _ branches:CaseWhenBranch+ elseClause:( _ "ELSE"i ![a-zA-Z0-9_] _ Expression )? _ "END"i ![a-zA-Z0-9_] {
      const args = [subject];
      for (const branch of branches) {
        args.push(branch[0]);
        args.push(branch[1]);
      }
      args.push(elseClause !== null ? elseClause[4] : loc(lit('Null', null)));
      return loc(fn('caseWithExpression', args));
    }

// CaseWhenBranch: a single WHEN ... THEN ... pair in a CASE expression
CaseWhenBranch
  = _ "WHEN"i ![a-zA-Z0-9_] _ cond:Expression _ "THEN"i ![a-zA-Z0-9_] _ val:Expression {
      return [cond, val];
    }

IntervalExpr
  = "INTERVAL"i ![a-zA-Z0-9_] _ expr:Expression _ unit:IntervalUnit {
      return loc(fn('toInterval' + unit, [expr]));
    }
  // INTERVAL 'N unit [N unit ...]' MySQL-compatible syntax: string containing one or more value+unit pairs
  / "INTERVAL"i ![a-zA-Z0-9_] _ str:StringLiteral {
      const parts = str.value.trim().split(/\s+/);
      const unitMap = {
        NANOSECOND: 'Nanosecond', MICROSECOND: 'Microsecond', MILLISECOND: 'Millisecond',
        SECOND: 'Second', MINUTE: 'Minute', HOUR: 'Hour', DAY: 'Day',
        WEEK: 'Week', MONTH: 'Month', QUARTER: 'Quarter', YEAR: 'Year'
      };
      const intervals = [];
      for (let i = 0; i + 1 < parts.length; i += 2) {
        const val = parseInt(parts[i], 10);
        const unitStr = (parts[i + 1] || '').toUpperCase().replace(/S$/, '');
        const unit = unitMap[unitStr] || 'Second';
        const valLit = val < 0 ? intLit(String(val)) : uintLit(String(val));
        intervals.push(loc(fn('toInterval' + unit, [loc(valLit)])));
      }
      if (intervals.length === 1) return intervals[0];
      // Multi-part interval: wrap in tuple (ClickHouse expands into
      // addTupleOfIntervals). The source `INTERVAL '...'` spelling is not
      // preserved — the formatter rebuilds the canonical tuple-syntax form
      // from the tuple's `arguments`, which reparses to an equivalent shape.
      return loc(fn('tuple', intervals, { is_operator: true }));
    }

// IntervalUnit: time unit keywords for INTERVAL expressions
// Supports full names, plurals (SECONDS, YEARS, ...), and abbreviations (s, m, h, d, w, q, y, ms, us, ns)
IntervalUnit
  = word:$([a-zA-Z_] [a-zA-Z0-9_]*) &{ return INTERVAL_UNITS[word.toLowerCase()] !== undefined; } {
      return INTERVAL_UNITS[word.toLowerCase()];
    }

// TimestampTsiUnit: IntervalUnit including SQL_TSI_ prefixed variants (all handled via INTERVAL_UNITS lookup)
TimestampTsiUnit = IntervalUnit

// ── Function calls ────────────────────────────────────────────────────────────

// DATE_ADD/DATE_SUB function name variants
DateAddName = ("DATE_ADD"i / "DATEADD"i / "TIMESTAMP_ADD"i / "TIMESTAMPADD"i) { return 'plus'; }
DateSubName = ("DATE_SUB"i / "DATESUB"i / "TIMESTAMP_SUB"i / "TIMESTAMPSUB"i) { return 'minus'; }

// DATE_ADD/DATE_SUB argument forms: (unit, amount, date) or (date, INTERVAL ...) or (INTERVAL ..., date)
DateAddSubArgs
  = unit:IntervalUnit _ "," _ amount:ExpressionWithImplicitAlias _ "," _ date:ExpressionWithImplicitAlias {
      return [date, loc(fn('toInterval' + unit, [amount]))];
    }
  / date:ExpressionWithImplicitAlias _ "," _ interval:IntervalExpr { return [date, interval]; }
  / interval:IntervalExpr _ "," _ date:ExpressionWithImplicitAlias { return [interval, date]; }

// CAST(expr AS TypeName) - special ClickHouse syntax, expr must be TernaryExpr
// to avoid greedily consuming the type name as an alias
FunctionCall
  // DATE_ADD/DATEADD/TIMESTAMP_ADD/TIMESTAMPADD — all forms → plus(date, interval)
  = name:DateAddName _ "(" _ args:DateAddSubArgs _ ")" {
      return loc(fn(name, args));
    }
  // DATE_SUB/DATESUB/TIMESTAMP_SUB/TIMESTAMPSUB — all forms → minus(date, interval)
  / name:DateSubName _ "(" _ args:DateAddSubArgs _ ")" {
      return loc(fn(name, args));
    }
  // TIMESTAMP_SUB/TIMESTAMPSUB(SQL_TSI_UNIT, amount, date) with TSI prefix unit → minus(date, toIntervalUnit(amount))
  / DateSubName _ "(" _ unit:TimestampTsiUnit _ "," _ amount:Expression _ "," _ date:Expression _ ")" {
      return loc(fn('minus', [date, loc(fn('toInterval' + unit, [amount]))]));
    }
  // dateDiff/DATEDIFF/DATE_DIFF with unquoted unit identifier as first arg → convert to canonical lowercase string literal
  / ("dateDiff"i / "DATEDIFF"i / "DATE_DIFF"i) _ "(" _ unit:$([a-zA-Z_][a-zA-Z0-9_]*) _ "," _ rest:FunctionCallArgList _ ")" {
      const unitAliases = {
        'ns': 'nanosecond', 'nanoseconds': 'nanosecond',
        'us': 'microsecond', 'microseconds': 'microsecond',
        'ms': 'millisecond', 'milliseconds': 'millisecond',
        'ss': 'second', 's': 'second', 'seconds': 'second',
        'mi': 'minute', 'n': 'minute', 'minutes': 'minute',
        'hh': 'hour', 'h': 'hour', 'hours': 'hour',
        'dd': 'day', 'd': 'day', 'days': 'day',
        'wk': 'week', 'ww': 'week', 'w': 'week', 'weeks': 'week',
        'mm': 'month', 'm': 'month', 'months': 'month',
        'qq': 'quarter', 'q': 'quarter', 'quarters': 'quarter',
        'yy': 'year', 'yyyy': 'year', 'y': 'year', 'years': 'year',
        'mcs': 'microsecond',
      };
      const lower = unit.toLowerCase();
      const canonical = unitAliases[lower] || lower;
      const unitLiteral = loc(strLit(canonical));
      return loc(fn('dateDiff', [unitLiteral, ...rest]));
    }
  // dateDiff/DATEDIFF/DATE_DIFF with quoted string unit (normalize function name to dateDiff)
  / ("dateDiff"i / "DATEDIFF"i / "DATE_DIFF"i) _ "(" _ args:FunctionCallArgList _ ")" {
      return loc(fn('dateDiff', args));
    }
  // SUBSTRING(str FROM pos [FOR len]) — SQL standard substring syntax
  / ( "SUBSTRING"i / "SUBSTR"i / "MID"i ) _ "(" _ str:ExpressionWithImplicitAlias _ "FROM"i ![a-zA-Z0-9_] _ pos:ExpressionWithImplicitAlias len:( _ "FOR"i ![a-zA-Z0-9_] _ ExpressionWithImplicitAlias )? _ ")" {
      const args = [str, pos];
      if (len !== null) args.push(len[4]);
      return loc(fn('substring', args));
    }
  // EXTRACT(unit FROM expr) — SQL standard date/time extraction
  // Supports implicit alias on expr (ClickHouse extension)
  / "EXTRACT"i _ "(" _ unit:ExtractUnit _ "FROM"i ![a-zA-Z0-9_] _ expr:ExpressionWithImplicitAlias _ ")" {
      const funcMap = {
        YEAR: 'toYear', MONTH: 'toMonth', DAY: 'toDayOfMonth',
        HOUR: 'toHour', MINUTE: 'toMinute', SECOND: 'toSecond',
        DOW: 'toDayOfWeek', DOY: 'toDayOfYear', EPOCH: 'toUnixTimestamp',
        WEEK: 'toWeek', QUARTER: 'toQuarter', MICROSECOND: 'toMicrosecond',
        MILLISECOND: 'toMillisecond', CENTURY: 'toCentury', ISOYEAR: 'toISOYear',
        ISOWEEK: 'toISOWeek', TIMEZONE_HOUR: 'timezoneHour', TIMEZONE_MINUTE: 'timezoneMinute',
        YYYY: 'toYear', MM: 'toMonth', DD: 'toDayOfMonth', HH: 'toHour',
        MI: 'toMinute', SS: 'toSecond'
      };
      const funcName = funcMap[unit.toUpperCase()] || ('to' + unit.charAt(0).toUpperCase() + unit.slice(1).toLowerCase());
      return loc(fn(funcName, [expr]));
    }
  / "TRIM"i _ "(" _ direction:TrimDirection _ chars:ExpressionWithImplicitAlias _ "FROM"i ![a-zA-Z0-9_] _ str:ExpressionWithImplicitAlias _ ")" {
      // ClickHouse simplifies TRIM with empty string to just the expression
      if (chars.type === 'Literal' && chars.value_type === 'String' && chars.value === '') {
        return str;
      }
      const fname = direction === 'LEADING' ? 'trimLeft' : (direction === 'TRAILING' ? 'trimRight' : 'trimBoth');
      return loc(fn(fname, [str, chars]));
    }
  // POSITION(needle IN haystack) — SQL standard POSITION syntax; maps to position(haystack, needle)
  // Uses AddExpr for needle to prevent consuming IN as part of the expression
  / "POSITION"i _ "(" _ needle:AddExpr _ "IN"i ![a-zA-Z0-9_] _ haystack:ExpressionWithImplicitAlias _ ")" {
      return loc(fn('position', [haystack, needle]));
    }
  // SQL-standard typed date/time literals: DATE 'string' → toDate('string'), etc.
  / "DATE"i ![a-zA-Z0-9_] _ str:StringLiteral {
      return loc(fn('toDate', [str]));
    }
  / "TIMESTAMP"i ![a-zA-Z0-9_] _ str:StringLiteral {
      return loc(fn('toDateTime', [str]));
    }
  / "TIME"i ![a-zA-Z0-9_] _ str:StringLiteral {
      return loc(fn('toTime', [str]));
    }
  // CAST(expr AS Type) — SQL standard type cast. Also supports aliased form: CAST(expr AS alias AS Type)
  // The alias lookahead (&(KW_AS)) ensures we don't consume the final type name as an alias.
  // e.g. CAST(1 AS Int32), CAST(x AS y AS String)
  / "CAST"i _ "(" _ expr:TernaryExpr alias:( _ ( KW_AS _ )? name:AliasName &( _ KW_AS ) { return name; } )? _ KW_AS _ type:ClickHouseType _ ")" {
      const innerExpr = alias !== null ? loc(applyAlias(expr, alias)) : expr;
      // Case variants (`Cast`, `cast`, ...) canonicalize to `CAST`; the
      // source-case is not preserved.
      return loc(fn('CAST', [innerExpr, loc(typeLit(type))]));
    }
  // Generic function call: name([DISTINCT|ALL] args [SETTINGS ...])[(params)]? [FILTER(WHERE ...)]?
  // DISTINCT modifier appends "Distinct" to function name: countDistinct, sumDistinct, etc.
  // Curried form f(params)(args) is used by parametric aggregates: quantile(0.5)(x)
  // FILTER(WHERE cond) transforms f(args) → fIf(args, cond) (SQL standard aggregate filter)
  // The !(")" / ",") guard after DISTINCT/ALL prevents them from being consumed as modifiers
  // when they're actually arguments: has(Settings, 'x') or func(DISTINCT) where DISTINCT is a value.
  / name:FunctionName _ "(" openComments:_ modifier:( ( KW_DISTINCT / KW_ALL ) !( _ ( ")" / "," ) ) _ )? first:FunctionCallArgList? funcSettings:( _ KW_SETTINGS _ SettingsList )? _ ")" second:( _ "(" _ ( ( KW_DISTINCT / KW_ALL ) !( _ ( ")" / "," ) ) _ )? FunctionCallArgList? _ ")" )? filter:FilterClause? {
      const modVal = modifier !== null ? modifier[0] : null;
      const modStr = Array.isArray(modVal) ? modVal[0] : modVal;
      const isDistinct = modStr !== null && modStr !== undefined && modStr.toString().toUpperCase() === 'DISTINCT';
      let effectiveName = isDistinct ? name + 'Distinct' : name;
      // Attach comments between "(" and first arg as leadingComments on first arg
      let args1 = first || [];
      const oc = flattenWs(openComments);
      if (oc.length > 0 && args1.length > 0) {
        args1 = args1.slice();
        args1[0] = addLeading(args1[0], oc);
      }
      // COLUMNS('regex') / COLUMNS(a, b) without qualifier or transformers still
      // serialize as matcher nodes, not function calls.
      if (name.toUpperCase() === 'COLUMNS' && modifier === null && funcSettings === null && second === null && filter === null) {
        const isRegex = args1.length === 1 && args1[0].type === 'Literal' && args1[0].value_type === 'String';
        if (isRegex) {
          return loc({ type: 'ColumnsRegexpMatcher', pattern: args1[0].value });
        }
        return loc({ type: 'ColumnsListMatcher', columns: args1 });
      }
      // Normalize function-name aliases the way ClickHouse does. The source
      // spelling is not preserved: alias and case variants canonicalize to
      // the canonical spelling at format time (e.g. `ltrim` → `trimLeft`,
      // `Cast` → `CAST`, `EXISTS` → `exists`).
      const canonical = FUNC_ALIASES[effectiveName.toLowerCase()];
      if (canonical !== undefined) {
        effectiveName = canonical;
      }
      let extraFlags;
      if (
        effectiveName.toLowerCase() === 'exists' &&
        args1.length === 1 &&
        args1[0] !== null &&
        args1[0].type === 'Subquery'
      ) {
        extraFlags = { is_operator: true };
      }
      let call;
      if (second !== null) {
        // second[3] = modifier2 group, second[4] = FunctionCallArgList?
        const mod2 = second[3];
        const mod2Val = mod2 !== null ? mod2[0] : null;
        const mod2Str = Array.isArray(mod2Val) ? mod2Val[0] : mod2Val;
        const isDistinct2 = mod2Str !== null && mod2Str !== undefined && mod2Str.toString().toUpperCase() === 'DISTINCT';
        const curryName = isDistinct2 ? effectiveName + 'Distinct' : effectiveName;
        call = loc(fn(curryName, second[4] || [], { parameters: args1 }));
      } else {
        call = loc(fn(effectiveName, args1, extraFlags));
      }
      if (funcSettings !== null) call.arguments = [...call.arguments, loc(setNode(funcSettings[3]))];
      if (filter !== null) {
        // count(*) FILTER (WHERE cond) → countIf(cond): drop the asterisk arg
        const filterArgs = (call.arguments.length === 1 && call.arguments[0].type === 'Asterisk' && call.arguments[0].expression === undefined)
          ? [] : call.arguments;
        call = loc(fn(call.name + 'If', [...filterArgs, filter]));
      }
      return call;
    }

// ExtractUnit: the date/time unit identifier in EXTRACT(unit FROM expr)
ExtractUnit
  = unit:$([a-zA-Z_][a-zA-Z0-9_]*) { return unit; }

// TrimDirection: LEADING, TRAILING, or BOTH for TRIM function syntax
TrimDirection
  = "LEADING"i  ![a-zA-Z0-9_] { return 'LEADING'; }
  / "TRAILING"i ![a-zA-Z0-9_] { return 'TRAILING'; }
  / "BOTH"i     ![a-zA-Z0-9_] { return 'BOTH'; }

// FilterClause: FILTER(WHERE expr) postfix on aggregate functions
// Transforms funcName(args) into funcNameIf(args..., condition)
FilterClause
  = _ "FILTER"i _ "(" _ "WHERE"i ![a-zA-Z0-9_] _ expr:Expression _ ")" { return expr; }

// FunctionName: like Identifier but allows reserved keywords and digit-prefixed names
// Function calls are disambiguated by the required "(" that follows the name.
FunctionName
  = head:[a-zA-Z_] tail:[a-zA-Z0-9_]* { return head + tail.join(""); }
  / head:[0-9] tail:[a-zA-Z0-9_]* { return head + tail.join(""); }
  / '"' chars:DoubleQuotedChar* '"' { return chars.join(""); }
  / '`' chars:BacktickChar* '`' { return chars.join(""); }

// FunctionCallArgGuarded: like FunctionCallArg but prevents SETTINGS keyword from being consumed as a column
// ref when it is starting a settings clause (SETTINGS identifier = value). This allows:
//   f(SETTINGS x=1)     → SETTINGS is a clause keyword
//   has(Settings, 'x')  → Settings is an identifier (map)
//   Settings['key']     → Settings is a map with subscript access
FunctionCallArgGuarded
  = !( KW_SETTINGS _ [a-zA-Z_][a-zA-Z0-9_]* _ "=" ) arg:FunctionCallArg { return arg; }

// FunctionCallArgList supports multi-param lambdas written without parens:
// e.g. arrayFold(acc, x -> acc + x, [...], init)
// The multi-param lambda consumes all leading identifiers up to the "->".
// Trailing comma is allowed (e.g. if(a, b, c,) — ClickHouse extension).
FunctionCallArgList
  = head:FunctionCallArgGuarded tail:(_ "," _ FunctionCallArgGuarded)* ( _ "," )? {
      return buildCommaList(head, tail);
    }

FunctionCallArg
  = params:MultiLambdaParams _ "->" _ body:Expression {
      return loc(lambdaFn(params, body, location()));
    }
  / &(KW_SELECT / KW_WITH) query:UnionQuery {
      return loc({ type: 'Subquery', query: query });
    }
  // Support implicit aliases in function args: f(expr alias, ...) — ClickHouse extension
  / ExpressionWithImplicitAlias
  // Allow keywords as column name identifiers in function args (e.g. sum(DISTINCT), repeat(ALL, 5))
  / name:AliasName &(_ (")" / ",")) { return loc(ident([name])); }

// Matches two or more comma-separated identifiers before "->".
// The final identifier uses a lookahead to confirm "->" follows.
MultiLambdaParams
  = head:LambdaParamName _ "," _ tail:MultiLambdaParamsTail {
      return [head, ...tail];
    }

MultiLambdaParamsTail
  = name:LambdaParamName _ "," _ rest:MultiLambdaParamsTail {
      return [name, ...rest];
    }
  / name:LambdaParamName &(_ "->") {
      return [name];
    }

ColumnRef
  // Qualified function call: a.b(args) — compound identifier used as function name (e.g. lambda.nested(1))
  = first:ColumnRefFirst rest:( _ "." _ part:ColumnRefCont { return part; } )+ _ "(" _ args:FunctionCallArgList? _ ")" {
      const name = [first, ...rest].join('.');
      return loc(fn(name, args !== null ? args : []));
    }
  // Multi-part qualified name: first.second[.third...] — supports arbitrary nesting depth.
  // e.g. t.col, system.one.dummy, nested.nest.a.b.c (JSON subcolumns).
  // Also supports digit-prefixed identifiers (e.g. 02337_db.table.col),
  // QueryParam identifiers (e.g. {DB:Identifier}.table),
  // JSON object subcolumn ^ prefix (e.g. json.^a), and array subscript suffix (e.g. arr.k1[]).
  / first:ColumnRefFirst rest:( _ "." _ part:ColumnRefCont { return part; } )+ {
      return loc(ident([first, ...rest]));
    }
  // Unqualified: plain identifier (keyword-guarded) or digit-prefixed identifier
  / name:Identifier { return loc(ident([name])); }
  / name:$([0-9][a-zA-Z0-9_$]+) { return loc(ident([name])); }

// First part of a column ref: regular identifier, QueryParam-as-identifier, digit-prefixed identifier,
// or any AliasName (allows reserved keywords as table-alias qualifiers like "join.n")
ColumnRefFirst
  = Identifier
  / QueryParamIdentifier
  / $([0-9][a-zA-Z0-9_$]+)
  / AliasName

// Continuation part of a column ref path (after a ".")
// Guards: not digit (tuple element access .1 handled by PrimaryExprSuffix), not ":" (json subcolumn .: handled separately), not "*" (qualified asterisk)
// Supports: ^name (JSON object subcolumn), name[] (JSON array subcolumn), regular identifiers
ColumnRefCont
  = !([0-9:*]) "^" name:AliasName brackets:("[]")? { return "^" + name + (brackets !== null ? "[]" : ""); }
  / !([0-9:*]) name:AliasName brackets:("[]")? { return name + (brackets !== null ? "[]" : ""); }

// QualifiedAsterisk: one or more qualifiers followed by .* (e.g. t.*, system.one.*, {DB:Identifier}.tbl.*)
// Optionally followed by column transformers (EXCEPT, APPLY, REPLACE).
// The ![0-9*] guard on rest parts prevents consuming .* or numeric suffixes as qualifier parts.
// Supports QueryParamIdentifier and digit-prefixed identifiers (e.g. 02339_db.test_table.*) as the first qualifier.
QualifiedAsterisk
  = first:ColumnRefFirst rest:( _ "." _ ![*] part:Identifier { return part; } )* _ "." _ "*"
    transformers:( _ ColumnTransformer )* {
      const result = loc({ type: 'QualifiedAsterisk', qualifier: loc(ident([first, ...rest])) });
      if (transformers.length > 0) {
        result.transformers = transformers.map((t) => t[1]);
      }
      return result;
    }

// Asterisk optionally followed by column transformers (EXCEPT, APPLY, REPLACE).
Asterisk
  = "*" transformers:( _ ColumnTransformer )* {
      const result = loc({ type: 'Asterisk' });
      if (transformers.length > 0) {
        result.transformers = transformers.map((t) => t[1]);
      }
      return result;
    }

// ColumnTransformer: modifier applied to * or qualifier.* — EXCEPT, APPLY, or REPLACE.
ColumnTransformer
  = ColumnTransformerExcept
  / ColumnTransformerApply
  / ColumnTransformerReplace

// EXCEPT column transformer: removes named columns from the asterisk expansion.
// Supports: EXCEPT (col, ...), EXCEPT col, EXCEPT 'pattern', EXCEPT ('pattern'), EXCEPT STRICT (col, ...), EXCEPT STRICT col
ColumnTransformerExcept
  = "EXCEPT"i ![a-zA-Z0-9_] _ "STRICT"i ![a-zA-Z0-9_] _ "(" _ cols:ColumnTransformerExceptList _ ")" {
      return exceptTransformer(cols, true, location());
    }
  / "EXCEPT"i ![a-zA-Z0-9_] _ "STRICT"i ![a-zA-Z0-9_] _ col:Identifier {
      return exceptTransformer([col], true, location());
    }
  / "EXCEPT"i ![a-zA-Z0-9_] _ "(" _ cols:ColumnTransformerExceptList _ ")" {
      return exceptTransformer(cols, false, location());
    }
  // EXCEPT with string pattern in parens: EXCEPT('regex') — regex-based column exclusion
  / "EXCEPT"i ![a-zA-Z0-9_] _ "(" _ str:StringLiteral _ ")" {
      return loc({ type: 'ColumnsExceptTransformer', pattern: str.value });
    }
  / "EXCEPT"i ![a-zA-Z0-9_] _ str:StringLiteral {
      return loc({ type: 'ColumnsExceptTransformer', pattern: str.value });
    }
  // EXCEPT bare column name without parens: EXCEPT col
  / "EXCEPT"i ![a-zA-Z0-9_] _ col:Identifier {
      return exceptTransformer([col], false, location());
    }

// List of column names (identifiers or backtick-quoted) for EXCEPT transformer
ColumnTransformerExceptList
  = head:Identifier tail:( _ "," _ Identifier )* {
      return [head, ...tail.map((t) => t[3])];
    }

// APPLY column transformer: applies a function to each matched column.
// Supports: APPLY(func), APPLY(lambda), APPLY name, APPLY lambda
ColumnTransformerApply
  = "APPLY"i ![a-zA-Z0-9_] _ "(" _ func:FunctionCallArg _ ")" {
      return applyTransformer(func, location());
    }
  / "APPLY"i ![a-zA-Z0-9_] _ func:LambdaExprNoParens {
      return applyTransformer(func, location());
    }
  // APPLY with a function call (e.g. APPLY lambda(tuple(x), x+1) — using lambda() builtin)
  / "APPLY"i ![a-zA-Z0-9_] _ func:FunctionCall {
      return applyTransformer(func, location());
    }
  / "APPLY"i ![a-zA-Z0-9_] _ name:Identifier {
      return applyTransformer(loc(ident([name])), location());
    }

// REPLACE column transformer: replaces column values with expressions.
// Supports: REPLACE(expr AS col, ...), REPLACE STRICT(expr AS col, ...), REPLACE expr AS col
ColumnTransformerReplace
  = "REPLACE"i ![a-zA-Z0-9_] _ "STRICT"i ![a-zA-Z0-9_] _ "(" _ items:ReplaceItemList _ ")" {
      return replaceTransformer(items, true, location());
    }
  / "REPLACE"i ![a-zA-Z0-9_] _ "STRICT"i ![a-zA-Z0-9_] _ item:ReplaceItem {
      return replaceTransformer([item], true, location());
    }
  / "REPLACE"i ![a-zA-Z0-9_] _ "(" _ items:ReplaceItemList _ ")" {
      return replaceTransformer(items, false, location());
    }
  / "REPLACE"i ![a-zA-Z0-9_] _ item:ReplaceItem {
      return replaceTransformer([item], false, location());
    }

ReplaceItemList
  = head:ReplaceItem tail:( _ "," _ ReplaceItem )* {
      return [head, ...tail.map((t) => t[3])];
    }

// Single REPLACE item: expr AS colName
ReplaceItem
  = expr:TernaryExpr _ KW_AS _ alias:Identifier {
      return { expr, alias };
    }

// COLUMNS expression: COLUMNS(args) optionally preceded by a table qualifier and optionally followed by transformers.
// Without transformers or qualifier, COLUMNS(...) falls through to FunctionCall (preserving original casing).
// With transformers or qualifier (APPLY, EXCEPT, REPLACE, or table.COLUMNS(...)), it becomes a ColumnsExpr node.
// Qualifier can be a multi-part path (e.g. db.table.COLUMNS('^c'), 02339_db.test_table.COLUMNS(id)).
ColumnsExpr
  // [db.]table.COLUMNS(args) — table-qualified columns expression, e.g. t.COLUMNS('^c'), db.tbl.COLUMNS('^c')
  // Uses ColumnRefFirst for the first part to support digit-prefixed identifiers and QueryParamIdentifiers.
  = first:ColumnRefFirst rest:( _ "." _ !( "COLUMNS"i _ "(" ) part:ColumnRefCont { return part; } )* _ "." _ "COLUMNS"i _ "(" _ args:FunctionCallArgList _ ")" transformers:( _ ColumnTransformer )* {
      const qualifier = loc(ident([first, ...rest]));
      const isRegex = args.length === 1 && args[0].type === 'Literal' && args[0].value_type === 'String';
      // Qualified COLUMNS matchers wrap their transformers in a
      // ColumnsTransformerList node (per ClickHouse's native AST).
      const tListNode = transformers.length > 0
        ? loc({ type: 'ColumnsTransformerList', children: transformers.map((t) => t[1]) })
        : undefined;
      if (isRegex) {
        const node = { type: 'QualifiedColumnsRegexpMatcher', pattern: args[0].value, qualifier };
        if (tListNode) node.transformers = tListNode;
        return loc(node);
      }
      const node = { type: 'QualifiedColumnsListMatcher', qualifier, columns: args };
      if (tListNode) node.transformers = tListNode;
      return loc(node);
    }
  / "COLUMNS"i _ "(" _ args:FunctionCallArgList _ ")" _ head:ColumnTransformer rest:( _ ColumnTransformer )* {
      // Plain (unqualified) COLUMNS matchers serialize transformers as a flat
      // array, NOT as a ColumnsTransformerList node (per ClickHouse's native AST).
      const tList = [head, ...rest.map((t) => t[1])];
      const isRegex = args.length === 1 && args[0].type === 'Literal' && args[0].value_type === 'String';
      if (isRegex) {
        return loc({ type: 'ColumnsRegexpMatcher', pattern: args[0].value, transformers: tList });
      }
      return loc({ type: 'ColumnsListMatcher', columns: args, transformers: tList });
    }

// ── Literals & identifiers ────────────────────────────────────────────────────

// IntegerLiteral supports underscore digit separators (e.g., 1_000_000).
// Uses proper separator pattern: no leading/trailing _ and no double __.
// Removes underscores and leading zeros for normalization.
// Values exceeding UInt64 max (18446744073709551615) become Float64.
// The ![a-zA-Z_] guard prevents consuming the digit prefix of digit-prefixed identifiers like 02337_db.
IntegerLiteral
  = digits:$([0-9]+("_"[0-9]+)*) ![a-zA-Z_] {
      const normalized = digits.replace(/_/g, '').replace(/^0+/, '') || '0';
      const UINT64_MAX = BigInt('18446744073709551615');
      if (normalized.length > 20 || (normalized.length >= 20 && BigInt(normalized) > UINT64_MAX)) {
        // Keep original string to preserve precision for CAST contexts
        return loc(floatLit(normalized));
      }
      return loc(uintLit(normalized));
    }

// StringLiteral: decodes hex escape sequences as UTF-8 bytes (collecting consecutive \xNN
// sequences and decoding them together to handle multi-byte UTF-8 characters like \xD0\xA0 → 'Р').
StringLiteral
  // Unicode left/right single quotes (no escape processing - backslashes stored doubled)
  = "\u2018" chars:UnicodeQuoteChar* "\u2019" {
      return loc(strLit(chars.join('')));
    }
  / "'" chars:StringChar* "'" {
      // Collect consecutive hex byte objects and decode as UTF-8
      const parts = [];
      let hexBuf = [];
      for (const c of chars) {
        if (c !== null && typeof c === 'object' && c.hexByte !== undefined) {
          hexBuf.push(c.hexByte);
        } else {
          if (hexBuf.length > 0) {
            parts.push(new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(hexBuf)));
            hexBuf = [];
          }
          parts.push(c);
        }
      }
      if (hexBuf.length > 0) {
        parts.push(new TextDecoder('utf-8', { fatal: false }).decode(new Uint8Array(hexBuf)));
      }
      return loc(strLit(parts.join('')));
    }

// StringChar: processes escape sequences inside single-quoted strings.
// \a and \v are decoded to control characters; \x hex escapes return a raw byte object
// (collected and UTF-8 decoded by StringLiteral).
// Other recognized escapes (\b \f \n \r \t \0 \\ \' \") are stored as two-char sequences
// (preserving the backslash) so that explain output can re-escape them correctly.
// Unrecognized escapes before a word character [a-zA-Z_] keep the backslash (stored as
// two backslashes + char, matching ClickHouse behavior). Other unrecognized escapes drop it.
StringChar
  = "''" { return "'"; }
  / "\\a" { return '\x07'; }
  / "\\e" { return '\x1b'; }
  / "\\v" { return '\x0b'; }
  / "\\\\" { return '\\'; }
  / "\\b" { return '\b'; }
  / "\\f" { return '\f'; }
  / "\\n" { return '\n'; }
  / "\\r" { return '\r'; }
  / "\\t" { return '\t'; }
  / "\\0" { return '\0'; }
  / "\\'" { return "'"; }
  / '\\"' { return '"'; }
  / "\\x" hi:[0-9a-fA-F] lo:[0-9a-fA-F] {
      return { hexByte: parseInt(hi + lo, 16) };
    }
  / "\\" c:[a-zA-Z_] { return '\\' + c; }
  / "\\" c:. { return '\\' + c; }
  / [^'\\] { return text(); }

// UnicodeQuoteChar: characters inside Unicode-quoted strings (no escape processing).
// Backslashes are doubled so that escapeStringValue in explain.ts produces correct output.
// Exception: backslash immediately before the closing \u2019 is discarded (ClickHouse behavior).
UnicodeQuoteChar
  = "\\" &"\u2019" { return '\\'; }
  / "\\" { return '\\'; }
  / !"\u2019" c:. { return c; }

// QueryParamIdentifier: a query parameter substituted as an identifier at runtime
// e.g. {CLICKHOUSE_DATABASE:Identifier} used in FROM {DB:Identifier}.tablename
QueryParamIdentifier
  = "{" _ name:$[a-zA-Z0-9_]+ _ ":" _ "Identifier"i ![a-zA-Z0-9_] _ "}" {
      return loc({ type: 'QueryParameter', name: name, param_type: 'Identifier' });
    }

TableRef
  = db:( QueryParamIdentifier / AliasName ) _ "." _ table:( QueryParamIdentifier / AliasName ) {
      return loc({ kind: 'tableRef', database: db, table: table });
    }
  / table:( QueryParamIdentifier / AliasName ) {
      return loc({ kind: 'tableRef', table: table });
    }

// Identifier: bare word (not a keyword) or quoted identifier
Identifier
  = word:$([a-zA-Z_] [a-zA-Z0-9_]*) &{ return !KEYWORDS.has(word.toUpperCase()); } { return word; }
  / '"' chars:DoubleQuotedChar* '"' { return chars.join(""); }
  / '`' chars:BacktickChar* '`' { return chars.join(""); }
  // Unicode "smart quotes": \u201c...\u201d (left/right double quotation marks)
  / "\u201c" chars:$(!"\u201d" .)* "\u201d" { return chars; }

// LambdaParamName: like Identifier but allows reserved keywords (e.g. offset, limit),
// since lambda parameters are just variable names that can shadow keywords
LambdaParamName
  = word:$([a-zA-Z_] [a-zA-Z0-9_]*) { return word; }
  / '"' chars:DoubleQuotedChar* '"' { return chars.join(""); }
  / '`' chars:BacktickChar* '`' { return chars.join(""); }
  / "\u201c" chars:$(!"\u201d" .)* "\u201d" { return chars; }

// AliasName: like Identifier but allows reserved keywords (e.g. AS AND, AS OR),
// also allows dollar signs and digit-starting identifiers (ClickHouse extension)
AliasName
  = head:[a-zA-Z_$] tail:[a-zA-Z0-9_$]* { return head + tail.join(""); }
  / head:[0-9] tail:[a-zA-Z0-9_$]* { return head + tail.join(""); }
  / '"' chars:DoubleQuotedChar* '"' { return chars.join(""); }
  / '`' chars:BacktickChar* '`' { return chars.join(""); }
  / "\u201c" chars:$(!"\u201d" .)* "\u201d" { return chars; }

DoubleQuotedChar
  = '""' { return '"'; }
  / '\\"' { return '"'; }
  / '\\\\' { return '\\'; }
  / '\\' c:. { return '\\' + c; }
  / [^"\\] { return text(); }

BacktickChar
  = '``' { return '`'; }
  // Hex escape: \xNN → byte decoded as UTF-8 (invalid bytes become U+FFFD)
  / '\\x' hex:$([0-9a-fA-F][0-9a-fA-F]) { return Buffer.from([parseInt(hex, 16)]).toString('utf8'); }
  // Recognized C-style escapes decode to their control character (matching the
  // string-literal escape table ClickHouse also applies inside backtick identifiers).
  / '\\0' { return '\0'; }
  / '\\a' { return '\x07'; }
  / '\\e' { return '\x1b'; }
  / '\\v' { return '\x0b'; }
  / '\\b' { return '\b'; }
  / '\\f' { return '\f'; }
  / '\\n' { return '\n'; }
  / '\\r' { return '\r'; }
  / '\\t' { return '\t'; }
  / '\\\\' { return '\\'; }
  / "\\'" { return "'"; }
  / '\\"' { return '"'; }
  / '\\`' { return '`'; }
  // Unrecognized escape (e.g. `\_`): keep the backslash verbatim, as ClickHouse does.
  / '\\' char:. { return '\\' + char; }
  / [^`\\] { return text(); }

// ── Keywords (must not be followed by an alphanumeric/underscore) ─────────────

// Keyword: matches any reserved keyword (word boundary enforced)
Keyword
  = word:$([a-zA-Z_] [a-zA-Z0-9_]*) &{ return KEYWORDS.has(word.toUpperCase()); }

KW_WITH      = "WITH"i      ![a-zA-Z0-9_]
KW_AS        = "AS"i        ![a-zA-Z0-9_]
KW_SELECT    = "SELECT"i    ![a-zA-Z0-9_]
KW_FROM      = "FROM"i      ![a-zA-Z0-9_]
KW_PREWHERE  = "PREWHERE"i  ![a-zA-Z0-9_]
KW_WHERE     = "WHERE"i     ![a-zA-Z0-9_]
KW_GROUP     = "GROUP"i     ![a-zA-Z0-9_]
KW_ORDER     = "ORDER"i     ![a-zA-Z0-9_]
KW_BY        = "BY"i        ![a-zA-Z0-9_]
KW_HAVING    = "HAVING"i    ![a-zA-Z0-9_]
KW_LIMIT     = "LIMIT"i     ![a-zA-Z0-9_]
KW_OFFSET    = "OFFSET"i    ![a-zA-Z0-9_]
KW_AND       = "AND"i       ![a-zA-Z0-9_]
KW_OR        = "OR"i        ![a-zA-Z0-9_]
KW_ASC       = s:"ASC"i     ![a-zA-Z0-9_] { return s; }
KW_DESC      = s:"DESC"i    ![a-zA-Z0-9_] { return s; }
KW_IN        = "IN"i        ![a-zA-Z0-9_]
KW_NOT       = "NOT"i       ![a-zA-Z0-9_]
KW_DISTINCT  = "DISTINCT"i  ![a-zA-Z0-9_]
KW_FINAL     = "FINAL"i     ![a-zA-Z0-9_]
KW_JOIN      = "JOIN"i      ![a-zA-Z0-9_]
KW_INNER     = "INNER"i     ![a-zA-Z0-9_]
KW_LEFT      = "LEFT"i      ![a-zA-Z0-9_]
KW_RIGHT     = "RIGHT"i     ![a-zA-Z0-9_]
KW_FULL      = "FULL"i      ![a-zA-Z0-9_]
KW_CROSS     = "CROSS"i     ![a-zA-Z0-9_]
KW_OUTER     = "OUTER"i     ![a-zA-Z0-9_]
KW_ARRAY     = "ARRAY"i     ![a-zA-Z0-9_]
KW_ON        = "ON"i        ![a-zA-Z0-9_]
KW_USING     = "USING"i     ![a-zA-Z0-9_]
KW_SETTINGS  = "SETTINGS"i  ![a-zA-Z0-9_]
KW_TOTALS    = "TOTALS"i    ![a-zA-Z0-9_]
KW_ALL       = "ALL"i       ![a-zA-Z0-9_]
KW_ANY       = "ANY"i       ![a-zA-Z0-9_]
KW_SEMI      = "SEMI"i      ![a-zA-Z0-9_]
KW_ANTI      = "ANTI"i      ![a-zA-Z0-9_]
KW_ASOF      = "ASOF"i      ![a-zA-Z0-9_]
KW_GLOBAL    = "GLOBAL"i    ![a-zA-Z0-9_]
KW_UNION     = "UNION"i     ![a-zA-Z0-9_]
KW_LIKE      = "LIKE"i      ![a-zA-Z0-9_]
KW_ILIKE     = "ILIKE"i     ![a-zA-Z0-9_]
KW_BETWEEN   = "BETWEEN"i   ![a-zA-Z0-9_]
KW_FORMAT    = "FORMAT"i    ![a-zA-Z0-9_]
KW_WINDOW    = "WINDOW"i    ![a-zA-Z0-9_]

// Whitespace rule: matches zero or more whitespace characters and comments.
// Returns { trailing: string[], leading: string[] } where:
//   trailing = comments on the same line as the preceding token (before any newline)
//   leading  = comments after a newline (on their own line or leading the next token)
// Use flattenWs(ws) to get all comments as a flat array.
_ "whitespace"
  = trailing:_HWS newlineContent:_NLC* {
      const leading = [];
      for (const nc of newlineContent) {
        for (const item of nc) {
          if (item !== null) leading.push(item);
        }
      }
      return { trailing, leading };
    }

// Horizontal whitespace + comments (no newlines consumed)
_HWS
  = items:([ \t\u0085\u00A0\u00AD\u034F\u061C\u115F\u1160\u17B4\u17B5\u180E\u2000-\u200F\u2028\u2029\u202A-\u202F\u205F\u2060-\u2064\u206A-\u206F\u3000\u3164\uFEFF\uFFA0]+ { return null; } / SingleLineComment / MultiLineComment)* {
      return items.filter((item) => item !== null);
    }

// Newline(s) followed by optional horizontal whitespace + comments
_NLC
  = [\n\r]+ items:([ \t\u0085\u00A0\u00AD\u034F\u061C\u115F\u1160\u17B4\u17B5\u180E\u2000-\u200F\u2028\u2029\u202A-\u202F\u205F\u2060-\u2064\u206A-\u206F\u3000\u3164\uFEFF\uFFA0]+ { return null; } / SingleLineComment / MultiLineComment)* {
      return items;
    }

SingleLineComment
  // Supports --, #!, #<space>, and // comment styles (all used in ClickHouse SQL files)
  = ("--" / "#!" / "# " / "//") (![\n] .)* { return text(); }

// MultiLineComment supports nested block comments: /* ... /* ... */ ... */
MultiLineComment
  = "/*" MultiLineCommentContent* "*/" { return text(); }

MultiLineCommentContent
  = MultiLineComment
  / !"*/" . { return text(); }
