-- Tags: no-fasttest
SET enable_json_type = '1';

SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

SET enable_named_columns_in_function_tuple = '1';

SET enable_analyzer = '1';

SELECT
    map('a', number::UInt32, 'b', toDate(number), 'c', range(number), 'd', [map('e', number::UInt32)])::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM numbers(5);

SELECT
    map('a' || number % 3, number::UInt32, 'b' || number % 3, toDate(number), 'c' || number % 3, range(number), 'd' || number % 3, [map('e' || number % 3, number::UInt32)])::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM numbers(5);

SELECT
    tuple(number::UInt32 AS a, toDate(number) AS b, range(number) AS c, [tuple(number::UInt32 AS e)] AS d)::JSON AS json,
    JSONAllPathsWithTypes(json)
FROM numbers(5);