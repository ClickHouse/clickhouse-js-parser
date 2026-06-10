-- { echoOn }
SET use_with_fill_by_sorting_prefix = '1';

-- corner case with constant sort prefix
SELECT number
FROM numbers(1)
ORDER BY
    10 ASC,
    number DESC WITH FILL FROM 1
SETTINGS enable_positional_arguments = '0';

-- sensor table
DROP TABLE IF EXISTS ts;

CREATE TABLE ts
(
    sensor_id UInt64,
    timestamp UInt64,
    value Float64
)
ENGINE = MergeTree()
ORDER BY (sensor_id, timestamp);

INSERT INTO ts;

-- FillingTransform: 6 rows will be processed in 1 chunks
SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    timestamp ASC WITH FILL STEP 1;

SYSTEM STOP MERGES ts;

-- FillingTransform: 6 rows will be processed in 3 chunks with 2 rows each
INSERT INTO ts;

INSERT INTO ts;

INSERT INTO ts;

SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    timestamp ASC WITH FILL STEP 1
SETTINGS max_block_size = '2';

-- FillingTransform: 6 rows will be processed in 2 chunks with 3 rows each
INSERT INTO ts;

INSERT INTO ts;

SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    timestamp ASC WITH FILL STEP 1
SETTINGS max_block_size = '3';

-- FROM and TO
-- ASC order in sorting prefix
SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    timestamp ASC WITH FILL FROM 6 TO 10 STEP 1 INTERPOLATE (value AS 9999);

SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    timestamp ASC WITH FILL FROM 6 TO 10 STEP 1 INTERPOLATE (value AS 9999)
SETTINGS use_with_fill_by_sorting_prefix = '0';

-- DESC order in sorting prefix
SELECT *
FROM ts
ORDER BY
    sensor_id DESC,
    timestamp ASC WITH FILL FROM 6 TO 10 STEP 1 INTERPOLATE (value AS 9999);

SELECT *
FROM ts
ORDER BY
    sensor_id DESC,
    timestamp ASC WITH FILL FROM 6 TO 10 STEP 1 INTERPOLATE (value AS 9999)
SETTINGS use_with_fill_by_sorting_prefix = '0';

-- without TO
-- ASC order in sorting prefix
SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    timestamp ASC WITH FILL FROM 6 STEP 1 INTERPOLATE (value AS 9999);

SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    timestamp ASC WITH FILL FROM 6 STEP 1 INTERPOLATE (value AS 9999)
SETTINGS use_with_fill_by_sorting_prefix = '0';

-- DESC order in sorting prefix
SELECT *
FROM ts
ORDER BY
    sensor_id DESC,
    timestamp ASC WITH FILL FROM 6 STEP 1 INTERPOLATE (value AS 9999);

SELECT *
FROM ts
ORDER BY
    sensor_id DESC,
    timestamp ASC WITH FILL FROM 6 STEP 1 INTERPOLATE (value AS 9999)
SETTINGS use_with_fill_by_sorting_prefix = '0';

-- without FROM
-- ASC order in sorting prefix
SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    timestamp ASC WITH FILL TO 10 STEP 1 INTERPOLATE (value AS 9999);

SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    timestamp ASC WITH FILL TO 10 STEP 1 INTERPOLATE (value AS 9999)
SETTINGS use_with_fill_by_sorting_prefix = '0';

-- DESC order in sorting prefix
SELECT *
FROM ts
ORDER BY
    sensor_id DESC,
    timestamp ASC WITH FILL TO 10 STEP 1 INTERPOLATE (value AS 9999);

SELECT *
FROM ts
ORDER BY
    sensor_id DESC,
    timestamp ASC WITH FILL TO 10 STEP 1 INTERPOLATE (value AS 9999)
SETTINGS use_with_fill_by_sorting_prefix = '0';

-- checking that sorting prefix columns can't be used in INTERPOLATE
SELECT *
FROM ts
ORDER BY
    sensor_id ASC,
    value ASC,
    timestamp ASC WITH FILL FROM 6 TO 10 INTERPOLATE (value AS 1); -- { serverError INVALID_WITH_FILL_EXPRESSION }