import { parse, ParseError } from '../src/index';

/**
 * Regression tests for clause keywords used as bare column identifiers in the
 * SELECT list. ClickHouse treats a clause keyword (ORDER, GROUP, WHERE, LIMIT,
 * ...) that follows a select-list comma as a column identifier rather than the
 * start of a clause — e.g. `SELECT A, ORDER FROM T` selects columns `A` and
 * `ORDER`. A clause keyword only starts a clause when it is NOT preceded by a
 * select-list comma. Only a trailing-comma `FROM` still terminates the list.
 *
 * Previously the `SelectItemList` guard blocked every clause keyword after a
 * comma, so `SELECT A, ORDER FROM T` failed to parse.
 */

/** Returns the list of select-item column names for a single-statement SELECT. */
function selectColumnNames(sql: string): string[] {
  const statements = parse(sql);
  expect(statements).toHaveLength(1);
  const stmt = statements[0];
  if (stmt.type !== 'SelectWithUnionQuery') {
    throw new Error(`Expected SelectWithUnionQuery, got ${stmt.type}`);
  }
  const select = stmt.selects[0];
  if (select.type !== 'SelectQuery') {
    throw new Error(`Expected SelectQuery, got ${select.type}`);
  }
  return select.select.map((item) => {
    if (item.type !== 'Identifier') {
      throw new Error(`Expected Identifier select item, got ${item.type}`);
    }
    return item.name;
  });
}

describe('clause keywords as SELECT columns', () => {
  it('parses ORDER as a column after a comma (SELECT A, ORDER FROM T)', () => {
    expect(selectColumnNames('SELECT A, ORDER FROM T')).toEqual(['A', 'ORDER']);
  });

  it('parses multiple clause keywords as columns (SELECT A, ORDER, LIMIT FROM T)', () => {
    expect(selectColumnNames('SELECT A, ORDER, LIMIT FROM T')).toEqual(['A', 'ORDER', 'LIMIT']);
  });

  it.each(['ORDER', 'GROUP', 'WHERE', 'PREWHERE', 'HAVING', 'LIMIT', 'OFFSET'])(
    'parses %s as a column after a comma',
    (keyword) => {
      expect(selectColumnNames(`SELECT a, ${keyword} FROM t`)).toEqual(['a', keyword]);
    },
  );

  it('parses a clause keyword column alongside a real clause (SELECT a, GROUP FROM t GROUP BY a)', () => {
    expect(selectColumnNames('SELECT a, GROUP FROM t GROUP BY a')).toEqual(['a', 'GROUP']);
  });

  it('still allows a keyword column in the head position (SELECT ORDER FROM T)', () => {
    expect(selectColumnNames('SELECT ORDER FROM T')).toEqual(['ORDER']);
  });

  it('still treats a trailing-comma FROM as the FROM clause (SELECT a, FROM t)', () => {
    expect(selectColumnNames('SELECT a, FROM t')).toEqual(['a']);
  });

  it('still parses a clause keyword as a clause when not preceded by a comma (SELECT a FROM t ORDER BY x)', () => {
    // The keyword column change must not swallow a genuine ORDER BY clause.
    const statements = parse('SELECT a FROM t ORDER BY x');
    const stmt = statements[0];
    if (stmt.type !== 'SelectWithUnionQuery' || stmt.selects[0].type !== 'SelectQuery') {
      throw new Error('unexpected AST shape');
    }
    expect(selectColumnNames('SELECT a FROM t ORDER BY x')).toEqual(['a']);
    expect(stmt.selects[0].order_by).toBeDefined();
  });

  // ClickHouse rejects these: the keyword parses as a column, then the following
  // token (BY / a number) is unexpected. The parser must match that behavior and
  // not fall back to interpreting the keyword as a clause.
  it('rejects ORDER BY after a comma (SELECT A, ORDER BY x FROM T)', () => {
    expect(() => parse('SELECT A, ORDER BY x FROM T')).toThrow(ParseError);
  });

  it('rejects LIMIT <n> after a comma (SELECT 1, LIMIT 5)', () => {
    expect(() => parse('SELECT 1, LIMIT 5')).toThrow(ParseError);
  });
});
