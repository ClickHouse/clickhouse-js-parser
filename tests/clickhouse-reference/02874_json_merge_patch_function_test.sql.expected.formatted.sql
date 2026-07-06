-- Tags: no-fasttest
SELECT jsonMergePatch(NULL);

SELECT jsonMergePatch('{"a":1}');

SELECT jsonMergePatch('{"a":1}', '{"b":1}');

SELECT jsonMergePatch('{"a":1}', '{"b":1}', '{"c":[1,2]}');

SELECT jsonMergePatch('{"a":1}', '{"b":1}', '{"c":[{"d":1},2]}');

SELECT jsonMergePatch('{"a":1}', '{"name": "joey"}', '{"name": "tom"}', '{"name": "zoey"}');

SELECT jsonMergePatch('{"a": "1","b": 2,"c": [true,{"qrdzkzjvnos": true,"yxqhipj": false,"oesax": "33o8_6AyUy"}]}', '{"c": "1"}');

SELECT jsonMergePatch('{"a": {"b": 1, "c": 2}}', '{"a": {"b": [3, 4]}}');

SELECT jsonMergePatch('{ "a": 1, "b":2 }', '{ "a": 3, "c":4 }', '{ "a": 5, "d":6 }');

SELECT jsonMergePatch('{"a":1, "b":2}', '{"b":null}');

SELECT jsonMergePatch('[1]'); -- { serverError BAD_ARGUMENTS }

SELECT jsonMergePatch('{"a": "1","b": 2,"c": [true,"qrdzkzjvnos": true,"yxqhipj": false,"oesax": "33o8_6AyUy"}]}', '{"c": "1"}'); -- { serverError BAD_ARGUMENTS }

DROP TABLE IF EXISTS t_json_merge;

CREATE TABLE t_json_merge
(
    id UInt64,
    s1 String,
    s2 String
)
ENGINE = Memory();

INSERT INTO t_json_merge SELECT
    number,
    format('{{ "k{0}": {0} }}', toString(number * 2)),
    format('{{ "k{0}": {0} }}', toString(number * 2 + 1))
FROM numbers(5);

INSERT INTO t_json_merge SELECT
    number,
    format('{{ "k{0}": {0} }}', toString(number * 2)),
    format('{{ "k{0}": {0}, "k{1}": 222 }}', toString(number * 2 + 1), toString(number * 2))
FROM numbers(5, 5);

SELECT jsonMergePatch(s1, s2)
FROM t_json_merge
ORDER BY id ASC;

DROP TABLE t_json_merge;