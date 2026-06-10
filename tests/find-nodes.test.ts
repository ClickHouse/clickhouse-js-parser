import { parse, findNodes, isLiteral } from '../src/index';

describe('findNodes', () => {
  describe('returns empty array', () => {
    it('when no nodes of the given kind exist', () => {
      const stmts = parse('SELECT 1;');
      expect(findNodes(stmts, 'QueryParameter')).toEqual([]);
      expect(findNodes(stmts, 'TableIdentifier')).toEqual([]);
      expect(findNodes(stmts, 'TableJoin')).toEqual([]);
    });
  });

  describe('expression nodes', () => {
    it('finds literals', () => {
      const stmts = parse("SELECT 1, 'hello', 3.14, NULL, true;");
      const literals = findNodes(stmts, 'Literal');
      // UInt64 `1` is stored as the canonical decimal-digit string;
      // Float64/Bool/Null/String keep their native JS shape.
      expect(literals.map((l) => l.value)).toEqual(['1', 'hello', 3.14, null, true]);
    });

    it('finds column refs', () => {
      const stmts = parse('SELECT a, b, c FROM t;');
      const refs = findNodes(stmts, 'Identifier');
      expect(refs.map((r) => r.name)).toEqual(['a', 'b', 'c']);
    });

    it('finds qualified column refs', () => {
      const stmts = parse('SELECT t.a, db.t.b FROM t;');
      const refs = findNodes(stmts, 'Identifier');
      expect(refs.map((r) => r.name_parts)).toEqual([
        ['t', 'a'],
        ['db', 't', 'b'],
      ]);
    });

    it('finds query params', () => {
      const stmts = parse('SELECT {x: UInt64} FROM t WHERE id = {id: String};');
      const params = findNodes(stmts, 'QueryParameter');
      expect(params).toMatchObject([
        { type: 'QueryParameter', name: 'x', param_type: 'UInt64' },
        { type: 'QueryParameter', name: 'id', param_type: 'String' },
      ]);
    });

    it('finds function calls', () => {
      const stmts = parse('SELECT count(), sum(x), avg(y) FROM t;');
      const funcs = findNodes(stmts, 'Function');
      expect(funcs.map((f) => f.name)).toEqual(['count', 'sum', 'avg']);
    });

    it('finds nested function calls', () => {
      const stmts = parse('SELECT toString(toDate(now()));');
      const funcs = findNodes(stmts, 'Function');
      expect(funcs.map((f) => f.name)).toEqual(['toString', 'toDate', 'now']);
    });

    it('finds cast expressions', () => {
      const stmts = parse('SELECT CAST(x AS Int32), y::String FROM t;');
      const casts = findNodes(stmts, 'Function').filter((f) => f.name === 'CAST');
      expect(casts).toHaveLength(2);
      // CAST(x AS T) form has no is_operator; x::T form has is_operator: true.
      expect(casts.map((c) => c.is_operator === true)).toEqual([false, true]);
      expect(casts.map((c) => (isLiteral(c.arguments[1]) ? c.arguments[1].value : null))).toEqual([
        'Int32',
        'String',
      ]);
    });

    it('finds lambda expressions', () => {
      const stmts = parse('SELECT arrayMap(x -> x + 1, arr) FROM t;');
      const lambdas = findNodes(stmts, 'Function').filter((f) => f.is_lambda_function);
      expect(lambdas).toHaveLength(1);
      expect(lambdas[0].arguments[0]).toMatchObject({
        type: 'Function',
        name: 'tuple',
        arguments: [{ type: 'Identifier', name: 'x' }],
      });
    });

    it('finds binary expressions', () => {
      const stmts = parse('SELECT a + b, c * d FROM t;');
      const binExprs = findNodes(stmts, 'Function').filter((f) => f.is_operator);
      expect(binExprs.map((e) => e.name)).toEqual(['plus', 'multiply']);
    });

    it('finds nary expressions', () => {
      const stmts = parse('SELECT * FROM t WHERE a AND b AND c;');
      const naryExprs = findNodes(stmts, 'Function').filter(
        (f) => f.name === 'and' && f.is_operator === true,
      );
      expect(naryExprs).toHaveLength(1);
      expect(naryExprs[0].name).toBe('and');
      expect(naryExprs[0].arguments).toHaveLength(3);
    });

    it('finds unary expressions', () => {
      const stmts = parse('SELECT * FROM t WHERE NOT x;');
      const unaryExprs = findNodes(stmts, 'Function').filter(
        (f) => f.name === 'not' && f.is_operator === true,
      );
      expect(unaryExprs).toHaveLength(1);
      expect(unaryExprs[0].name).toBe('not');
    });

    it('finds aliases', () => {
      const stmts = parse('SELECT a AS x, b AS y FROM t;');
      const aliased = findNodes(stmts, 'Identifier').filter((n) => n.alias !== undefined);
      expect(aliased.map((a) => a.alias)).toEqual(['x', 'y']);
    });

    it('finds array literals', () => {
      const stmts = parse('SELECT [1, 2, 3];');
      const arrays = findNodes(stmts, 'Literal').filter((l) => l.value_type === 'Array');
      expect(arrays).toHaveLength(1);
      expect(arrays[0].value).toHaveLength(3);
    });

    it('finds tuple literals', () => {
      const stmts = parse("SELECT (1, 'a', 3.14);");
      const tuples = findNodes(stmts, 'Literal').filter((l) => l.value_type === 'Tuple');
      expect(tuples).toHaveLength(1);
      expect(tuples[0].value).toHaveLength(3);
    });

    it('finds IN expressions', () => {
      const stmts = parse('SELECT * FROM t WHERE x IN (1, 2, 3) AND y NOT IN (4, 5);');
      const inExprs = findNodes(stmts, 'Function').filter(
        (f) => f.name === 'in' || f.name === 'notIn',
      );
      expect(inExprs).toHaveLength(2);
      expect(inExprs[0].name).toBe('in');
      expect(inExprs[1].name).toBe('notIn');
    });

    it('finds asterisks', () => {
      const stmts = parse('SELECT * FROM t;');
      const asterisks = findNodes(stmts, 'Asterisk');
      expect(asterisks).toHaveLength(1);
    });

    it('finds qualified asterisks', () => {
      const stmts = parse('SELECT t.* FROM t;');
      const qualAsterisks = findNodes(stmts, 'QualifiedAsterisk');
      expect(qualAsterisks).toHaveLength(1);
      expect(qualAsterisks[0]).toMatchObject({ qualifier: { type: 'Identifier', name: 't' } });
    });

    it('finds subquery expressions', () => {
      const stmts = parse('SELECT * FROM t WHERE x IN (SELECT id FROM t2);');
      const subqueries = findNodes(stmts, 'Subquery');
      expect(subqueries).toHaveLength(1);
    });
  });

  describe('FROM clause nodes', () => {
    it('finds table refs', () => {
      const stmts = parse('SELECT * FROM t1;');
      const tables = findNodes(stmts, 'TableIdentifier');
      expect(tables).toHaveLength(1);
      expect(tables[0].name).toBe('t1');
    });

    it('finds table refs with database qualifier', () => {
      const stmts = parse('SELECT * FROM db.t1;');
      const tables = findNodes(stmts, 'TableIdentifier');
      expect(tables[0].database).toBe('db');
      expect(tables[0].name).toBe('t1');
    });

    it('finds table refs with aliases', () => {
      const stmts = parse('SELECT * FROM my_table AS t;');
      const tables = findNodes(stmts, 'TableIdentifier');
      expect(tables[0].alias).toBe('t');
    });

    it('finds subquery FROM sources', () => {
      const stmts = parse('SELECT * FROM (SELECT 1) AS sub;');
      const subFroms = findNodes(stmts, 'TableExpression').filter((t) => t.subquery !== undefined);
      expect(subFroms).toHaveLength(1);
      expect(subFroms[0].subquery!.alias).toBe('sub');
    });

    it('finds table function refs', () => {
      const stmts = parse('SELECT * FROM numbers(10);');
      const tableFuncs = findNodes(stmts, 'TableExpression').filter(
        (t) => t.table_function !== undefined,
      );
      expect(tableFuncs).toHaveLength(1);
      expect(tableFuncs[0].table_function!.name).toBe('numbers');
    });

    it('finds join nodes', () => {
      const stmts = parse(
        'SELECT * FROM t1 INNER JOIN t2 ON t1.id = t2.id LEFT JOIN t3 ON t2.id = t3.id;',
      );
      const joins = findNodes(stmts, 'TableJoin');
      expect(joins).toHaveLength(2);
    });

    it('finds array join nodes', () => {
      const stmts = parse('SELECT * FROM t ARRAY JOIN arr AS a;');
      const arrayJoins = findNodes(stmts, 'ArrayJoin');
      expect(arrayJoins).toHaveLength(1);
      expect(arrayJoins[0].kind).toBe('INNER');
    });

    it('finds all table refs across joins', () => {
      const stmts = parse('SELECT * FROM t1 INNER JOIN t2 ON t1.id = t2.id;');
      const tables = findNodes(stmts, 'TableIdentifier');
      expect(tables.map((t) => t.name)).toEqual(['t1', 't2']);
    });
  });

  describe('statement nodes', () => {
    it('finds select statements', () => {
      const stmts = parse('SELECT 1; SELECT 2;');
      const selects = findNodes(stmts, 'SelectQuery');
      expect(selects).toHaveLength(2);
    });

    it('finds select statements inside unions', () => {
      const stmts = parse('SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3;');
      const selects = findNodes(stmts, 'SelectQuery');
      expect(selects).toHaveLength(3);
    });

    it('finds union statements', () => {
      const stmts = parse('SELECT 1 UNION ALL SELECT 2;');
      const unions = findNodes(stmts, 'SelectWithUnionQuery');
      expect(unions).toHaveLength(1);
    });

    it('finds intersect statements', () => {
      const stmts = parse('SELECT 1 INTERSECT SELECT 1;');
      const intersects = findNodes(stmts, 'SelectIntersectExceptQuery');
      expect(intersects).toHaveLength(1);
      expect(intersects[0].operator).toBe('INTERSECT ALL');
    });

    it('finds except statements', () => {
      const stmts = parse('SELECT 1 EXCEPT SELECT 2;');
      const excepts = findNodes(stmts, 'SelectIntersectExceptQuery');
      expect(excepts).toHaveLength(1);
      expect(excepts[0].operator).toBe('EXCEPT ALL');
    });

    it('finds explain statements', () => {
      const stmts = parse('EXPLAIN AST SELECT 1;');
      const explains = findNodes(stmts, 'Explain');
      expect(explains).toHaveLength(1);
      // Native `kind` carries the full EXPLAIN keyword phrase.
      expect(explains[0].kind).toBe('EXPLAIN AST');
    });

    it('finds set statements', () => {
      const stmts = parse('SET max_threads = 4;');
      const sets = findNodes(stmts, 'Settings');
      expect(sets).toHaveLength(1);
      expect(sets[0].changes).toEqual({ max_threads: '4' });
    });

    it('finds use statements', () => {
      const stmts = parse('USE my_db;');
      const uses = findNodes(stmts, 'UseQuery');
      expect(uses).toHaveLength(1);
      expect(uses[0].database.name).toBe('my_db');
    });

    it('finds system statements', () => {
      const stmts = parse('SYSTEM FLUSH LOGS;');
      const systems = findNodes(stmts, 'SYSTEM');
      expect(systems).toHaveLength(1);
    });
  });

  describe('deeply nested nodes', () => {
    it('finds nodes inside nested subqueries', () => {
      const stmts = parse('SELECT * FROM (SELECT a, b FROM (SELECT a, b, c FROM t));');
      const refs = findNodes(stmts, 'Identifier');
      expect(refs.map((r) => r.name)).toEqual(['a', 'b', 'a', 'b', 'c']);
    });

    it('finds nodes inside CTE subqueries', () => {
      const stmts = parse('WITH cte AS (SELECT id FROM t WHERE x > 10) SELECT * FROM cte;');
      const tables = findNodes(stmts, 'TableIdentifier');
      expect(tables.map((t) => t.name)).toEqual(['t', 'cte']);
    });

    it('finds nodes inside CTE expressions', () => {
      const stmts = parse('WITH 1 + 2 AS val SELECT val;');
      const binExprs = findNodes(stmts, 'Function').filter((f) => f.is_operator);
      expect(binExprs).toHaveLength(1);
      expect(binExprs[0].name).toBe('plus');
    });

    it('finds nodes inside IN subqueries', () => {
      const stmts = parse(
        'SELECT * FROM t WHERE x IN (SELECT id FROM t2 WHERE y = {val: UInt64});',
      );
      const params = findNodes(stmts, 'QueryParameter');
      expect(params).toHaveLength(1);
      expect(params[0].name).toBe('val');
    });

    it('finds nodes in HAVING clause', () => {
      const stmts = parse('SELECT x, count() AS cnt FROM t GROUP BY x HAVING cnt > 10;');
      const literals = findNodes(stmts, 'Literal');
      expect(literals.map((l) => l.value)).toContain('10');
    });

    it('finds nodes in ORDER BY expressions', () => {
      const stmts = parse('SELECT * FROM t ORDER BY a + b ASC;');
      const binExprs = findNodes(stmts, 'Function').filter((f) => f.is_operator);
      expect(binExprs).toHaveLength(1);
      expect(binExprs[0].name).toBe('plus');
    });

    it('finds nodes in PREWHERE clause', () => {
      const stmts = parse('SELECT * FROM t PREWHERE x > 5;');
      const binExprs = findNodes(stmts, 'Function').filter((f) => f.is_operator);
      expect(binExprs).toHaveLength(1);
    });

    it('finds nodes in LIMIT and OFFSET', () => {
      const stmts = parse('SELECT * FROM t LIMIT {n: UInt64} OFFSET {off: UInt64};');
      const params = findNodes(stmts, 'QueryParameter');
      expect(params.map((p) => p.name)).toEqual(['n', 'off']);
    });

    it('finds nodes in GROUP BY expressions', () => {
      const stmts = parse('SELECT toDate(ts), count() FROM t GROUP BY toDate(ts);');
      const funcs = findNodes(stmts, 'Function');
      const toDateCalls = funcs.filter((f) => f.name === 'toDate');
      expect(toDateCalls).toHaveLength(2);
    });

    it('finds nodes in JOIN ON conditions', () => {
      const stmts = parse('SELECT * FROM t1 INNER JOIN t2 ON toUInt64(t1.id) = toUInt64(t2.id);');
      const funcs = findNodes(stmts, 'Function').filter((f) => !f.is_operator);
      expect(funcs.map((f) => f.name)).toEqual(['toUInt64', 'toUInt64']);
    });

    it('does not surface nodes inside SETTINGS clause values', () => {
      // Set.changes stores setting values as scalar primitives (matching
      // ClickHouse's native AST), so QueryParameter / Literal / Identifier
      // nodes embedded in setting values are no longer present in the AST
      // tree and findNodes cannot return them.
      const stmts = parse('SELECT * FROM t SETTINGS max_threads = {threads: UInt64};');
      expect(findNodes(stmts, 'QueryParameter')).toHaveLength(0);
    });
  });

  describe('multiple statements', () => {
    it('finds nodes across multiple statements', () => {
      const stmts = parse('SELECT 1; SELECT 2; SELECT 3;');
      const literals = findNodes(stmts, 'Literal');
      expect(literals.map((l) => l.value)).toEqual(['1', '2', '3']);
    });

    it('finds nodes across mixed statement types', () => {
      // Set.changes stores setting values as scalar primitives, so the `4`
      // here is not a Literal node in the AST. We assert findNodes traverses
      // the SELECT branch correctly even when a SET precedes it.
      const stmts = parse('SET max_threads = 4; SELECT 7 FROM t;');
      const literals = findNodes(stmts, 'Literal');
      expect(literals.map((l) => l.value)).toContain('7');
    });
  });
});
