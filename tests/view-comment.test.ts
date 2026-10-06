import { formatExplain, parse } from '../src/index';

/**
 * `COMMENT` on a plain `CREATE VIEW`.
 *
 * The documented grammar places the clause after the SELECT:
 *
 *   CREATE VIEW db.v AS SELECT 1 AS x COMMENT 'c'
 *
 * ClickHouse itself normalizes it to before `AS` when it stores the
 * definition, so `SHOW CREATE VIEW`, `system.tables.create_table_query` and
 * `formatQuery()` all emit:
 *
 *   CREATE VIEW db.v (`x` UInt8) COMMENT 'c' AS SELECT 1 AS x
 *
 * Neither position parses today, which means a dumped schema cannot be read
 * back. (`CREATE MATERIALIZED VIEW ... COMMENT 'c' AS SELECT` already parses.)
 *
 * Expected output is ClickHouse's own `EXPLAIN AST`, captured from
 * clickhouse-server 26.2.19.
 */

const cases: { sql: string; explain: string }[] = [
  {
    sql: "CREATE VIEW db.v (x UInt8) COMMENT 'c' AS SELECT 1 AS x",
    explain: `
CreateQuery db v (children 5)
 Identifier db
 Identifier v
 Columns definition (children 1)
  ExpressionList (children 1)
   ColumnDeclaration x (children 1)
    DataType UInt8
 Literal 'c'
 SelectWithUnionQuery (children 1)
  ExpressionList (children 1)
   SelectQuery (children 1)
    ExpressionList (children 1)
     Literal UInt64_1 (alias x)
`.trim(),
  },
  {
    sql: "CREATE VIEW db.v AS SELECT 1 AS x COMMENT 'c'",
    explain: `
CreateQuery db v (children 4)
 Identifier db
 Identifier v
 Literal 'c'
 SelectWithUnionQuery (children 1)
  ExpressionList (children 1)
   SelectQuery (children 1)
    ExpressionList (children 1)
     Literal UInt64_1 (alias x)
`.trim(),
  },
];

describe('CREATE VIEW with COMMENT', () => {
  for (const { sql, explain } of cases) {
    it(sql, () => {
      const statements = parse(sql);
      expect(statements).toHaveLength(1);
      expect(formatExplain(statements).trimEnd()).toBe(explain);
    });
  }
});
