-- Test for JSONExtract Decimal precision preservation
-- This test verifies that JSONExtract correctly handles decimal values
-- without losing precision when extracting from JSON numbers
-- Fixes issue #69082
DROP TABLE IF EXISTS test_json_decimal_precision;

CREATE TABLE test_json_decimal_precision
(
    id UInt32,
    json_data String
)
ENGINE = Memory();

-- Insert test data with decimal values that could lose precision
INSERT INTO test_json_decimal_precision;

-- Test 1: Verify that JSONExtract preserves precision for numeric JSON values
SELECT
    'Test 1: JSONExtract with numeric JSON values' AS test_name,
    id,
    json_data,
    JSONExtract(json_data, 'dec', 'Decimal(32,16)') AS extracted_decimal,
    JSONExtractString(json_data, 'dec')::Decimal(32, 16) AS string_cast_decimal,
    JSONExtract(json_data, 'dec', 'Decimal(32,16)') = JSONExtractString(json_data, 'dec')::Decimal(32, 16) AS precision_preserved
FROM test_json_decimal_precision
WHERE id IN (1, 3, 5, 7, 9, 11, 13, 15)
ORDER BY id ASC;

-- Test 2: Verify that JSONExtract preserves precision for string JSON values
SELECT
    'Test 2: JSONExtract with string JSON values' AS test_name,
    id,
    json_data,
    JSONExtract(json_data, 'dec', 'Decimal(32,16)') AS extracted_decimal,
    JSONExtractString(json_data, 'dec')::Decimal(32, 16) AS string_cast_decimal,
    JSONExtract(json_data, 'dec', 'Decimal(32,16)') = JSONExtractString(json_data, 'dec')::Decimal(32, 16) AS precision_preserved
FROM test_json_decimal_precision
WHERE id IN (2, 4, 6, 8, 10, 12, 14, 16)
ORDER BY id ASC;

-- Test 3: Verify specific precision values match expected results
SELECT
    'Test 3: Specific precision verification' AS test_name,
    id,
    json_data,
    JSONExtract(json_data, 'dec', 'Decimal(32,16)') AS extracted_decimal,
    JSONExtractString(json_data, 'dec')::Decimal(32, 16) AS string_cast_decimal,
    JSONExtract(json_data, 'dec', 'Decimal(32,16)') = JSONExtractString(json_data, 'dec')::Decimal(32, 16) AS precision_preserved
FROM test_json_decimal_precision
ORDER BY id ASC;

-- Test 4: Verify that the fix resolves the original issue from #69082
SELECT
    'Test 4: Original issue #69082 verification' AS test_name,
    JSONExtract('{"dec": 111244542.003}', 'dec', 'Decimal(31,16)') AS direct_extraction,
    JSONExtractString('{"dec": 111244542.003}', 'dec')::Decimal(32, 16) AS string_cast,
    toString(JSONExtract('{"dec": 111244542.003}', 'dec', 'Decimal(31,16)')) AS direct_extraction_str,
    toString(JSONExtractString('{"dec": 111244542.003}', 'dec')::Decimal(32, 16)) AS string_cast_str,
    JSONExtract('{"dec": 111244542.003}', 'dec', 'Decimal(31,16)') = JSONExtractString('{"dec": 111244542.003}', 'dec')::Decimal(32, 16) AS issue_resolved;

-- Test 5: Edge cases with very large and very small numbers
SELECT
    'Test 5: Edge cases with extreme precision' AS test_name,
    id,
    json_data,
    JSONExtract(json_data, 'dec', 'Decimal(38,37)') AS extracted_decimal,
    JSONExtractString(json_data, 'dec')::Decimal(38, 37) AS string_cast_decimal,
    JSONExtract(json_data, 'dec', 'Decimal(38,37)') = JSONExtractString(json_data, 'dec')::Decimal(38, 37) AS precision_preserved
FROM test_json_decimal_precision
WHERE id IN (9, 10, 11, 12)
ORDER BY id ASC;

-- Test 6: Performance test with multiple values
SELECT
    'Test 6: Performance test with multiple values' AS test_name,
    count() AS total_rows,
    countIf(JSONExtract(json_data, 'dec', 'Decimal(32,16)') = JSONExtractString(json_data, 'dec')::Decimal(32, 16)) AS precision_preserved_count,
    countIf(JSONExtract(json_data, 'dec', 'Decimal(32,16)') != JSONExtractString(json_data, 'dec')::Decimal(32, 16)) AS precision_lost_count
FROM test_json_decimal_precision;

-- Test 7: Verify that the fix works with different decimal scales
SELECT
    'Test 7: Different decimal scales' AS test_name,
    JSONExtract('{"dec": 123.456}', 'dec', 'Decimal(10,2)') AS scale_2,
    JSONExtract('{"dec": 123.456}', 'dec', 'Decimal(10,3)') AS scale_3,
    JSONExtract('{"dec": 123.456}', 'dec', 'Decimal(10,4)') AS scale_4,
    JSONExtract('{"dec": 123.456}', 'dec', 'Decimal(10,5)') AS scale_5;

-- Test 8: Verify that the fix works with negative numbers
SELECT
    'Test 8: Negative numbers' AS test_name,
    JSONExtract('{"dec": -111244542.003}', 'dec', 'Decimal(32,16)') AS negative_extraction,
    JSONExtractString('{"dec": -111244542.003}', 'dec')::Decimal(32, 16) AS negative_string_cast,
    JSONExtract('{"dec": -111244542.003}', 'dec', 'Decimal(32,16)') = JSONExtractString('{"dec": -111244542.003}', 'dec')::Decimal(32, 16) AS negative_precision_preserved;

-- Test 9: Simple case that demonstrates the fix
SELECT
    'Test 9: Simple precision demonstration' AS test_name,
    JSONExtract('{"amount": 16.4}', 'amount', 'Decimal64(6)') AS json_extract_result,
    CAST(JSONExtractString('{"amount": 16.4}', 'amount') AS Decimal64(6)) AS string_cast_result,
    JSONExtract('{"amount": 16.4}', 'amount', 'Decimal64(6)') = CAST(JSONExtractString('{"amount": 16.4}', 'amount') AS Decimal64(6)) AS precision_preserved;