SET allow_experimental_dynamic_type = '1';

SET input_format_json_infer_array_of_dynamic_from_array_of_different_types = '0';

SELECT
    d,
    dynamicType(d)
FROM format(JSONEachRow, 'd Dynamic', '\n{"d" : 42}\n{"d" : 42.42}\n{"d" : "str"}\n{"d" : [1, 2, 3]}\n{"d" : "2020-01-01"}\n{"d" : "2020-01-01 10:00:00"}\n{"d" : {"a" : 42, "b" : "str"}}\n{"d" : {"a" : 43}}\n{"d" : {"a" : 44, "c" : [1, 2, 3]}}\n{"d" : [1, "str", [1, 2, 3]]}\n{"d" : null}\n{"d" : true}\n')
FORMAT JSONEachRow;

SELECT
    d,
    dynamicType(d),
    isDynamicElementInSharedData(d)
FROM format(JSONEachRow, 'd Dynamic(max_types=2)', '\n{"d" : 42}\n{"d" : 42.42}\n{"d" : "str"}\n{"d" : null}\n{"d" : true}\n')
FORMAT JSONEachRow;

SELECT
    d,
    dynamicType(d)
FROM format(CSV, 'd Dynamic', '42\n42.42\n"str"\n"[1, 2, 3]"\n"2020-01-01"\n"2020-01-01 10:00:00"\n"[1, ''str'', [1, 2, 3]]"\n\\N\ntrue\n')
FORMAT CSV;

SELECT
    d,
    dynamicType(d)
FROM format(TSV, 'd Dynamic', '42\n42.42\nstr\n[1, 2, 3]\n2020-01-01\n2020-01-01 10:00:00\n[1, ''str'', [1, 2, 3]]\n\\N\ntrue\n')
FORMAT TSV;

SELECT
    d,
    dynamicType(d)
FROM format(Values, 'd Dynamic', '\n(42)\n(42.42)\n(''str'')\n([1, 2, 3])\n(''2020-01-01'')\n(''2020-01-01 10:00:00'')\n(NULL)\n(true)\n')
FORMAT Values;

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    s String
)
ENGINE = Memory();

INSERT INTO test;

SET cast_string_to_dynamic_use_inference = '1';

SELECT
    s::Dynamic AS d,
    dynamicType(d)
FROM test;

SELECT
    s::Dynamic(max_types = 3) AS d,
    dynamicType(d),
    isDynamicElementInSharedData(d)
FROM test;

DROP TABLE test;