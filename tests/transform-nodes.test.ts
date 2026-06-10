import { parse, transformNodes, findNodes, format } from '../src/index';

describe('transformNodes', () => {
  describe('returns unchanged AST when visitor is identity', () => {
    it('returns the same array reference when nothing changes', () => {
      const stmts = parse('SELECT 1');
      const result = transformNodes(stmts, 'Literal', (n) => n);
      expect(result).toBe(stmts);
    });

    it('returns same reference for query with params', () => {
      const stmts = parse('SELECT {x:UInt64}');
      const result = transformNodes(stmts, 'QueryParameter', (n) => n);
      expect(result).toBe(stmts);
    });
  });

  describe('transforms nodes of the same kind', () => {
    it('renames query parameters', () => {
      const stmts = parse('SELECT {x:UInt64}, {y:String}');
      const result = transformNodes(stmts, 'QueryParameter', (n) => ({
        ...n,
        name: `p_${n.name}`,
      }));
      const params = findNodes(result, 'QueryParameter');
      expect(params.map((p) => p.name)).toEqual(['p_x', 'p_y']);
    });

    it('changes literal values', () => {
      const stmts = parse('SELECT 1, 2, 3');
      const result = transformNodes(stmts, 'Literal', (n) => {
        const scaled = String(Number(n.value) * 10);
        return { ...n, value: scaled, _raw: scaled };
      });
      const literals = findNodes(result, 'Literal');
      expect(literals.map((l) => l.value)).toEqual(['10', '20', '30']);
    });

    it('renames column references', () => {
      const stmts = parse('SELECT a, b FROM t');
      const result = transformNodes(stmts, 'Identifier', (n) => ({
        ...n,
        name: n.name.toUpperCase(),
      }));
      const cols = findNodes(result, 'Identifier');
      expect(cols.map((c) => c.name)).toEqual(['A', 'B']);
    });

    it('renames table references', () => {
      const stmts = parse('SELECT * FROM old_table');
      const result = transformNodes(stmts, 'TableIdentifier', (n) => ({
        ...n,
        name: 'new_table',
      }));
      expect(format(result)).toBe('SELECT *\nFROM new_table;');
    });
  });

  describe('replaces node with a different kind in the same position', () => {
    it('replaces query param with a literal', () => {
      const stmts = parse('SELECT {x:UInt64}');
      const result = transformNodes(stmts, 'QueryParameter', () => ({
        type: 'Literal' as const,
        value_type: 'UInt64' as const,
        value: '42',
        _raw: '42',
      }));
      expect(findNodes(result, 'QueryParameter')).toHaveLength(0);
      expect(findNodes(result, 'Literal').map((l) => l.value)).toContain('42');
    });

    it('replaces column ref with a function call', () => {
      const stmts = parse('SELECT a FROM t');
      const result = transformNodes(stmts, 'Identifier', (n) => ({
        type: 'Function' as const,
        name: 'toString',
        arguments: [{ ...n }],
      }));
      const funcs = findNodes(result, 'Function');
      expect(funcs.map((f) => f.name)).toContain('toString');
      expect(format(result)).toBe('SELECT toString(a)\nFROM t;');
    });

    it('replaces a query param in a WHERE clause and formats correctly', () => {
      const stmts = parse('SELECT * FROM t WHERE x = {id:UInt64}');
      const result = transformNodes(stmts, 'QueryParameter', () => ({
        type: 'Literal' as const,
        value_type: 'String' as const,
        value: 'abc',
      }));
      expect(format(result)).toBe("SELECT *\nFROM t\nWHERE x = 'abc';");
    });
  });

  describe('immutability', () => {
    it('does not mutate the original AST', () => {
      const stmts = parse('SELECT {x:UInt64}');
      const original = findNodes(stmts, 'QueryParameter')[0].name;

      transformNodes(stmts, 'QueryParameter', (n) => ({ ...n, name: 'replaced' }));

      expect(findNodes(stmts, 'QueryParameter')[0].name).toBe(original);
    });

    it('shares unchanged subtrees with the original', () => {
      const stmts = parse('SELECT a FROM t WHERE x = {p:UInt64}');
      const result = transformNodes(stmts, 'QueryParameter', (n) => ({
        ...n,
        name: 'new_p',
      }));

      const origTable = findNodes(stmts, 'TableIdentifier')[0];
      const newTable = findNodes(result, 'TableIdentifier')[0];
      expect(origTable).toBeDefined();
      expect(newTable).toBe(origTable);
    });
  });

  describe('deeply nested nodes', () => {
    it('transforms inside subqueries', () => {
      const stmts = parse('SELECT * FROM (SELECT {x:UInt64})');
      const result = transformNodes(stmts, 'QueryParameter', (n) => ({
        ...n,
        param_type: 'String',
      }));
      const params = findNodes(result, 'QueryParameter');
      expect(params[0].param_type).toBe('String');
    });

    it('transforms inside CTEs', () => {
      const stmts = parse('WITH cte AS (SELECT {x:UInt64}) SELECT * FROM cte');
      const result = transformNodes(stmts, 'QueryParameter', (n) => ({
        ...n,
        name: 'renamed',
      }));
      const params = findNodes(result, 'QueryParameter');
      expect(params[0].name).toBe('renamed');
    });

    it('transforms inside JOIN ON conditions', () => {
      const stmts = parse('SELECT * FROM t1 JOIN t2 ON t1.id = {p:UInt64}');
      const result = transformNodes(stmts, 'QueryParameter', (n) => ({
        ...n,
        name: 'join_param',
      }));
      const params = findNodes(result, 'QueryParameter');
      expect(params[0].name).toBe('join_param');
    });
  });

  describe('formatting round-trip', () => {
    it('produces valid SQL after transforming table names', () => {
      const stmts = parse('SELECT a, b FROM old_db.old_table WHERE x > 1');
      const result = transformNodes(stmts, 'TableIdentifier', (n) => ({
        ...n,
        database: 'new_db',
        name: 'new_table',
      }));
      expect(format(result)).toBe('SELECT\n    a,\n    b\nFROM new_db.new_table\nWHERE x > 1;');
    });

    it('produces valid SQL after transforming query params', () => {
      const stmts = parse('SELECT * FROM t WHERE id = {id:UInt64} AND name = {name:String}');
      const result = transformNodes(stmts, 'QueryParameter', (n) => ({
        ...n,
        name: `v_${n.name}`,
      }));
      expect(format(result)).toBe(
        'SELECT *\nFROM t\nWHERE id = {v_id:UInt64}\n    AND name = {v_name:String};',
      );
    });
  });

  describe('multiple statements', () => {
    it('transforms across multiple statements', () => {
      const stmts = parse('SELECT {a:UInt64}; SELECT {b:String}');
      const result = transformNodes(stmts, 'QueryParameter', (n) => ({
        ...n,
        name: n.name.toUpperCase(),
      }));
      const params = findNodes(result, 'QueryParameter');
      expect(params.map((p) => p.name)).toEqual(['A', 'B']);
    });
  });

  // Coverage for node kinds that were previously absent from NodePositionMap
  // and therefore not transformable through the typed API. Each kind is now
  // reachable without a cast (structural sub-nodes stay in self-position;
  // statement-position kinds may return any Statement).
  describe('structural and statement sub-nodes are transformable', () => {
    it('transforms Storage nodes (self-position)', () => {
      const stmts = parse('CREATE TABLE t (a UInt64) ENGINE = MergeTree ORDER BY a');
      let seen = 0;
      const result = transformNodes(stmts, 'Storage', (n) => {
        seen++;
        return { ...n };
      });
      expect(seen).toBe(1);
      expect(findNodes(result, 'Storage')).toHaveLength(1);
    });

    it('transforms DataType nodes (self-position)', () => {
      const stmts = parse('CREATE TABLE t (a UInt64) ENGINE = Memory');
      const result = transformNodes(stmts, 'DataType', (n) =>
        n.name === 'UInt64' ? { ...n, name: 'Int64' } : n,
      );
      expect(findNodes(result, 'DataType').map((d) => d.name)).toContain('Int64');
    });

    it('transforms AlterCommand nodes (self-position)', () => {
      const stmts = parse('ALTER TABLE t ADD COLUMN a UInt64');
      let seen = 0;
      transformNodes(stmts, 'AlterCommand', (n) => {
        seen++;
        return n;
      });
      expect(seen).toBe(1);
    });

    it('transforms Assignment nodes (self-position)', () => {
      const stmts = parse('UPDATE t SET a = 1 WHERE b = 2');
      const result = transformNodes(stmts, 'Assignment', (n) => ({ ...n, column: 'renamed' }));
      expect(findNodes(result, 'Assignment').map((a) => a.column)).toEqual(['renamed']);
    });

    it('transforms RevokeQuery nodes (statement-position)', () => {
      const stmts = parse('REVOKE SELECT ON db.* FROM u');
      let seen = 0;
      transformNodes(stmts, 'RevokeQuery', (n) => {
        seen++;
        return n;
      });
      expect(seen).toBe(1);
    });
  });
});
