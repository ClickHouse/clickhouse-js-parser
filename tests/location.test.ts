import { parse, findNodes } from '../src/index';
import type { SourceLocation } from '../src/index';

/** Shorthand to build a SourceLocation. */
function loc(
  startLine: number,
  startCol: number,
  startOffset: number,
  endLine: number,
  endCol: number,
  endOffset: number,
): SourceLocation {
  return {
    start: { line: startLine, column: startCol, offset: startOffset },
    end: { line: endLine, column: endCol, offset: endOffset },
  };
}

/** Extract the source text that a location refers to. */
function slice(sql: string, location: SourceLocation): string {
  return sql.slice(location.start.offset, location.end.offset);
}

describe('location', () => {
  describe('statement nodes', () => {
    it('has location on a simple SELECT', () => {
      const sql = 'SELECT 1;';
      const stmts = parse(sql);
      expect(stmts[0].location).toEqual(loc(1, 1, 0, 1, 9, 8));
      expect(slice(sql, stmts[0].location!)).toBe('SELECT 1');
    });

    it('has location on multiple statements', () => {
      const sql = 'SELECT 1; SELECT 2;';
      const stmts = parse(sql);
      expect(stmts[0].location).toEqual(loc(1, 1, 0, 1, 9, 8));
      expect(slice(sql, stmts[0].location!)).toBe('SELECT 1');
      expect(stmts[1].location).toEqual(loc(1, 11, 10, 1, 19, 18));
      expect(slice(sql, stmts[1].location!)).toBe('SELECT 2');
    });

    it('has location spanning multiple lines', () => {
      const sql = 'SELECT\n  1\nFROM t;';
      const stmts = parse(sql);
      expect(stmts[0].location).toEqual(loc(1, 1, 0, 3, 7, 17));
      expect(slice(sql, stmts[0].location!)).toBe('SELECT\n  1\nFROM t');
    });

    it('has location on SET statement', () => {
      const sql = 'SET max_threads = 4;';
      const stmts = parse(sql);
      expect(stmts[0].location).toEqual(loc(1, 1, 0, 1, 20, 19));
      expect(slice(sql, stmts[0].location!)).toBe('SET max_threads = 4');
    });

    it('has location on USE statement', () => {
      const sql = 'USE my_db;';
      const stmts = parse(sql);
      expect(stmts[0].location!.start).toEqual({ line: 1, column: 1, offset: 0 });
      expect(slice(sql, stmts[0].location!)).toBe('USE my_db');
    });

    it('has location on UNION statement', () => {
      const sql = 'SELECT 1 UNION ALL SELECT 2;';
      const stmts = parse(sql);
      expect(stmts[0].location).toEqual(loc(1, 1, 0, 1, 28, 27));
      expect(slice(sql, stmts[0].location!)).toBe('SELECT 1 UNION ALL SELECT 2');
    });

    it('has location on EXPLAIN statement', () => {
      const sql = 'EXPLAIN AST SELECT 1;';
      const stmts = parse(sql);
      expect(stmts[0].location).toEqual(loc(1, 1, 0, 1, 21, 20));
      expect(slice(sql, stmts[0].location!)).toBe('EXPLAIN AST SELECT 1');
    });
  });

  describe('expression nodes', () => {
    it('has location on literals', () => {
      const sql = 'SELECT 42, 3.14;';
      const stmts = parse(sql);
      const literals = findNodes(stmts, 'Literal');
      expect(literals[0].location).toEqual(loc(1, 8, 7, 1, 10, 9));
      expect(slice(sql, literals[0].location!)).toBe('42');
      expect(literals[1].location).toEqual(loc(1, 12, 11, 1, 16, 15));
      expect(slice(sql, literals[1].location!)).toBe('3.14');
    });

    it('has location on string literals', () => {
      const sql = "SELECT 'hello';";
      const stmts = parse(sql);
      const literals = findNodes(stmts, 'Literal');
      expect(literals[0].location).toEqual(loc(1, 8, 7, 1, 15, 14));
      expect(slice(sql, literals[0].location!)).toBe("'hello'");
    });

    it('has location on column refs', () => {
      const sql = 'SELECT a, b FROM t;';
      const stmts = parse(sql);
      const refs = findNodes(stmts, 'Identifier');
      expect(refs[0].location).toEqual(loc(1, 8, 7, 1, 9, 8));
      expect(slice(sql, refs[0].location!)).toBe('a');
      expect(refs[1].location).toEqual(loc(1, 11, 10, 1, 12, 11));
      expect(slice(sql, refs[1].location!)).toBe('b');
    });

    it('has location on qualified column refs', () => {
      const sql = 'SELECT t.col FROM t;';
      const stmts = parse(sql);
      const refs = findNodes(stmts, 'Identifier');
      expect(refs[0].location).toEqual(loc(1, 8, 7, 1, 13, 12));
      expect(slice(sql, refs[0].location!)).toBe('t.col');
    });

    it('has location on function calls', () => {
      const sql = 'SELECT count(), sum(x) FROM t;';
      const stmts = parse(sql);
      const funcs = findNodes(stmts, 'Function');
      expect(funcs[0].location).toEqual(loc(1, 8, 7, 1, 15, 14));
      expect(slice(sql, funcs[0].location!)).toBe('count()');
      expect(funcs[1].location).toEqual(loc(1, 17, 16, 1, 23, 22));
      expect(slice(sql, funcs[1].location!)).toBe('sum(x)');
    });

    it('has location on aliases', () => {
      const sql = 'SELECT 1 AS x;';
      const stmts = parse(sql);
      const aliased = findNodes(stmts, 'Literal').filter((n) => n.alias !== undefined);
      expect(aliased[0].location).toEqual(loc(1, 8, 7, 1, 14, 13));
      expect(slice(sql, aliased[0].location!)).toBe('1 AS x');
    });

    it('has location on binary expressions', () => {
      const sql = 'SELECT 1 + 2;';
      const stmts = parse(sql);
      const bins = findNodes(stmts, 'Function').filter((f) => f.is_operator);
      expect(bins).toHaveLength(1);
      expect(slice(sql, bins[0].location!)).toBe('1 + 2');
    });

    it('has location on unary expressions', () => {
      const sql = 'SELECT * FROM t WHERE NOT x;';
      const stmts = parse(sql);
      const unaries = findNodes(stmts, 'Function').filter(
        (f) => f.name === 'not' && f.is_operator === true,
      );
      expect(unaries).toHaveLength(1);
      expect(slice(sql, unaries[0].location!)).toBe('NOT x');
    });

    it('has location on array literals', () => {
      const sql = 'SELECT [1, 2, 3];';
      const stmts = parse(sql);
      const arrays = findNodes(stmts, 'Literal').filter((l) => l.value_type === 'Array');
      expect(arrays[0].location).toEqual(loc(1, 8, 7, 1, 17, 16));
      expect(slice(sql, arrays[0].location!)).toBe('[1, 2, 3]');
    });

    it('has location on subquery expressions', () => {
      const sql = 'SELECT * FROM t WHERE x IN (SELECT 1);';
      const stmts = parse(sql);
      const subs = findNodes(stmts, 'Subquery');
      expect(subs).toHaveLength(1);
      expect(slice(sql, subs[0].location!)).toBe('SELECT 1');
    });

    it('has location on query params', () => {
      const sql = 'SELECT {x:UInt64};';
      const stmts = parse(sql);
      const params = findNodes(stmts, 'QueryParameter');
      expect(params[0].location).toEqual(loc(1, 8, 7, 1, 18, 17));
      expect(slice(sql, params[0].location!)).toBe('{x:UInt64}');
    });

    it('has location on cast expressions', () => {
      const sql = 'SELECT CAST(x AS Int32);';
      const stmts = parse(sql);
      const casts = findNodes(stmts, 'Function').filter((f) => f.name === 'CAST');
      expect(casts[0].location).toEqual(loc(1, 8, 7, 1, 24, 23));
      expect(slice(sql, casts[0].location!)).toBe('CAST(x AS Int32)');
    });

    it('has location on asterisk', () => {
      const sql = 'SELECT * FROM t;';
      const stmts = parse(sql);
      const asterisks = findNodes(stmts, 'Asterisk');
      expect(asterisks[0].location).toEqual(loc(1, 8, 7, 1, 9, 8));
      expect(slice(sql, asterisks[0].location!)).toBe('*');
    });
  });

  describe('FROM clause nodes', () => {
    it('has location on table refs', () => {
      const sql = 'SELECT * FROM my_table;';
      const stmts = parse(sql);
      const tables = findNodes(stmts, 'TableIdentifier');
      expect(tables[0].location).toEqual(loc(1, 15, 14, 1, 23, 22));
      expect(slice(sql, tables[0].location!)).toBe('my_table');
    });

    it('has location on qualified table refs', () => {
      const sql = 'SELECT * FROM db.t;';
      const stmts = parse(sql);
      const tables = findNodes(stmts, 'TableIdentifier');
      expect(tables[0].location).toEqual(loc(1, 15, 14, 1, 19, 18));
      expect(slice(sql, tables[0].location!)).toBe('db.t');
    });

    it('has location on table function refs', () => {
      const sql = 'SELECT * FROM numbers(10);';
      const stmts = parse(sql);
      const funcs = findNodes(stmts, 'TableExpression').filter(
        (t) => t.table_function !== undefined,
      );
      expect(funcs[0].table_function!.location).toEqual(loc(1, 15, 14, 1, 26, 25));
      expect(slice(sql, funcs[0].table_function!.location!)).toBe('numbers(10)');
    });

    it('has location on joined table expressions', () => {
      const sql = 'SELECT * FROM a INNER JOIN b ON a.id = b.id;';
      const stmts = parse(sql);
      const joins = findNodes(stmts, 'TableJoin');
      expect(joins).toHaveLength(1);
      // TableJoin itself carries no location; the joined table expressions do.
      const tables = findNodes(stmts, 'TableExpression');
      expect(slice(sql, tables[0].location!)).toBe('a');
      expect(slice(sql, tables[1].location!)).toBe('b');
    });

    it('has location on array join expressions', () => {
      const sql = 'SELECT * FROM t ARRAY JOIN arr AS a;';
      const stmts = parse(sql);
      const arrayJoins = findNodes(stmts, 'ArrayJoin');
      expect(arrayJoins).toHaveLength(1);
      // ArrayJoin itself carries no location; its joined expressions do.
      expect(slice(sql, arrayJoins[0].expressions[0].location!)).toBe('arr AS a');
    });

    it('has location on subquery FROM sources', () => {
      const sql = 'SELECT * FROM (SELECT 1) AS sub;';
      const stmts = parse(sql);
      const subs = findNodes(stmts, 'TableExpression').filter((t) => t.subquery !== undefined);
      expect(subs).toHaveLength(1);
      expect(slice(sql, subs[0].location!)).toBe('(SELECT 1) AS sub');
    });
  });

  describe('ORDER BY nodes', () => {
    it('has location on order by items', () => {
      const sql = 'SELECT * FROM t ORDER BY a ASC, b DESC;';
      const stmts = parse(sql);
      const items = findNodes(stmts, 'OrderByElement');
      expect(items).toHaveLength(2);
      expect(slice(sql, items[0].location!)).toBe('a ASC');
      expect(slice(sql, items[1].location!)).toBe('b DESC');
    });
  });

  describe('multiline locations', () => {
    it('tracks line and column across newlines', () => {
      const sql = 'SELECT\n  a,\n  b\nFROM t;';
      const stmts = parse(sql);
      const refs = findNodes(stmts, 'Identifier');
      // "a" is on line 2, column 3
      expect(refs[0].location).toEqual(loc(2, 3, 9, 2, 4, 10));
      expect(slice(sql, refs[0].location!)).toBe('a');
      // "b" is on line 3, column 3
      expect(refs[1].location).toEqual(loc(3, 3, 14, 3, 4, 15));
      expect(slice(sql, refs[1].location!)).toBe('b');
    });
  });

  describe('location text extraction', () => {
    it('offsets can be used to extract original source text', () => {
      const sql = 'SELECT my_func(a, b), col FROM t;';
      const stmts = parse(sql);
      const funcs = findNodes(stmts, 'Function');
      expect(slice(sql, funcs[0].location!)).toBe('my_func(a, b)');
    });

    it('extracts nested expression source text', () => {
      const sql = 'SELECT a + b * c FROM t;';
      const stmts = parse(sql);
      const bins = findNodes(stmts, 'Function').filter((f) => f.is_operator);
      const sources = bins.map((b) => slice(sql, b.location!));
      expect(sources).toContain('a + b * c');
      expect(sources).toContain('b * c');
    });

    it('extracts IN expression source text', () => {
      const sql = 'SELECT * FROM t WHERE x IN (1, 2, 3);';
      const stmts = parse(sql);
      const inExprs = findNodes(stmts, 'Function').filter((f) => f.name === 'in');
      expect(slice(sql, inExprs[0].location!)).toBe('x IN (1, 2, 3)');
    });

    it('extracts nary expression source text', () => {
      const sql = 'SELECT * FROM t WHERE a AND b AND c;';
      const stmts = parse(sql);
      const narys = findNodes(stmts, 'Function').filter(
        (f) => f.name === 'and' && f.is_operator === true,
      );
      expect(slice(sql, narys[0].location!)).toBe('a AND b AND c');
    });

    it('extracts lambda expression source text', () => {
      const sql = 'SELECT arrayMap(x -> x + 1, arr);';
      const stmts = parse(sql);
      const lambdas = findNodes(stmts, 'Function').filter((f) => f.is_lambda_function);
      expect(slice(sql, lambdas[0].location!)).toBe('x -> x + 1');
    });

    it('extracts tuple source text', () => {
      const sql = "SELECT (1, 'a', 3.14);";
      const stmts = parse(sql);
      const tuples = findNodes(stmts, 'Literal').filter((l) => l.value_type === 'Tuple');
      expect(slice(sql, tuples[0].location!)).toBe("(1, 'a', 3.14)");
    });
  });

  describe('locations option', () => {
    it('includes locations by default', () => {
      const stmts = parse('SELECT a + 1 FROM t');
      expect(stmts[0].location).toBeDefined();
      for (const node of findNodes(stmts, 'Function')) {
        expect(node.location).toBeDefined();
      }
    });

    it('includes locations when locations: true is explicit', () => {
      const stmts = parse('SELECT a + 1 FROM t', { locations: true });
      expect(stmts[0].location).toBeDefined();
    });

    it('omits all locations when locations: false', () => {
      const sql = 'SELECT a + 1 FROM t WHERE x IN (1, 2) ORDER BY a';
      const stmts = parse(sql, { locations: false });

      // No node anywhere in the tree carries a location.
      const seen = new Set<unknown>();
      function assertNoLocation(node: unknown): void {
        if (node === null || typeof node !== 'object') return;
        if (seen.has(node)) return;
        seen.add(node);
        if (Array.isArray(node)) {
          node.forEach(assertNoLocation);
          return;
        }
        const obj = node as Record<string, unknown>;
        expect(obj.location).toBeUndefined();
        for (const [k, v] of Object.entries(obj)) {
          if (k === 'parent') continue;
          assertNoLocation(v);
        }
      }
      assertNoLocation(stmts);
    });

    it('produces a JSON-serializable AST when locations: false', () => {
      const stmts = parse('SELECT 1', { locations: false });
      expect(() => JSON.stringify(stmts)).not.toThrow();
    });
  });
});
