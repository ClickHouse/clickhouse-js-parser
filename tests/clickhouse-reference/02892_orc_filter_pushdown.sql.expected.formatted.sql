-- Tags: no-fasttest, no-parallel
SET output_format_orc_string_as_string = '1';

SET output_format_orc_row_index_stride = '100';

SET input_format_orc_row_batch_size = '100';

SET input_format_orc_filter_push_down = '1';

SET input_format_null_as_default = '1';

SET engine_file_truncate_on_insert = '1';

SET optimize_or_like_chain = '0';

SET max_block_size = '100000';

SET max_insert_threads = '1';

SET max_execution_time = '300';

SET session_timezone = 'UTC';

-- Try all the types.
INSERT INTO FUNCTION file('02892.orc') WITH 5000 - number AS n

SELECT
    number,
    intDiv(n, 11)::Int8 AS i8,
    n::Int16 AS i16,
    n::Int32 AS i32,
    n::Int64 AS i64,
    toDate32(n * 500000) AS date32,
    toDateTime64(n * 1000000., 3) AS dt64_ms,
    toDateTime64(n * 1000000., 6) AS dt64_us,
    toDateTime64(n * 1000000., 9) AS dt64_ns,
    toDateTime64(n * 1000000., 0) AS dt64_s,
    toDateTime64(n * 1000000., 2) AS dt64_cs,
    (n / 1000)::Float32 AS f32,
    (n / 1000)::Float64 AS f64,
    n::String AS s,
    n::String::FixedString(9) AS fs,
    n::Decimal32(3) / 1234 AS d32,
    n::Decimal64(10) / 12345678 AS d64,
    n::Decimal128(20) / 123456789012345 AS d128
FROM numbers(10000);

DESCRIBE TABLE file('02892.orc');

-- Go over all types individually
-- { echoOn }
SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i8 IN (10, 15, -6));

SELECT
    count(1),
    min(i8),
    max(i8)
FROM file('02892.orc')
WHERE i8 IN (10, 15, -6);

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i8 >= -3
    AND i8 <= 2);

SELECT
    count(1),
    min(i8),
    max(i8)
FROM file('02892.orc')
WHERE i8 >= -3
    AND i8 <= 2;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i16 >= 4000
    AND i16 <= 61000
    OR i16 = 42);

SELECT
    count(1),
    min(i16),
    max(i16)
FROM file('02892.orc')
WHERE i16 >= 4000
    AND i16 <= 61000
    OR i16 = 42;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i16 >= -150
    AND i16 <= 250);

SELECT
    count(1),
    min(i16),
    max(i16)
FROM file('02892.orc')
WHERE i16 >= -150
    AND i16 <= 250;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i32 IN (42, -1000));

SELECT
    count(1),
    min(i32),
    max(i32)
FROM file('02892.orc')
WHERE i32 IN (42, -1000);

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i32 >= -150
    AND i32 <= 250);

SELECT
    count(1),
    min(i32),
    max(i32)
FROM file('02892.orc')
WHERE i32 >= -150
    AND i32 <= 250;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i64 IN (42, -1000));

SELECT
    count(1),
    min(i64),
    max(i64)
FROM file('02892.orc')
WHERE i64 IN (42, -1000);

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i64 >= -150
    AND i64 <= 250);

SELECT
    count(1),
    min(i64),
    max(i64)
FROM file('02892.orc')
WHERE i64 >= -150
    AND i64 <= 250;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(date32 >= '1992-01-01'
    AND date32 <= '2023-08-02');

SELECT
    count(1),
    min(date32),
    max(date32)
FROM file('02892.orc')
WHERE date32 >= '1992-01-01'
    AND date32 <= '2023-08-02';

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(dt64_ms >= '2000-01-01'
    AND dt64_ms <= '2005-01-01');

SELECT
    count(1),
    min(dt64_ms),
    max(dt64_ms)
FROM file('02892.orc')
WHERE dt64_ms >= '2000-01-01'
    AND dt64_ms <= '2005-01-01';

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(dt64_us >= toDateTime64(900000000, 2)
    AND dt64_us <= '2005-01-01');

SELECT
    count(1),
    min(dt64_us),
    max(dt64_us)
FROM file('02892.orc')
WHERE dt64_us >= toDateTime64(900000000, 2)
    AND dt64_us <= '2005-01-01';

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(dt64_ns >= '2000-01-01'
    AND dt64_ns <= '2005-01-01');

SELECT
    count(1),
    min(dt64_ns),
    max(dt64_ns)
FROM file('02892.orc')
WHERE dt64_ns >= '2000-01-01'
    AND dt64_ns <= '2005-01-01';

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(dt64_s >= toDateTime64('-2.01e8'::Decimal64(0), 0)
    AND dt64_s <= toDateTime64(CAST('1.5e8' AS Decimal64(0)), 0));

SELECT
    count(1),
    min(dt64_s),
    max(dt64_s)
FROM file('02892.orc')
WHERE dt64_s >= toDateTime64('-2.01e8'::Decimal64(0), 0)
    AND dt64_s <= toDateTime64(CAST('1.5e8' AS Decimal64(0)), 0);

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(dt64_cs >= toDateTime64('-2.01e8'::Decimal64(1), 1)
    AND dt64_cs <= toDateTime64(CAST('1.5e8' AS Decimal64(2)), 2));

SELECT
    count(1),
    min(dt64_cs),
    max(dt64_cs)
FROM file('02892.orc')
WHERE dt64_cs >= toDateTime64('-2.01e8'::Decimal64(1), 1)
    AND dt64_cs <= toDateTime64(CAST('1.5e8' AS Decimal64(2)), 2);

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(f32 >= CAST('-0.11' AS Float32)
    AND f32 <= CAST('0.06' AS Float32));

SELECT
    count(1),
    min(f32),
    max(f32)
FROM file('02892.orc')
WHERE f32 >= CAST('-0.11' AS Float32)
    AND f32 <= CAST('0.06' AS Float32);

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(f64 >= -0.11
    AND f64 <= 0.06);

SELECT
    count(1),
    min(f64),
    max(f64)
FROM file('02892.orc')
WHERE f64 >= -0.11
    AND f64 <= 0.06;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(s >= '-9'
    AND s <= '1!!!');

SELECT
    count(1),
    min(s),
    max(s)
FROM file('02892.orc')
WHERE s >= '-9'
    AND s <= '1!!!';

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(fs >= '-9'
    AND fs <= '1!!!');

SELECT
    count(1),
    min(fs),
    max(fs)
FROM file('02892.orc')
WHERE fs >= '-9'
    AND fs <= '1!!!';

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(d32 >= '-0.011'::Decimal32(3)
    AND d32 <= CAST('0.006' AS Decimal32(3)));

SELECT
    count(1),
    min(d32),
    max(d32)
FROM file('02892.orc')
WHERE d32 >= '-0.011'::Decimal32(3)
    AND d32 <= CAST('0.006' AS Decimal32(3));

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(d64 >= '-0.0000011'::Decimal64(7)
    AND d64 <= CAST('0.0000006' AS Decimal64(9)));

SELECT
    count(1),
    min(d64),
    max(d64)
FROM file('02892.orc')
WHERE d64 >= '-0.0000011'::Decimal64(7)
    AND d64 <= CAST('0.0000006' AS Decimal64(9));

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(d128 >= '-0.00000000000011'::Decimal128(20)
    AND d128 <= CAST('0.00000000000006' AS Decimal128(20)));

SELECT
    count(1),
    min(d128),
    max(128)
FROM file('02892.orc')
WHERE d128 >= '-0.00000000000011'::Decimal128(20)
    AND d128 <= CAST('0.00000000000006' AS Decimal128(20));

-- Some random other cases.
SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(0);

SELECT
    count(),
    min(number),
    max(number)
FROM file('02892.orc')
WHERE indexHint(0);

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(s LIKE '99%'
    OR i64 = 2000);

SELECT
    count(),
    min(s),
    max(s)
FROM file('02892.orc')
WHERE s LIKE '99%'
    OR i64 = 2000;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(s LIKE 'z%');

SELECT
    count(),
    min(s),
    max(s)
FROM file('02892.orc')
WHERE s LIKE 'z%';

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i8 = 10
    OR 1 = 1);

SELECT
    count(),
    min(i8),
    max(i8)
FROM file('02892.orc')
WHERE i8 = 10
    OR 1 = 1;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(i8 < 0);

SELECT
    count(),
    min(i8),
    max(i8)
FROM file('02892.orc')
WHERE i8 < 0;

-- { echoOff }
-- Nullable and LowCardinality.
INSERT INTO FUNCTION file('02892.orc') SELECT
    number,
    if(number % 234 = 0, NULL, number) AS sometimes_null,
    toNullable(number) AS never_null,
    if(number % 345 = 0, number::String, NULL) AS mostly_null,
    toLowCardinality(if(number % 234 = 0, NULL, number)) AS sometimes_null_lc,
    toLowCardinality(toNullable(number)) AS never_null_lc,
    toLowCardinality(if(number % 345 = 0, number::String, NULL)) AS mostly_null_lc
FROM numbers(1000);

-- { echoOn }
SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(sometimes_null IS NULL);

SELECT
    count(),
    min(sometimes_null),
    max(sometimes_null)
FROM file('02892.orc')
WHERE sometimes_null IS NULL;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(sometimes_null_lc IS NULL);

SELECT
    count(),
    min(sometimes_null_lc),
    max(sometimes_null_lc)
FROM file('02892.orc')
WHERE sometimes_null_lc IS NULL;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(mostly_null IS NOT NULL);

SELECT
    count(),
    min(mostly_null),
    max(mostly_null)
FROM file('02892.orc')
WHERE mostly_null IS NOT NULL;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(mostly_null_lc IS NOT NULL);

SELECT
    count(),
    min(mostly_null_lc),
    max(mostly_null_lc)
FROM file('02892.orc')
WHERE mostly_null_lc IS NOT NULL;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(sometimes_null > 850);

SELECT
    count(),
    min(sometimes_null),
    max(sometimes_null)
FROM file('02892.orc')
WHERE sometimes_null > 850;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(sometimes_null_lc > 850);

SELECT
    count(),
    min(sometimes_null_lc),
    max(sometimes_null_lc)
FROM file('02892.orc')
WHERE sometimes_null_lc > 850;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(never_null > 850);

SELECT
    count(),
    min(never_null),
    max(never_null)
FROM file('02892.orc')
WHERE never_null > 850;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(never_null_lc > 850);

SELECT
    count(),
    min(never_null_lc),
    max(never_null_lc)
FROM file('02892.orc')
WHERE never_null_lc > 850;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(never_null < 150);

SELECT
    count(),
    min(never_null),
    max(never_null)
FROM file('02892.orc')
WHERE never_null < 150;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(never_null_lc < 150);

SELECT
    count(),
    min(never_null_lc),
    max(never_null_lc)
FROM file('02892.orc')
WHERE never_null_lc < 150;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(sometimes_null < 150);

SELECT
    count(),
    min(sometimes_null),
    max(sometimes_null)
FROM file('02892.orc')
WHERE sometimes_null < 150;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(sometimes_null_lc < 150);

SELECT
    count(),
    min(sometimes_null_lc),
    max(sometimes_null_lc)
FROM file('02892.orc')
WHERE sometimes_null_lc < 150;

-- { echoOff }
-- Settings that affect the table schema or contents.
INSERT INTO FUNCTION file('02892.orc') SELECT
    number,
    if(number % 234 = 0, NULL, number + 100) AS positive_or_null,
    if(number % 234 = 0, NULL, -number - 100) AS negative_or_null,
    if(number % 234 = 0, NULL, 'I am a string') AS string_or_null
FROM numbers(1000);

-- { echoOn }
SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(positive_or_null < 50); -- quirk with infinities

SELECT
    count(),
    min(positive_or_null),
    max(positive_or_null)
FROM file('02892.orc')
WHERE positive_or_null < 50;

SELECT
    count(),
    sum(number)
FROM file('02892.orc', ORC, 'number UInt64, positive_or_null UInt64')
WHERE indexHint(positive_or_null < 50);

SELECT
    count(),
    min(positive_or_null),
    max(positive_or_null)
FROM file('02892.orc', ORC, 'number UInt64, positive_or_null UInt64')
WHERE positive_or_null < 50;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(negative_or_null > -50);

SELECT
    count(),
    min(negative_or_null),
    max(negative_or_null)
FROM file('02892.orc')
WHERE negative_or_null > -50;

SELECT
    count(),
    sum(number)
FROM file('02892.orc', ORC, 'number UInt64, negative_or_null Int64')
WHERE indexHint(negative_or_null > -50);

SELECT
    count(),
    min(negative_or_null),
    max(negative_or_null)
FROM file('02892.orc', ORC, 'number UInt64, negative_or_null Int64')
WHERE negative_or_null > -50;

SELECT
    count(),
    sum(number)
FROM file('02892.orc')
WHERE indexHint(string_or_null = ''); -- quirk with infinities

SELECT
    count(),
    min(string_or_null),
    max(string_or_null)
FROM file('02892.orc')
WHERE string_or_null = '';

SELECT
    count(),
    sum(number)
FROM file('02892.orc', ORC, 'number UInt64, string_or_null String')
WHERE indexHint(string_or_null = '');

SELECT
    count(),
    min(string_or_null),
    max(string_or_null)
FROM file('02892.orc', ORC, 'number UInt64, string_or_null String')
WHERE string_or_null = '';

SELECT
    count(),
    sum(number)
FROM file('02892.orc', ORC, 'number UInt64, nEgAtIvE_oR_nUlL Int64')
WHERE indexHint(nEgAtIvE_oR_nUlL > -50)
SETTINGS input_format_orc_case_insensitive_column_matching = '1';

SELECT
    count(),
    min(nEgAtIvE_oR_nUlL),
    max(nEgAtIvE_oR_nUlL)
FROM file('02892.orc', ORC, 'number UInt64, nEgAtIvE_oR_nUlL Int64')
WHERE nEgAtIvE_oR_nUlL > -50
SETTINGS input_format_orc_case_insensitive_column_matching = '1';

SELECT
    count(),
    sum(number)
FROM file('02892.orc', ORC, 'number UInt64, negative_or_null Int64')
WHERE indexHint(negative_or_null < -500);

SELECT
    count(),
    min(negative_or_null),
    max(negative_or_null)
FROM file('02892.orc', ORC, 'number UInt64, negative_or_null Int64')
WHERE negative_or_null < -500;

SELECT
    count(),
    sum(number)
FROM file('02892.orc', ORC, 'number UInt64, negative_or_null Int64')
WHERE indexHint(negative_or_null IS NULL)
SETTINGS enable_analyzer = '1';

SELECT
    count(),
    min(negative_or_null),
    max(negative_or_null)
FROM file('02892.orc', ORC, 'number UInt64, negative_or_null Int64')
WHERE negative_or_null IS NULL;

SELECT
    count(),
    sum(number)
FROM file('02892.orc', ORC, 'number UInt64, negative_or_null Int64')
WHERE indexHint(negative_or_null IN (0, -1, -10, -100, -1000));

SELECT
    count(),
    min(negative_or_null),
    max(negative_or_null)
FROM file('02892.orc', ORC, 'number UInt64, negative_or_null Int64')
WHERE negative_or_null IN (0, -1, -10, -100, -1000);

SELECT
    count(),
    sum(number)
FROM file('02892.orc', ORC, 'number UInt64, string_or_null LowCardinality(String)')
WHERE indexHint(string_or_null LIKE 'I am%');

SELECT
    count(),
    min(string_or_null),
    max(string_or_null)
FROM file('02892.orc', ORC, 'number UInt64, string_or_null LowCardinality(String)')
WHERE string_or_null LIKE 'I am%';

SELECT
    count(),
    sum(number)
FROM file('02892.orc', ORC, 'number UInt64, string_or_null LowCardinality(Nullable(String))')
WHERE indexHint(string_or_null LIKE 'I am%');

SELECT
    count(),
    min(string_or_null),
    max(string_or_null)
FROM file('02892.orc', ORC, 'number UInt64, string_or_null LowCardinality(Nullable(String))')
WHERE string_or_null LIKE 'I am%'; -- { echoOff }