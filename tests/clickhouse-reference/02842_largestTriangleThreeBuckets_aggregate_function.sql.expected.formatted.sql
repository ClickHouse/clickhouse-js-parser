SET allow_deprecated_error_prone_window_functions = '1';

DROP TABLE IF EXISTS largestTriangleThreeBucketsTestFloat64Float64;

CREATE TABLE largestTriangleThreeBucketsTestFloat64Float64
(
    x Float64,
    y Float64
)
ENGINE = MergeTree()
ORDER BY (y, x);

INSERT INTO largestTriangleThreeBucketsTestFloat64Float64;

SELECT largestTriangleThreeBuckets(0)(x, y)
FROM largestTriangleThreeBucketsTestFloat64Float64;

SELECT largestTriangleThreeBuckets(1)(x, y)
FROM largestTriangleThreeBucketsTestFloat64Float64;

SELECT largestTriangleThreeBuckets(2)(x, y)
FROM largestTriangleThreeBucketsTestFloat64Float64;

SELECT largestTriangleThreeBuckets(4)(x, y) AS downsampled_data
FROM largestTriangleThreeBucketsTestFloat64Float64;

DROP TABLE largestTriangleThreeBucketsTestFloat64Float64;

DROP TABLE IF EXISTS largestTriangleThreeBucketsTestDecimal64Decimal64;

CREATE TABLE largestTriangleThreeBucketsTestDecimal64Decimal64
(
    x Decimal64(2),
    y Decimal64(2)
)
ENGINE = MergeTree()
ORDER BY (y, x);

INSERT INTO largestTriangleThreeBucketsTestDecimal64Decimal64 (x, y);

SELECT largestTriangleThreeBuckets(20)(x, y)
FROM largestTriangleThreeBucketsTestDecimal64Decimal64;

DROP TABLE largestTriangleThreeBucketsTestDecimal64Decimal64;

DROP TABLE IF EXISTS largestTriangleThreeBucketsTestDateTime64Float64;

CREATE TABLE largestTriangleThreeBucketsTestDateTime64Float64
(
    x DateTime64(3),
    y Float64
)
ENGINE = MergeTree()
ORDER BY (y, x);

INSERT INTO largestTriangleThreeBucketsTestDateTime64Float64 (x, y);

SELECT largestTriangleThreeBuckets(5)(x, y)
FROM largestTriangleThreeBucketsTestDateTime64Float64;

SELECT lttb(5)(x, y)
FROM largestTriangleThreeBucketsTestDateTime64Float64;

DROP TABLE largestTriangleThreeBucketsTestDateTime64Float64;

CREATE TABLE largestTriangleTreeBucketsBucketSizeTest
(
    x UInt32,
    y UInt32
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO largestTriangleTreeBucketsBucketSizeTest (x, y) SELECT
    number + 1 AS x,
    x % 1000 AS y
FROM numbers(9999);

SELECT
    arrayJoin(lttb(1000)(x, y)) AS point,
    tupleElement(point, 1) AS point_x,
    point_x - neighbor(point_x, -1) AS point_x_diff_with_previous_row
FROM largestTriangleTreeBucketsBucketSizeTest
LIMIT 10
OFFSET 990;

SELECT largestTriangleThreeBuckets(1)(0, '1900-01-01 00:00:00'::DateTime64);

DROP TABLE largestTriangleTreeBucketsBucketSizeTest;