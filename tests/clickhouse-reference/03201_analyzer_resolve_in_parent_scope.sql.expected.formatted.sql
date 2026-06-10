CREATE VIEW fake
AS
SELECT
    table,
    database,
    name
FROM `system`.tables
WHERE database = currentDatabase();

WITH database NOT LIKE 'system'
    AND name = 'fake' AS `$condition`,

`$main` AS (
    SELECT DISTINCT table
    FROM fake
    WHERE `$condition`
)

SELECT *
FROM `$main`;

WITH properties_value[indexOf(properties_key, 'objectId')] AS objectId,

data AS (
    SELECT
        ['objectId'] AS properties_key,
        ['objectValue'] AS properties_value
),

nested_query AS (
    SELECT objectId
    FROM data
)

SELECT *
FROM nested_query;

WITH leftPad('abc', 4, '0') AS paddedval

SELECT *
FROM (
        SELECT paddedval
    );

WITH ('408', '420') AS some_tuple

SELECT '408' IN (some_tuple) AS flag;

CREATE VIEW another_fake
AS
SELECT
    bytes,
    table
FROM `system`.parts;

WITH sum(bytes) AS s,

data AS (
    SELECT
        formatReadableSize(s),
        table
    FROM another_fake
    GROUP BY table
    ORDER BY s ASC
)

SELECT *
FROM data
FORMAT Null;

CREATE TABLE test
(
    a UInt64,
    b UInt64,
    Block_Height UInt64,
    Block_Date Date
)
ENGINE = Log();

WITH Block_Height >= 1
    AND Block_Height <= 2 AS block_filter

SELECT *
FROM test
WHERE block_filter
    AND Block_Date IN (
        SELECT Block_Date
        FROM test
        WHERE block_filter
    );

CREATE TABLE test_cte
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

WITH a > b AS cte,

query AS (
    SELECT count()
    FROM test_cte
    WHERE cte
)

SELECT *
FROM query;

WITH arrayMap((x -> x + 1), [0]) AS a

SELECT 1
WHERE 1 IN (
        SELECT arrayJoin(a)
    );