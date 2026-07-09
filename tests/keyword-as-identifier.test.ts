import { parse, ParseError } from '../src/index';
import type {
  SelectQueryNode,
  SelectWithUnionQueryNode,
  IdentifierNode,
  TableIdentifierNode,
  WithElementNode,
} from '../src/ast';

/**
 * Regression tests for reserved clause keywords used as bare identifiers across
 * the various SELECT clauses and identifier positions. ClickHouse accepts a
 * reserved keyword as an identifier in many spots where the naive grammar would
 * treat it as the start of a clause; these tests pin the parser to ClickHouse's
 * behavior (verified against the `clickhouse` binary with `EXPLAIN AST json=1`).
 *
 * The companion file `keyword-as-select-column.test.ts` covers the SELECT-list
 * comma position specifically; this file covers the remaining clause/identifier
 * positions that were found by comparing the parser to ClickHouse.
 */

/** Unwraps a single-statement SELECT to its SelectQuery node. */
function selectQuery(sql: string): SelectQueryNode {
  const statements = parse(sql);
  expect(statements).toHaveLength(1);
  const stmt = statements[0] as SelectWithUnionQueryNode;
  expect(stmt.type).toBe('SelectWithUnionQuery');
  const select = stmt.selects[0];
  if (select.type !== 'SelectQuery') throw new Error(`Expected SelectQuery, got ${select.type}`);
  return select;
}

function names(exprs: readonly unknown[]): string[] {
  return exprs.map((e) => {
    const n = e as IdentifierNode;
    if (n.type !== 'Identifier') throw new Error(`Expected Identifier, got ${n.type}`);
    return n.name;
  });
}

describe('keyword identifiers in list clauses', () => {
  it('GROUP BY accepts a keyword key (head and after comma)', () => {
    expect(names(selectQuery('SELECT count() FROM t GROUP BY ORDER').group_by!)).toEqual(['ORDER']);
    expect(names(selectQuery('SELECT count() FROM t GROUP BY a, ORDER').group_by!)).toEqual([
      'a',
      'ORDER',
    ]);
  });

  it('ORDER BY accepts a keyword key (head and after comma)', () => {
    const q = selectQuery('SELECT a FROM t ORDER BY a, GROUP');
    expect(q.order_by!.map((o) => (o.expression as IdentifierNode).name)).toEqual(['a', 'GROUP']);
    const head = selectQuery('SELECT a FROM t ORDER BY LIMIT');
    expect((head.order_by![0].expression as IdentifierNode).name).toBe('LIMIT');
  });

  it('LIMIT ... BY accepts a keyword key (head and after comma)', () => {
    expect(names(selectQuery('SELECT a FROM t LIMIT 1 BY ORDER').limit_by!.by)).toEqual(['ORDER']);
    expect(names(selectQuery('SELECT a FROM t LIMIT 1 BY a, ORDER').limit_by!.by)).toEqual([
      'a',
      'ORDER',
    ]);
  });

  it('function arguments accept a keyword identifier', () => {
    const q = selectQuery('SELECT f(ORDER) FROM t');
    const fn = q.select[0] as { type: string; arguments?: unknown[] };
    expect(fn.type).toBe('Function');
  });
});

describe('keyword identifiers as implicit (no-AS) aliases', () => {
  // ClickHouse permits these reserved keywords as an implicit column alias; the
  // rest must be written with AS. `SELECT` is allowed here too (`SELECT a SELECT`).
  const columnAllowed = ['BY', 'ASC', 'DESC', 'NULL', 'DISTINCT', 'OVER', 'SELECT'];
  // Table position additionally allows the operator words AND/OR/IN, which cannot
  // otherwise follow a table. (`SELECT` is covered separately below.)
  const tableAllowed = ['BY', 'ASC', 'DESC', 'NULL', 'DISTINCT', 'OVER', 'AND', 'OR', 'IN'];

  it.each(columnAllowed)('accepts %s as an implicit column alias', (kw) => {
    const q = selectQuery(`SELECT a ${kw} FROM t`);
    const col = q.select[0] as IdentifierNode;
    expect(col.name).toBe('a');
    expect(col.alias).toBe(kw);
  });

  it.each(tableAllowed)('accepts %s as an implicit table alias', (kw) => {
    const q = selectQuery(`SELECT x FROM t ${kw}`);
    const table = q.from!.children[0].table_expression!.database_and_table_name as TableIdentifierNode;
    expect(table.name).toBe('t');
    expect(table.alias).toBe(kw);
  });

  it('accepts a trailing SELECT as an implicit table alias', () => {
    const q = selectQuery('SELECT x FROM t SELECT');
    const table = q.from!.children[0].table_expression!.database_and_table_name as TableIdentifierNode;
    expect(table.name).toBe('t');
    expect(table.alias).toBe('SELECT');
  });

  // These reserved keywords remain clause/structure markers and must NOT be
  // swallowed as implicit aliases (matching ClickHouse).
  it('does not treat a trailing ORDER as an implicit alias (it needs BY)', () => {
    // `SELECT a ORDER FROM t` is a syntax error in ClickHouse (ORDER is not a
    // valid implicit alias and ORDER BY requires BY).
    expect(() => parse('SELECT a ORDER FROM t')).toThrow(ParseError);
  });

  it('keeps FROM-first syntax working (SELECT is only a table alias when trailing)', () => {
    // `FROM numbers(1) SELECT number` must parse as FROM-first select, not
    // `numbers(1)` aliased as SELECT: a trailing SELECT is only an alias when no
    // select item follows it.
    const q = selectQuery('FROM numbers(1) SELECT number');
    expect((q.select[0] as IdentifierNode).name).toBe('number');
    // And a SELECT that IS followed by a select item is a hard error (matching CH).
    expect(() => parse('SELECT x FROM t SELECT y')).toThrow(ParseError);
  });

  it('keeps FINAL as a table modifier, not an implicit alias', () => {
    const q = selectQuery('SELECT x FROM t FINAL');
    const el = q.from!.children[0];
    expect(el.table_expression!.final).toBe(true);
  });

  it('keeps OVER as a window clause when followed by a window spec', () => {
    const q = selectQuery('SELECT sum(a) OVER (ORDER BY b) FROM t');
    const col = q.select[0] as { type: string; window_definition?: unknown; over?: unknown };
    // The expression is windowed, not aliased "OVER".
    expect(col.type).toBe('Function');
    expect(JSON.stringify(col)).toContain('WindowDefinition');
  });
});

describe('keyword identifiers as CTE names', () => {
  // ClickHouse allows any reserved keyword as a CTE (WITH) name.
  const keywords = ['ORDER', 'GROUP', 'WHERE', 'SAMPLE', 'LIMIT', 'SELECT', 'FROM'];

  it.each(keywords)('accepts %s as a subquery CTE name', (kw) => {
    const q = selectQuery(`WITH ${kw} AS (SELECT 1) SELECT * FROM ${kw}`);
    const cte = q.with![0] as WithElementNode;
    expect(cte.type).toBe('WithElement');
    expect(cte.name).toBe(kw);
  });

  it('accepts a keyword CTE name with column aliases', () => {
    const q = selectQuery('WITH ORDER (x) AS (SELECT 1) SELECT x FROM ORDER');
    const cte = q.with![0] as WithElementNode;
    expect(cte.name).toBe('ORDER');
  });
});
