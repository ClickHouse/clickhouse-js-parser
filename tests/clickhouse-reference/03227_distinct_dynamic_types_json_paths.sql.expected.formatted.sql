-- Tags: long
SET allow_experimental_dynamic_type = '1';

SET enable_json_type = '1';

SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

SET max_block_size = '10000';

DROP TABLE IF EXISTS test_json_dynamic_aggregate_functions;

CREATE TABLE test_json_dynamic_aggregate_functions
(
    json JSON(a1 String, max_dynamic_paths = 2, max_dynamic_types = 2)
)
ENGINE = Memory();

INSERT INTO test_json_dynamic_aggregate_functions SELECT toJSONString(map('a' || number % 13, multiIf(number % 5 = 0, NULL, number % 5 = 1, number::UInt32, number % 5 = 2, 'str_' || number, number % 5 = 3, range(number % 5), toBool(number % 2))))
FROM numbers(100000);

SELECT arrayJoin(distinctJSONPaths(json))
FROM test_json_dynamic_aggregate_functions;

SELECT arrayJoin(distinctJSONPathsAndTypes(json))
FROM test_json_dynamic_aggregate_functions;

SELECT arrayJoin(distinctDynamicTypes(json.a2))
FROM test_json_dynamic_aggregate_functions;

SELECT arrayJoin(distinctDynamicTypes(json.a3))
FROM test_json_dynamic_aggregate_functions;

SELECT arrayJoin(distinctDynamicTypes(json.a42))
FROM test_json_dynamic_aggregate_functions;

SELECT arrayJoin(distinctJSONPaths(json))
FROM test_json_dynamic_aggregate_functions
WHERE dynamicType(json.a2) = 'String';

SELECT arrayJoin(distinctJSONPathsAndTypes(json))
FROM test_json_dynamic_aggregate_functions
WHERE dynamicType(json.a2) = 'String';

SELECT arrayJoin(distinctDynamicTypes(json.a2))
FROM test_json_dynamic_aggregate_functions
WHERE dynamicType(json.a2) = 'String';

SELECT arrayJoin(distinctJSONPathsIf(json, dynamicType(json.a2) = 'String'))
FROM test_json_dynamic_aggregate_functions;

SELECT arrayJoin(distinctJSONPathsAndTypesIf(json, dynamicType(json.a2) = 'String'))
FROM test_json_dynamic_aggregate_functions;

SELECT arrayJoin(distinctDynamicTypesIf(json.a2, dynamicType(json.a2) = 'String'))
FROM test_json_dynamic_aggregate_functions;

SELECT
    dynamicType(json.a2),
    distinctJSONPaths(json)
FROM test_json_dynamic_aggregate_functions
GROUP BY dynamicType(json.a2)
ORDER BY dynamicType(json.a2) ASC;

SELECT
    dynamicType(json.a2),
    distinctJSONPathsAndTypes(json)
FROM test_json_dynamic_aggregate_functions
GROUP BY dynamicType(json.a2)
ORDER BY dynamicType(json.a2) ASC;

SELECT
    dynamicType(json.a2),
    distinctDynamicTypes(json.a2)
FROM test_json_dynamic_aggregate_functions
GROUP BY dynamicType(json.a2)
ORDER BY dynamicType(json.a2) ASC;

SELECT arrayJoin(distinctJSONPaths(json))
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions);

SELECT arrayJoin(distinctJSONPathsAndTypes(json))
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions);

SELECT arrayJoin(distinctDynamicTypes(json.a2))
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions);

SELECT arrayJoin(distinctJSONPaths(json))
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions)
WHERE dynamicType(json.a2) = 'String';

SELECT arrayJoin(distinctJSONPathsAndTypes(json))
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions)
WHERE dynamicType(json.a2) = 'String';

SELECT arrayJoin(distinctDynamicTypes(json.a2))
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions)
WHERE dynamicType(json.a2) = 'String';

SELECT arrayJoin(distinctJSONPathsIf(json, dynamicType(json.a2) = 'String'))
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions);

SELECT arrayJoin(distinctJSONPathsAndTypesIf(json, dynamicType(json.a2) = 'String'))
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions);

SELECT arrayJoin(distinctDynamicTypesIf(json.a2, dynamicType(json.a2) = 'String'))
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions);

SELECT
    dynamicType(json.a2),
    distinctJSONPaths(json)
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions)
GROUP BY dynamicType(json.a2)
ORDER BY dynamicType(json.a2) ASC;

SELECT
    dynamicType(json.a2),
    distinctJSONPathsAndTypes(json)
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions)
GROUP BY dynamicType(json.a2)
ORDER BY dynamicType(json.a2) ASC;

SELECT
    dynamicType(json.a2),
    distinctDynamicTypes(json.a2)
FROM remote('127.0.0.{1,2,3}', currentDatabase(), test_json_dynamic_aggregate_functions)
GROUP BY dynamicType(json.a2)
ORDER BY dynamicType(json.a2) ASC;

SELECT distinctJSONPaths()
FROM test_json_dynamic_aggregate_functions; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT distinctJSONPaths(json, 42)
FROM test_json_dynamic_aggregate_functions; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT distinctJSONPaths(42)
FROM test_json_dynamic_aggregate_functions; -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT distinctJSONPathsAndTypes()
FROM test_json_dynamic_aggregate_functions; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT distinctJSONPathsAndTypes(json, 42)
FROM test_json_dynamic_aggregate_functions; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT distinctJSONPathsAndTypes(42)
FROM test_json_dynamic_aggregate_functions; -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT distinctDynamicTypes()
FROM test_json_dynamic_aggregate_functions; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT distinctDynamicTypes(json.a2, 42)
FROM test_json_dynamic_aggregate_functions; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT distinctDynamicTypes(42)
FROM test_json_dynamic_aggregate_functions; -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

DROP TABLE test_json_dynamic_aggregate_functions;