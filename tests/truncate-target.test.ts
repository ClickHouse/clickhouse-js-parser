import { parse } from '../src/index';
import { stripAstMeta } from './helpers';

/**
 * Standalone coverage for the `TRUNCATE` target disambiguation, focused on the
 * `has_all` / `has_tables` native flags. These distinguish the three
 * database-only forms that are otherwise byte-identical in ClickHouse's native
 * AST (all carry only a `database` Identifier and no target keyword):
 *
 *   TRUNCATE DATABASE db          → (neither flag)
 *   TRUNCATE TABLES FROM db       → has_tables
 *   TRUNCATE ALL TABLES FROM db   → has_all + has_tables
 *
 * These cases live outside the reference suite because the suite's only
 * `TRUNCATE TABLES FROM` case (03403) uses query parameters, so ClickHouse
 * never emits a `TruncateQuery` to validate the flags. The expected ASTs below
 * were generated directly from the oracle:
 *
 *   ./clickhouse -q "explain ast json=1 <SQL>"
 *
 * (see scripts/gen output; the EXPLAIN string is unescaped and its `.ast`
 * extracted). Comparisons use stripAstMeta so library-only/underscore fields
 * are ignored — only ClickHouse-native fields are asserted.
 */

const cases: { sql: string; ast: unknown }[] = [
  {
    sql: 'TRUNCATE ALL TABLES FROM mydb',
    ast: {
      type: 'TruncateQuery',
      kind: 'TRUNCATE',
      database: { type: 'Identifier', name: 'mydb' },
      has_all: true,
      has_tables: true,
    },
  },
  {
    sql: 'TRUNCATE TABLES FROM mydb',
    ast: {
      type: 'TruncateQuery',
      kind: 'TRUNCATE',
      database: { type: 'Identifier', name: 'mydb' },
      has_tables: true,
    },
  },
  {
    sql: 'TRUNCATE DATABASE mydb',
    ast: {
      type: 'TruncateQuery',
      kind: 'TRUNCATE',
      database: { type: 'Identifier', name: 'mydb' },
    },
  },
  {
    sql: 'TRUNCATE ALL TABLES FROM IF EXISTS mydb',
    ast: {
      type: 'TruncateQuery',
      kind: 'TRUNCATE',
      database: { type: 'Identifier', name: 'mydb' },
      if_exists: true,
      has_all: true,
      has_tables: true,
    },
  },
  {
    sql: "TRUNCATE TABLES FROM mydb LIKE '%foo'",
    ast: {
      type: 'TruncateQuery',
      kind: 'TRUNCATE',
      database: { type: 'Identifier', name: 'mydb' },
      has_tables: true,
      like: '%foo',
    },
  },
  {
    sql: "TRUNCATE TABLES FROM mydb NOT LIKE '%foo'",
    ast: {
      type: 'TruncateQuery',
      kind: 'TRUNCATE',
      database: { type: 'Identifier', name: 'mydb' },
      has_tables: true,
      like: '%foo',
      not_like: true,
    },
  },
  {
    sql: "TRUNCATE TABLES FROM mydb ILIKE '%foo'",
    ast: {
      type: 'TruncateQuery',
      kind: 'TRUNCATE',
      database: { type: 'Identifier', name: 'mydb' },
      has_tables: true,
      like: '%foo',
      case_insensitive_like: true,
    },
  },
  {
    sql: 'TRUNCATE ALL TABLES FROM mydb ON CLUSTER c',
    ast: {
      type: 'TruncateQuery',
      kind: 'TRUNCATE',
      database: { type: 'Identifier', name: 'mydb' },
      cluster: 'c',
      has_all: true,
      has_tables: true,
    },
  },
  {
    sql: 'TRUNCATE TABLE foo',
    ast: {
      type: 'TruncateQuery',
      kind: 'TRUNCATE',
      table: { type: 'Identifier', name: 'foo' },
    },
  },
];

describe('TRUNCATE target disambiguation (has_all / has_tables)', () => {
  for (const { sql, ast } of cases) {
    it(sql, () => {
      const statements = parse(sql);
      const actual = stripAstMeta(statements) as unknown[];
      expect(actual).toHaveLength(1);
      expect(actual[0]).toEqual(ast);
    });
  }
});
