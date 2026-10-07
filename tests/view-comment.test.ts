import { formatExplain, parse } from '../src/index';

/**
 * `COMMENT` on `CREATE VIEW` and `CREATE MATERIALIZED VIEW`.
 *
 * The documented grammar places the clause after the SELECT:
 *
 *   CREATE VIEW db.v AS SELECT 1 AS x COMMENT 'c'
 *
 * ClickHouse normalizes it to before `AS` when it stores the definition, so
 * `SHOW CREATE VIEW`, `system.tables.create_table_query` and `formatQuery()`
 * all emit:
 *
 *   CREATE VIEW db.v (`x` UInt8) COMMENT 'c' AS SELECT 1 AS x
 *
 * Today:
 *   - a plain view does not parse with a comment in either position, so a
 *     dumped schema cannot be read back;
 *   - a materialized view parses the pre-`AS` position but drops the comment
 *     from the explain output, and does not parse the trailing position.
 *
 * In ClickHouse's AST the comment literal sits between the column list and
 * the SELECT for both kinds of view (for tables it comes last). Expected
 * output is ClickHouse's own `EXPLAIN AST`, captured from clickhouse-server
 * 26.2.19.
 */

const SELECT_1 = `
 SelectWithUnionQuery (children 1)
  ExpressionList (children 1)
   SelectQuery (children 1)
    ExpressionList (children 1)
     Literal UInt64_1 (alias x)`;

const COLUMNS_X = `
 Columns definition (children 1)
  ExpressionList (children 1)
   ColumnDeclaration x (children 1)
    DataType UInt8`;

const cases: { sql: string; explain: string }[] = [
  {
    sql: "CREATE VIEW db.v (x UInt8) COMMENT 'c' AS SELECT 1 AS x",
    explain: `CreateQuery db v (children 5)
 Identifier db
 Identifier v${COLUMNS_X}
 Literal 'c'${SELECT_1}`,
  },
  {
    sql: "CREATE VIEW db.v AS SELECT 1 AS x COMMENT 'c'",
    explain: `CreateQuery db v (children 4)
 Identifier db
 Identifier v
 Literal 'c'${SELECT_1}`,
  },
  {
    sql: "CREATE MATERIALIZED VIEW db.mv TO db.t (x UInt8) COMMENT 'c' AS SELECT 1 AS x",
    explain: `CreateQuery db mv (children 6)
 Identifier db
 Identifier mv${COLUMNS_X}
 Literal 'c'${SELECT_1}
 ViewTargets`,
  },
  {
    sql: "CREATE MATERIALIZED VIEW db.mv TO db.t AS SELECT 1 AS x COMMENT 'c'",
    explain: `CreateQuery db mv (children 5)
 Identifier db
 Identifier mv
 Literal 'c'${SELECT_1}
 ViewTargets`,
  },
];

describe('CREATE VIEW / CREATE MATERIALIZED VIEW with COMMENT', () => {
  for (const { sql, explain } of cases) {
    it(sql, () => {
      const statements = parse(sql);
      expect(statements).toHaveLength(1);
      expect(formatExplain(statements).trimEnd()).toBe(explain);
    });
  }
});
