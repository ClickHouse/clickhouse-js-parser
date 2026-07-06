-- { echoOn }
DROP TABLE IF EXISTS test_enum_string_functions;

CREATE TABLE test_enum_string_functions
(
    e Enum('a' = 1, 'b' = 2)
)
ENGINE = TinyLog();

INSERT INTO test_enum_string_functions;

SELECT *
FROM test_enum_string_functions
WHERE e LIKE '%abc%';

SELECT *
FROM test_enum_string_functions
WHERE e NOT LIKE '%abc%';

SELECT *
FROM test_enum_string_functions
WHERE e ILIKE '%a%';

SELECT position(e, 'a')
FROM test_enum_string_functions;

SELECT match(e, 'a')
FROM test_enum_string_functions;

SELECT locate('a', e)
FROM test_enum_string_functions;

SELECT countSubstrings(e, 'a')
FROM test_enum_string_functions;

SELECT countSubstringsCaseInsensitive(e, 'a')
FROM test_enum_string_functions;

SELECT countSubstringsCaseInsensitiveUTF8(e, 'a')
FROM test_enum_string_functions;

SELECT hasToken(e, 'a')
FROM test_enum_string_functions;

SELECT hasTokenOrNull(e, 'a')
FROM test_enum_string_functions;

DROP TABLE IF EXISTS jsons;

CREATE TABLE jsons
(
    json Enum('a', '{"a":1}')
)
ENGINE = Memory();

INSERT INTO jsons;

INSERT INTO jsons;

SELECT simpleJSONHas(json, 'foo') AS res
FROM jsons
ORDER BY res ASC;

SELECT simpleJSONHas(json, 'a') AS res
FROM jsons
ORDER BY res ASC;

SELECT simpleJSONExtractUInt(json, 'a') AS res
FROM jsons
ORDER BY res ASC;

SELECT simpleJSONExtractUInt(json, 'not exsits') AS res
FROM jsons
ORDER BY res ASC;

SELECT simpleJSONExtractInt(json, 'a') AS res
FROM jsons
ORDER BY res ASC;

SELECT simpleJSONExtractInt(json, 'not exsits') AS res
FROM jsons
ORDER BY res ASC;

SELECT simpleJSONExtractFloat(json, 'a') AS res
FROM jsons
ORDER BY res ASC;

SELECT simpleJSONExtractFloat(json, 'not exsits') AS res
FROM jsons
ORDER BY res ASC;

SELECT simpleJSONExtractBool(json, 'a') AS res
FROM jsons
ORDER BY res ASC;

SELECT simpleJSONExtractBool(json, 'not exsits') AS res
FROM jsons
ORDER BY res ASC;

SELECT positionUTF8(json, 'a') AS res
FROM jsons
ORDER BY res ASC;

SELECT positionCaseInsensitiveUTF8(json, 'A') AS res
FROM jsons
ORDER BY res ASC;

SELECT positionCaseInsensitive(json, 'A') AS res
FROM jsons
ORDER BY res ASC;

SELECT materialize(CAST('a' AS Enum('a' = 1))) LIKE randomString(0)
FROM numbers(10);

SELECT CAST('a' AS Enum('a' = 1)) LIKE randomString(0); -- {serverError ILLEGAL_COLUMN}

SELECT materialize(CAST('a' AS Enum16('a' = 1))) LIKE randomString(0)
FROM numbers(10);

SELECT CAST('a' AS Enum16('a' = 1)) LIKE randomString(0); -- {serverError ILLEGAL_COLUMN}

SELECT CAST('a' AS Enum('a' = 1)) LIKE 'a';

SELECT materialize(CAST('a' AS Enum('a' = 1))) LIKE 'a'
FROM numbers(10);