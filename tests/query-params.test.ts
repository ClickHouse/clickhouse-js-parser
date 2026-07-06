import { format, parse } from '../src/index';
import { stripVolatile } from './helpers';

/**
 * Helper: parse SQL, snapshot the AST, then format and re-parse to verify round-trip.
 */
function parseAndSnap(sql: string) {
  const statements = parse(sql);
  expect(stripVolatile(statements)).toMatchSnapshot();
  const formatted = format(statements);
  const reparsed = parse(formatted);
  expect(stripVolatile(reparsed)).toEqual(stripVolatile(statements));
  return { statements, formatted };
}

describe('Query Parameter Parsing and Formatting', () => {
  describe('basic parameter types', () => {
    it('parses simple scalar types', () => {
      parseAndSnap('SELECT {x:UInt64}, {y:String}, {z:Float64};');
    });

    it('parses date/time types', () => {
      parseAndSnap('SELECT {d:Date}, {dt:DateTime}, {dt64:DateTime64};');
    });

    it('parses boolean and UUID types', () => {
      parseAndSnap('SELECT {b:Bool}, {u:UUID};');
    });

    it('parses Int types', () => {
      parseAndSnap('SELECT {a:Int8}, {b:Int16}, {c:Int32}, {d:Int64}, {e:Int128}, {f:Int256};');
    });

    it('parses UInt types', () => {
      parseAndSnap(
        'SELECT {a:UInt8}, {b:UInt16}, {c:UInt32}, {d:UInt64}, {e:UInt128}, {f:UInt256};',
      );
    });

    it('parses Float types', () => {
      parseAndSnap('SELECT {a:Float32}, {b:Float64};');
    });

    it('parses Decimal types', () => {
      parseAndSnap('SELECT {a:Decimal(10, 2)}, {b:Decimal128(4)}, {c:Decimal256(8)};');
    });

    it('parses FixedString type', () => {
      parseAndSnap('SELECT {fs:FixedString(16)};');
    });
  });

  describe('complex parameter types', () => {
    it('parses Nullable type', () => {
      parseAndSnap('SELECT {x:Nullable(UInt64)}, {y:Nullable(String)};');
    });

    it('parses Array type', () => {
      parseAndSnap('SELECT {arr:Array(UInt64)}, {sarr:Array(String)};');
    });

    it('parses nested Array type', () => {
      parseAndSnap('SELECT {nested:Array(Array(UInt32))};');
    });

    it('parses Nullable Array type', () => {
      parseAndSnap('SELECT {x:Array(Nullable(String))};');
    });

    it('parses Map type', () => {
      parseAndSnap('SELECT {m:Map(String, UInt64)};');
    });

    it('parses complex Map type', () => {
      parseAndSnap('SELECT {m:Map(UUID, Array(Float32))};');
    });

    it('parses Tuple type', () => {
      parseAndSnap('SELECT {t:Tuple(UInt64, String, Float32)};');
    });

    it('parses named Tuple type', () => {
      parseAndSnap('SELECT {t:Tuple(a UInt64, b String)};');
    });

    it('parses LowCardinality type', () => {
      parseAndSnap('SELECT {lc:LowCardinality(String)};');
    });

    it('parses LowCardinality Nullable type', () => {
      parseAndSnap('SELECT {lc:LowCardinality(Nullable(String))};');
    });

    it('parses Enum type', () => {
      parseAndSnap("SELECT {e:Enum8('a' = 1, 'b' = 2)};");
    });
  });

  describe('positional parameters ($N syntax)', () => {
    it('parses $0 positional parameter', () => {
      parseAndSnap('SELECT {$0:UInt64};');
    });

    it('parses multiple positional parameters', () => {
      parseAndSnap('SELECT {$0:UInt64}, {$1:String}, {$2:Float64};');
    });

    it('mixes positional and named parameters', () => {
      parseAndSnap('SELECT {$0:UInt64}, {name:String};');
    });
  });

  describe('Identifier type parameters', () => {
    it('parses Identifier parameter in table reference', () => {
      parseAndSnap('SELECT 1 FROM {tbl:Identifier};');
    });

    it('parses Identifier parameter for database and table', () => {
      parseAndSnap('SELECT 1 FROM {db:Identifier}.{tbl:Identifier};');
    });

    it('parses Identifier parameter with regular table', () => {
      parseAndSnap('SELECT 1 FROM {db:Identifier}.my_table;');
    });

    it('parses Identifier parameter as database with table param', () => {
      parseAndSnap('SELECT * FROM {db:Identifier}.{tbl:Identifier} LIMIT 1;');
    });
  });

  describe('parameters in SELECT clause', () => {
    it('uses parameter as selected expression', () => {
      parseAndSnap('SELECT {x:UInt64};');
    });

    it('uses parameter with alias', () => {
      parseAndSnap('SELECT {x:UInt64} AS val;');
    });

    it('uses parameter in arithmetic expression', () => {
      parseAndSnap('SELECT {x:UInt64} + {y:UInt64};');
    });

    it('uses parameter in function call', () => {
      parseAndSnap('SELECT toDate({d:String});');
    });

    it('uses parameter with multiple expressions', () => {
      parseAndSnap('SELECT {a:UInt64}, {b:String}, {c:Float64};');
    });

    it('uses parameter in CAST expression', () => {
      parseAndSnap('SELECT CAST({x:String} AS UInt64);');
    });

    it('uses parameter with :: cast operator', () => {
      parseAndSnap('SELECT {x:String}::UInt64;');
    });
  });

  describe('parameters in FROM clause', () => {
    it('uses Identifier parameter as table name', () => {
      parseAndSnap('SELECT * FROM {tbl:Identifier};');
    });

    it('uses Identifier parameter as database.table', () => {
      parseAndSnap('SELECT * FROM {db:Identifier}.{tbl:Identifier};');
    });
  });

  describe('parameters in WHERE clause', () => {
    it('uses parameter in equality comparison', () => {
      parseAndSnap('SELECT * FROM t WHERE x = {val:UInt64};');
    });

    it('uses parameter in inequality comparison', () => {
      parseAndSnap('SELECT * FROM t WHERE x != {val:String};');
    });

    it('uses parameter in range comparison', () => {
      parseAndSnap('SELECT * FROM t WHERE x > {lo:UInt64} AND x < {hi:UInt64};');
    });

    it('uses parameter with BETWEEN', () => {
      parseAndSnap('SELECT * FROM t WHERE x BETWEEN {lo:UInt64} AND {hi:UInt64};');
    });

    it('uses parameter in LIKE expression', () => {
      parseAndSnap('SELECT * FROM t WHERE name LIKE {pattern:String};');
    });

    it('uses parameter in IN expression', () => {
      parseAndSnap('SELECT * FROM t WHERE x IN ({val:UInt64});');
    });

    it('uses parameter with IS NULL check', () => {
      parseAndSnap('SELECT * FROM t WHERE {x:Nullable(UInt64)} IS NULL;');
    });

    it('uses parameter on both sides of comparison', () => {
      parseAndSnap('SELECT * FROM t WHERE {a:UInt64} = {b:UInt64};');
    });

    it('uses parameter in complex boolean expression', () => {
      parseAndSnap("SELECT * FROM t WHERE {a:UInt64} > 0 AND {b:String} != '' OR {c:Bool};");
    });
  });

  describe('parameters in GROUP BY clause', () => {
    it('uses parameter in GROUP BY', () => {
      parseAndSnap('SELECT {x:UInt64}, count() FROM t GROUP BY {x:UInt64};');
    });
  });

  describe('parameters in HAVING clause', () => {
    it('uses parameter in HAVING', () => {
      parseAndSnap('SELECT x, count() AS cnt FROM t GROUP BY x HAVING cnt > {min_count:UInt64};');
    });
  });

  describe('parameters in ORDER BY clause', () => {
    it('uses parameter in ORDER BY expression', () => {
      parseAndSnap('SELECT * FROM t ORDER BY {col:UInt64} ASC;');
    });
  });

  describe('parameters in LIMIT/OFFSET clause', () => {
    it('uses parameter in LIMIT', () => {
      parseAndSnap('SELECT * FROM t LIMIT {n:UInt64};');
    });

    it('uses parameter in OFFSET', () => {
      parseAndSnap('SELECT * FROM t LIMIT 10 OFFSET {off:UInt64};');
    });

    it('uses parameter in both LIMIT and OFFSET', () => {
      parseAndSnap('SELECT * FROM t LIMIT {n:UInt64} OFFSET {off:UInt64};');
    });
  });

  describe('parameters in JOIN clause', () => {
    it('uses parameter in JOIN ON condition', () => {
      parseAndSnap(
        'SELECT * FROM t1 INNER JOIN t2 ON t1.id = t2.id AND t2.val > {min_val:UInt64};',
      );
    });
  });

  describe('parameters in PREWHERE clause', () => {
    it('uses parameter in PREWHERE', () => {
      parseAndSnap('SELECT * FROM t PREWHERE x > {threshold:UInt64};');
    });
  });

  describe('parameters in CTE (WITH clause)', () => {
    it('uses parameter in CTE expression', () => {
      parseAndSnap('WITH {x:UInt64} AS val SELECT val;');
    });
  });

  describe('parameters in SETTINGS clause', () => {
    it('uses parameter in SETTINGS value', () => {
      parseAndSnap('SELECT * FROM t SETTINGS max_threads = {threads:UInt64};');
    });
  });

  describe('parameters in subqueries', () => {
    it('uses parameter in subquery WHERE', () => {
      parseAndSnap('SELECT * FROM (SELECT * FROM t WHERE x = {val:UInt64});');
    });

    it('uses parameter in IN subquery', () => {
      parseAndSnap('SELECT * FROM t WHERE x IN (SELECT id FROM t2 WHERE y > {threshold:UInt64});');
    });
  });

  describe('parameters in UNION queries', () => {
    it('uses parameter in UNION ALL members', () => {
      parseAndSnap('SELECT {a:UInt64} UNION ALL SELECT {b:UInt64};');
    });
  });

  describe('parameter formatting', () => {
    it('normalizes whitespace around colon', () => {
      const stmts = parse('SELECT {x:UInt64};');
      expect(stripVolatile(stmts)).toMatchSnapshot();
      const formatted = format(stmts);
      expect(formatted).toContain('{x:UInt64}');
    });

    it('preserves complex type string in formatting', () => {
      const stmts = parse('SELECT {m:Map(UUID, Array(Float32))};');
      expect(stripVolatile(stmts)).toMatchSnapshot();
      const formatted = format(stmts);
      expect(formatted).toContain('{m:Map(UUID, Array(Float32))}');
    });

    it('preserves positional parameter names', () => {
      const stmts = parse('SELECT {$0:UInt64};');
      expect(stripVolatile(stmts)).toMatchSnapshot();
      const formatted = format(stmts);
      expect(formatted).toContain('{$0:UInt64}');
    });
  });

  describe('parameters in expressions with operators', () => {
    it('uses parameter with concatenation operator', () => {
      parseAndSnap("SELECT {prefix:String} || '_suffix';");
    });

    it('uses parameter with negation', () => {
      parseAndSnap('SELECT -{x:UInt64};');
    });

    it('uses parameter in CASE expression', () => {
      parseAndSnap("SELECT CASE WHEN x > {threshold:UInt64} THEN 'high' ELSE 'low' END FROM t;");
    });

    it('uses parameter in array subscript', () => {
      parseAndSnap('SELECT arr[{idx:UInt64}] FROM t;');
    });

    it('uses parameter as function argument with multiple args', () => {
      parseAndSnap('SELECT if({cond:Bool}, {a:UInt64}, {b:UInt64});');
    });
  });
});
