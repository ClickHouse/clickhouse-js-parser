# @clickhouse/parser

A TypeScript parser for ClickHouse SQL. Parses ClickHouse SQL into a typed AST, with support for formatting back to SQL.

Explore the parser output in the [playground](https://clickhouse.github.io/clickhouse-js-parser/).

**Note:** This is alpha-level Claudeware. The API and AST formats are subject to change.

## Installation

```bash
npm install @clickhouse/parser
```

## Usage

### Parsing SQL to AST

```typescript
import { parse } from '@clickhouse/parser';

const ast = parse('SELECT id, name FROM users WHERE active = 1 ORDER BY name');
```

`parse()` accepts a string containing one or more ClickHouse SQL statements (semicolon-separated) and returns a `Statement[]` array.

The AST for the query above:

```json
[
  {
    "type": "SelectWithUnionQuery",
    "selects": [
      {
        "type": "SelectQuery",
        "select": [
          { "type": "Identifier", "name": "id" },
          { "type": "Identifier", "name": "name" }
        ],
        "from": {
          "type": "TablesInSelectQuery",
          "children": [
            {
              "type": "TablesInSelectQueryElement",
              "table_expression": {
                "type": "TableExpression",
                "database_and_table_name": {
                  "type": "TableIdentifier",
                  "name": "users"
                }
              }
            }
          ]
        },
        "where": {
          "type": "Function",
          "name": "equals",
          "arguments": [
            { "type": "Identifier", "name": "active" },
            { "type": "Literal", "value_type": "UInt64", "value": "1" }
          ],
          "is_operator": true
        },
        "order_by": [
          {
            "type": "OrderByElement",
            "expression": { "type": "Identifier", "name": "name" },
            "direction": "ASC"
          }
        ]
      }
    ]
  }
]
```

Each node has a `type` discriminator field that mirrors ClickHouse's native AST.
See [ast.ts](src/ast.ts) for all node types and their Zod schemas.

#### Parse options

`parse()` accepts an optional second argument:

```typescript
parse(sql, {
  // Attach a `location` (line/column/offset source range) to every node.
  // Set to false for a leaner, fully JSON-serializable AST. Default: true.
  locations: true,

  // Set a `parent` reference on every node. This introduces circular
  // references, which break `JSON.stringify`. Default: false.
  setParents: false,
});
```

With locations enabled (the default) **every** AST node carries a `location`, so
it is a **required** property — no `| undefined`, no `!`:

```typescript
const ast = parse(sql); // Statement[]
ast[0].location.start.offset; // ✓ SourceLocation (always present)
```

When `locations: false` is passed as a literal, `parse()` returns
`WithoutLocations<Statement>[]` — a type with `location` recursively removed, so
reading `.location` is a compile-time error:

```typescript
const ast = parse(sql, { locations: false });
ast[0].location; // ✗ type error: property does not exist
```

The AST-consuming functions — `format`, `formatExplain`, `formatNode`, and
`transformNodes` — accept `WithoutLocations<…>` inputs. Because a located AST is
assignable to its location-free counterpart, they transparently accept ASTs both
with and without locations.

### Formatting AST back to SQL

```typescript
import { parse, format } from '@clickhouse/parser';

const ast = parse('SELECT id, name FROM users WHERE active = 1 ORDER BY name');
const sql = format(ast);
```

The formatted output for the above:

```sql
SELECT
    id,
    name
FROM users
WHERE active = 1
ORDER BY name ASC;
```

`format()` converts the AST back into normalized, readable SQL. Parsing and formatting is round-trip safe — parsing the formatted output produces an identical AST.

### EXPLAIN output

```typescript
import { parse, formatExplain } from '@clickhouse/parser';

const ast = parse('SELECT a + b FROM t WHERE x = 1');
const explain = formatExplain(ast);
```

`formatExplain()` produces a tree representation matching ClickHouse's `EXPLAIN AST` output:

```
SelectWithUnionQuery (children 1)
 ExpressionList (children 1)
  SelectQuery (children 3)
   ExpressionList (children 1)
    Function plus (children 1)
     ExpressionList (children 2)
      Identifier a
      Identifier b
   TablesInSelectQuery (children 1)
    TablesInSelectQueryElement (children 1)
     TableExpression (children 1)
      TableIdentifier t
   Function equals (children 1)
    ExpressionList (children 2)
     Identifier x
     Literal UInt64_1
```

### Error handling

When parsing fails, `parse()` throws a `ParseError` with structured information about where and why the parse failed.

```typescript
import { parse, ParseError } from '@clickhouse/parser';

try {
  parse('SELECT ???');
} catch (e) {
  if (e instanceof ParseError) {
    e.message; // Human-readable error message
    e.location; // { start: { line, column, offset }, end: { line, column, offset } }
    e.expected; // What the parser expected (e.g. literals, token classes)
    e.found; // What was found instead (string | null)
  }
}
```

## Supported SQL

The parser targets full coverage of the ClickHouse SQL surface and is verified
against a corpus of ~7000 representative reference query files drawn from the
official ClickHouse repository. For every reference, the AST, formatted SQL,
and `EXPLAIN AST` projection match ClickHouse's own output exactly.

### Limitations

- **ClickHouse-only** — this is not a general SQL parser. Syntax from other dialects that ClickHouse doesn't support will not parse.
- **KQL** — Kusto Query Language syntax is not supported.
- **Inserted Values** are not parsed - the AST does not include literal values being inserted into a table.

### Divergence from ClickHouse Reference AST

The AST parsed by this library is a superset of the JSON AST produced by ClickHouse introduced [here](https://github.com/peter-leonov-ch/ClickHouse/pull/1). Additional properties are described below.

#### Location Metadata

Every node carries a `location: { start, end }` recording its source
range in the original SQL, where `start`/`end` are `{ offset, line, column }`
(compatible with peggy's `LocationRange`). Locations are included by default;
pass `{ locations: false }` to `parse()` to omit them (see [Parse options](#parse-options)).

#### Parent Metadata

Optionally, every node can be returned with a `parent` reference to its enclosing node. Pass the
`options: { setParents: true }` argument to `parse()` to enable this feature. This enables upward
traversal of the tree. It creates circular references, so exclude it when serializing or comparing
the AST.

#### Comment Data

Comments are attached to the nearest node as arrays of their full source text
(including `--`, `#`, or `/* */` delimiters):

- `leadingComments` — comments appearing before the node.
- `trailingComments` — inline comments on the same line as the end of the node.

#### Semantic Fields not in Reference AST

These fields carry semantic information that the reference JSON AST discards but
that `format()` needs to reproduce the source faithfully.

- `nonfinite` — Found on `Literal` and `LiteralElement` nodes, this is a discriminator
for `Float64` values that the native `value` float cannot represent in serialized JSON.
Non-finite values (`inf`, `-inf`, `nan`, `-nan`) that each collapse to `null` can be
recovered using this flag.
- `QueryParameter` nodes - represent query parameters (`{name:type}` syntax) in the source,
which are not represented by the reference ClickHouse JSON AST.

#### Non-Semantic Fields for Explain Formatting

These fields carry no semantic meaning and are **only** read by `formatExplain()`.
They exist because ClickHouse's `EXPLAIN AST` exposes internal child-vector ordering
and duplication that the structured JSON AST discards. Like the semantic fields
above, they are absent from the reference AST, so `formatJsonExplain()` strips them.

- `with_trailing` — marks a `WITH` clause that ClickHouse appends *after* the
  select body rather than before it (a `WITH` written before an enclosing
  `INSERT`, or propagated into a non-leftmost `UNION`/`INTERSECT` member). The
  reference AST stores the same `with` field in both positions, so the flag is
  the only record of the trailing placement.
- `agg_repeat` — marks the synthetic `SelectQuery` produced when lowering
  `expr op ANY/ALL (subquery)`. ClickHouse's text dump emits this node's
  projection and tables twice (`SelectQuery (children 4)`); the reference AST
  keeps a single copy, indistinguishable from a user-written
  `(SELECT agg(*) FROM (sub))`.
- `settings_before_format` — records that `SETTINGS` preceded `FORMAT` in the
  source. `format()` canonicalizes to `FORMAT ... SETTINGS ...`; the flag lets
  the explain projection reproduce the original child order.
- `settings_after_order_by` — records that a storage `SETTINGS` clause appeared
  before the last clause in the source. `format()` canonicalizes it to the
  required final position; the flag preserves the original `Set` child order.
- `no_parens` — records that a codec/engine function was written without
  parentheses (e.g. `Delta` vs `Delta()`). `format()` canonicalizes to the
  empty-parens form; the flag reproduces ClickHouse's byte-exact AST.

## Development

```bash
npm run build           # Regenerate parser from grammar + build dist/
npm test                # Run test suite
```

### Inspecting output

`parse`, `format`, and `explain` print this library's output. Each takes a raw SQL
string via `--sql`, or one or more reference cases from `tests/clickhouse-reference/`
(a `.sql` filename — the suffix is optional — a comma-separated list, or a glob):

```bash
npm run parse   -- --sql "SELECT 1"   # AST as JSON
npm run format  -- --sql "SELECT 1"   # re-formatted SQL
npm run explain -- --sql "SELECT 1"   # EXPLAIN AST output

npm run format  -- 00001_select_1     # output for a reference case
npm run explain -- '00001_*'          # output for every matching case
```

### Diffing against expected output

`diff:ast`, `diff:format`, and `diff:explain` show this library's output, the expected
output committed in `tests/clickhouse-reference/`, and a diff between them — useful for
debugging reference test failures. They take the same reference selector (filename,
comma-separated list, or glob):

```bash
npm run diff:format  -- 00001_select_1            # actual, expected, and diff
npm run diff:ast     -- '0001*' --diff-only       # just the diff
npm run diff:explain -- 00001_select_1,00002_count_visits --only-diffs
```

Flags: `--diff-only`, `--actual-only`, `--expected-only`, `--only-diffs`, `--no-color`.
Pass `-h` to any script for full usage.

The parser is built with [Peggy](https://peggyjs.org/) (PEG grammar) and produces ASTs validated by [Zod](https://zod.dev/) schemas. All AST types are exported for use in downstream tooling.
