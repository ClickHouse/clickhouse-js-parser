SELECT bitmapToArray(bitmapBuild([1, 2, 3, 4, 5]));

SELECT bitmapToArray(bitmapAnd(bitmapBuild([1, 2, 3]), bitmapBuild([3, 4, 5])));

SELECT bitmapToArray(bitmapOr(bitmapBuild([1, 2, 3]), bitmapBuild([3, 4, 5])));

SELECT bitmapToArray(bitmapXor(bitmapBuild([1, 2, 3]), bitmapBuild([3, 4, 5])));

SELECT bitmapToArray(bitmapAndnot(bitmapBuild([1, 2, 3]), bitmapBuild([3, 4, 5])));

SELECT bitmapCardinality(bitmapBuild([1, 2, 3, 4, 5]));

SELECT bitmapAndCardinality(bitmapBuild([1, 2, 3]), bitmapBuild([3, 4, 5]));

SELECT bitmapOrCardinality(bitmapBuild([1, 2, 3]), bitmapBuild([3, 4, 5]));

SELECT bitmapXorCardinality(bitmapBuild([1, 2, 3]), bitmapBuild([3, 4, 5]));

SELECT bitmapAndnotCardinality(bitmapBuild([1, 2, 3]), bitmapBuild([3, 4, 5]));

SELECT bitmapAndCardinality(bitmapBuild([100, 200, 500]), bitmapBuild(CAST([100, 200] AS Array(UInt16))));

SELECT bitmapToArray(bitmapAnd(bitmapBuild([100, 200, 500]), bitmapBuild(CAST([100, 200] AS Array(UInt16)))));

DROP TABLE IF EXISTS bitmap_test;

CREATE TABLE bitmap_test
(
    pickup_date Date,
    city_id UInt32,
    uid UInt32
)
ENGINE = Memory();

INSERT INTO bitmap_test SELECT
    '2019-01-01',
    1,
    number
FROM numbers(1, 50);

INSERT INTO bitmap_test SELECT
    '2019-01-02',
    1,
    number
FROM numbers(11, 60);

INSERT INTO bitmap_test SELECT
    '2019-01-03',
    2,
    number
FROM numbers(1, 10);

SELECT groupBitmap(uid) AS user_num
FROM bitmap_test;

SELECT
    pickup_date,
    groupBitmap(uid) AS user_num,
    bitmapToArray(groupBitmapState(uid)) AS users
FROM bitmap_test
GROUP BY pickup_date
ORDER BY pickup_date ASC;

SELECT
    bitmapCardinality(day_today) AS today_users,
    bitmapCardinality(day_before) AS before_users,
    bitmapOrCardinality(day_today, day_before) AS all_users,
    bitmapAndCardinality(day_today, day_before) AS old_users,
    bitmapAndnotCardinality(day_today, day_before) AS new_users,
    bitmapXorCardinality(day_today, day_before) AS diff_users
FROM
    (
        SELECT
            city_id,
            groupBitmapState(uid) AS day_today
        FROM bitmap_test
        WHERE pickup_date = '2019-01-02'
        GROUP BY city_id
        ORDER BY city_id ASC
    ) AS js1
ALL LEFT JOIN (
        SELECT
            city_id,
            groupBitmapState(uid) AS day_before
        FROM bitmap_test
        WHERE pickup_date = '2019-01-01'
        GROUP BY city_id
        ORDER BY city_id ASC
    ) AS js2
    USING (city_id);

SELECT
    bitmapCardinality(day_today) AS today_users,
    bitmapCardinality(day_before) AS before_users,
    bitmapCardinality(bitmapOr(day_today, day_before)) AS ll_users,
    bitmapCardinality(bitmapAnd(day_today, day_before)) AS old_users,
    bitmapCardinality(bitmapAndnot(day_today, day_before)) AS new_users,
    bitmapCardinality(bitmapXor(day_today, day_before)) AS diff_users
FROM
    (
        SELECT
            city_id,
            groupBitmapState(uid) AS day_today
        FROM bitmap_test
        WHERE pickup_date = '2019-01-02'
        GROUP BY city_id
        ORDER BY city_id ASC
    ) AS js1
ALL LEFT JOIN (
        SELECT
            city_id,
            groupBitmapState(uid) AS day_before
        FROM bitmap_test
        WHERE pickup_date = '2019-01-01'
        GROUP BY city_id
        ORDER BY city_id ASC
    ) AS js2
    USING (city_id);

SELECT count(*)
FROM bitmap_test
WHERE bitmapHasAny((
        SELECT groupBitmapState(uid)
        FROM bitmap_test
        WHERE pickup_date = '2019-01-01'
    ), bitmapBuild([uid]));

SELECT count(*)
FROM bitmap_test
WHERE bitmapHasAny(bitmapBuild([uid]), (
        SELECT groupBitmapState(uid)
        FROM bitmap_test
        WHERE pickup_date = '2019-01-01'
    ));

SELECT count(*)
FROM bitmap_test
WHERE 0 = bitmapHasAny((
        SELECT groupBitmapState(uid)
        FROM bitmap_test
        WHERE pickup_date = '2019-01-01'
    ), bitmapBuild([uid]));

SELECT count(*)
FROM bitmap_test
WHERE bitmapContains((
        SELECT groupBitmapState(uid)
        FROM bitmap_test
        WHERE pickup_date = '2019-01-01'
    ), uid);

SELECT count(*)
FROM bitmap_test
WHERE 0 = bitmapContains((
        SELECT groupBitmapState(uid)
        FROM bitmap_test
        WHERE pickup_date = '2019-01-01'
    ), uid);

-- PR#8082
SELECT bitmapToArray(bitmapAnd(groupBitmapState(uid), bitmapBuild(CAST([1, 2, 3] AS Array(UInt32)))))
FROM bitmap_test
GROUP BY city_id
ORDER BY city_id ASC;

-- bitmap state test
DROP TABLE IF EXISTS bitmap_state_test;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE bitmap_state_test
(
    pickup_date Date,
    city_id UInt32,
    uv AggregateFunction(groupBitmap, UInt32)
)
ENGINE = AggregatingMergeTree(pickup_date, (pickup_date, city_id), 8192);

INSERT INTO bitmap_state_test SELECT
    pickup_date,
    city_id,
    groupBitmapState(uid) AS uv
FROM bitmap_test
GROUP BY
    pickup_date,
    city_id;

SELECT
    pickup_date,
    groupBitmapMerge(uv) AS users
FROM bitmap_state_test
GROUP BY pickup_date
ORDER BY pickup_date ASC;

-- between column and expression test
DROP TABLE IF EXISTS bitmap_column_expr_test;

CREATE TABLE bitmap_column_expr_test
(
    t DateTime,
    z AggregateFunction(groupBitmap, UInt32)
)
ENGINE = MergeTree()
ORDER BY t
PARTITION BY toYYYYMMDD(t);

INSERT INTO bitmap_column_expr_test;

SELECT bitmapAndCardinality(bitmapBuild(CAST([19, 7] AS Array(UInt32))), z)
FROM bitmap_column_expr_test;

SELECT bitmapAndCardinality(z, bitmapBuild(CAST([19, 7] AS Array(UInt32))))
FROM bitmap_column_expr_test;

SELECT bitmapCardinality(bitmapAnd(bitmapBuild(CAST([19, 7] AS Array(UInt32))), z))
FROM bitmap_column_expr_test;

SELECT bitmapCardinality(bitmapAnd(z, bitmapBuild(CAST([19, 7] AS Array(UInt32)))))
FROM bitmap_column_expr_test;

DROP TABLE IF EXISTS bitmap_column_expr_test2;

CREATE TABLE bitmap_column_expr_test2
(
    tag_id String,
    z AggregateFunction(groupBitmap, UInt32)
)
ENGINE = MergeTree()
ORDER BY tag_id;

INSERT INTO bitmap_column_expr_test2;

INSERT INTO bitmap_column_expr_test2;

INSERT INTO bitmap_column_expr_test2;

SELECT groupBitmapMerge(z)
FROM bitmap_column_expr_test2
WHERE like(tag_id, 'tag%');

SELECT arraySort(bitmapToArray(groupBitmapMergeState(z)))
FROM bitmap_column_expr_test2
WHERE like(tag_id, 'tag%');

SELECT groupBitmapOr(z)
FROM bitmap_column_expr_test2
WHERE like(tag_id, 'tag%');

SELECT arraySort(bitmapToArray(groupBitmapOrState(z)))
FROM bitmap_column_expr_test2
WHERE like(tag_id, 'tag%');

SELECT groupBitmapAnd(z)
FROM bitmap_column_expr_test2
WHERE like(tag_id, 'tag%');

SELECT arraySort(bitmapToArray(groupBitmapAndState(z)))
FROM bitmap_column_expr_test2
WHERE like(tag_id, 'tag%');

SELECT groupBitmapXor(z)
FROM bitmap_column_expr_test2
WHERE like(tag_id, 'tag%');

SELECT arraySort(bitmapToArray(groupBitmapXorState(z)))
FROM bitmap_column_expr_test2
WHERE like(tag_id, 'tag%');

DROP TABLE IF EXISTS bitmap_column_expr_test3;

CREATE TABLE bitmap_column_expr_test3
(
    tag_id String,
    z AggregateFunction(groupBitmap, UInt64),
    `replace` Nested(`from` UInt16, to UInt64)
)
ENGINE = MergeTree()
ORDER BY tag_id;

DROP TABLE IF EXISTS numbers10;

CREATE VIEW numbers10
AS
SELECT number
FROM `system`.numbers
LIMIT 10;

INSERT INTO bitmap_column_expr_test3 (tag_id, z, `replace`.`from`, `replace`.to) SELECT
    'tag1',
    groupBitmapState(toUInt64(number)),
    CAST([] AS Array(UInt16)),
    CAST([] AS Array(UInt64))
FROM numbers10;

INSERT INTO bitmap_column_expr_test3 (tag_id, z, `replace`.`from`, `replace`.to) SELECT
    'tag2',
    groupBitmapState(toUInt64(number)),
    CAST([0] AS Array(UInt16)),
    CAST([2] AS Array(UInt64))
FROM numbers10;

INSERT INTO bitmap_column_expr_test3 (tag_id, z, `replace`.`from`, `replace`.to) SELECT
    'tag3',
    groupBitmapState(toUInt64(number)),
    CAST([0, 7] AS Array(UInt16)),
    CAST([3, 101] AS Array(UInt64))
FROM numbers10;

INSERT INTO bitmap_column_expr_test3 (tag_id, z, `replace`.`from`, `replace`.to) SELECT
    'tag4',
    groupBitmapState(toUInt64(number)),
    CAST([5, 999, 2] AS Array(UInt16)),
    CAST([2, 888, 20] AS Array(UInt64))
FROM numbers10;

SELECT
    tag_id,
    bitmapToArray(z),
    `replace`.`from`,
    `replace`.to,
    bitmapToArray(bitmapTransform(z, `replace`.`from`, `replace`.to))
FROM bitmap_column_expr_test3
ORDER BY tag_id ASC;

-- bitmapHasAny:
---- Empty
SELECT bitmapHasAny(bitmapBuild([1, 2, 3, 5]), bitmapBuild(emptyArrayUInt8()));

SELECT bitmapHasAny(bitmapBuild(emptyArrayUInt32()), bitmapBuild(emptyArrayUInt32()));

SELECT bitmapHasAny(bitmapBuild(emptyArrayUInt16()), bitmapBuild([1, 2, 3, 500]));

---- Small x Small
SELECT bitmapHasAny(bitmapBuild([1, 2, 3, 5]), bitmapBuild([0, 3, 7]));

SELECT bitmapHasAny(bitmapBuild([1, 2, 3, 5]), bitmapBuild([0, 4, 7]));

---- Small x Large
SELECT bitmapHasAny(bitmapBuild([100, 110, 120]), bitmapBuild([99, 100, 101, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]));

SELECT bitmapHasAny(bitmapBuild([100, 200, 500]), bitmapBuild([99, 101, 600, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]));

---- Large x Small
SELECT bitmapHasAny(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 230]), bitmapBuild([99, 100, 101]));

SELECT bitmapHasAny(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), bitmapBuild([99, 101, 600]));

---- Large x Large
SELECT bitmapHasAny(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 40, 50, 60]), bitmapBuild([41, 50, 61, 99, 98, 97, 96, 95, 94, 93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 67, 66, 65]));

SELECT bitmapHasAny(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 40, 50, 60]), bitmapBuild([41, 49, 51, 61, 99, 98, 97, 96, 95, 94, 93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 67, 66, 65]));

-- bitmapHasAll:
---- Empty
SELECT bitmapHasAll(bitmapBuild([1, 2, 3, 5]), bitmapBuild(emptyArrayUInt8()));

SELECT bitmapHasAll(bitmapBuild(emptyArrayUInt32()), bitmapBuild(emptyArrayUInt32()));

SELECT bitmapHasAll(bitmapBuild(emptyArrayUInt16()), bitmapBuild([1, 2, 3, 500]));

---- Small x Small
SELECT bitmapHasAll(bitmapBuild([1, 5, 7, 9]), bitmapBuild([5, 7]));

SELECT bitmapHasAll(bitmapBuild([1, 5, 7, 9]), bitmapBuild([5, 7, 2]));

---- Small x Large
SELECT bitmapHasAll(bitmapBuild([100, 110, 120]), bitmapBuild([99, 100, 101, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]));

SELECT bitmapHasAll(bitmapBuild([100, 200, 500]), bitmapBuild([99, 101, 600, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]));

---- Small x LargeSmall
SELECT bitmapHasAll(bitmapBuild([1, 5, 7, 9]), bitmapXor(bitmapBuild([1, 5, 7]), bitmapBuild([5, 7, 9])));

SELECT bitmapHasAll(bitmapBuild([1, 5, 7, 9]), bitmapXor(bitmapBuild([1, 5, 7]), bitmapBuild([2, 5, 7])));

---- Large x Small
SELECT bitmapHasAll(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), bitmapBuild([100, 500]));

SELECT bitmapHasAll(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), bitmapBuild([99, 100, 500]));

---- LargeSmall x Small
SELECT bitmapHasAll(bitmapXor(bitmapBuild([1, 7]), bitmapBuild([5, 7, 9])), bitmapBuild([1, 5]));

SELECT bitmapHasAll(bitmapXor(bitmapBuild([1, 7]), bitmapBuild([5, 7, 9])), bitmapBuild([1, 5, 7]));

---- Large x Large
SELECT bitmapHasAll(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), bitmapBuild([100, 200, 500, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]));

SELECT bitmapHasAll(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), bitmapBuild([100, 200, 501, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]));

-- bitmapContains:
---- Empty
SELECT bitmapContains(bitmapBuild(emptyArrayUInt32()), toUInt8(0));

SELECT bitmapContains(bitmapBuild(emptyArrayUInt16()), toUInt16(5));

---- Small
SELECT bitmapContains(bitmapBuild([1, 5, 7, 9]), toUInt32(0));

SELECT bitmapContains(bitmapBuild([1, 5, 7, 9]), toUInt64(9));

---- Large
SELECT bitmapContains(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(100));

SELECT bitmapContains(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(101));

SELECT bitmapContains(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(500));

-- bitmapSubsetInRange:
---- Empty
SELECT bitmapToArray(bitmapSubsetInRange(bitmapBuild(emptyArrayUInt32()), toUInt64(0), toUInt32(10)));

SELECT bitmapToArray(bitmapSubsetInRange(bitmapBuild(emptyArrayUInt16()), toUInt32(0), toUInt64(10)));

---- Small
SELECT bitmapToArray(bitmapSubsetInRange(bitmapBuild([1, 5, 7, 9]), toUInt8(0), toUInt16(4)));

SELECT bitmapToArray(bitmapSubsetInRange(bitmapBuild([1, 5, 7, 9]), toUInt32(10), toUInt64(10)));

SELECT bitmapToArray(bitmapSubsetInRange(bitmapBuild([1, 5, 7, 9]), toUInt64(3), toUInt32(7)));

---- Large
SELECT bitmapToArray(bitmapSubsetInRange(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt8(0), toUInt32(100)));

SELECT bitmapToArray(bitmapSubsetInRange(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt64(30), toUInt32(200)));

SELECT bitmapToArray(bitmapSubsetInRange(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(100), toUInt64(200)));

-- bitmapSubsetLimit:
---- Empty
SELECT bitmapToArray(bitmapSubsetLimit(bitmapBuild(emptyArrayUInt32()), toUInt8(0), toUInt32(10)));

SELECT bitmapToArray(bitmapSubsetLimit(bitmapBuild(emptyArrayUInt16()), toUInt32(0), toUInt64(10)));

---- Small
SELECT bitmapToArray(bitmapSubsetLimit(bitmapBuild([1, 5, 7, 9]), toUInt8(0), toUInt32(4)));

SELECT bitmapToArray(bitmapSubsetLimit(bitmapBuild([1, 5, 7, 9]), toUInt32(10), toUInt64(10)));

SELECT bitmapToArray(bitmapSubsetLimit(bitmapBuild([1, 5, 7, 9]), toUInt16(3), toUInt32(7)));

---- Large
SELECT bitmapToArray(bitmapSubsetLimit(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(0), toUInt32(100)));

SELECT bitmapToArray(bitmapSubsetLimit(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(30), toUInt32(200)));

SELECT bitmapToArray(bitmapSubsetLimit(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(100), toUInt16(200)));

-- subBitmap:
---- Empty
SELECT bitmapToArray(subBitmap(bitmapBuild(emptyArrayUInt32()), toUInt8(0), toUInt32(10)));

SELECT bitmapToArray(subBitmap(bitmapBuild(emptyArrayUInt16()), toUInt32(0), toUInt64(10)));

---- Small
SELECT bitmapToArray(subBitmap(bitmapBuild([1, 5, 7, 9]), toUInt8(0), toUInt32(4)));

SELECT bitmapToArray(subBitmap(bitmapBuild([1, 5, 7, 9]), toUInt32(1), toUInt64(4)));

SELECT bitmapToArray(subBitmap(bitmapBuild([1, 5, 7, 9]), toUInt16(1), toUInt32(2)));

---- Large
SELECT bitmapToArray(subBitmap(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(0), toUInt32(10)));

SELECT bitmapToArray(subBitmap(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(30), toUInt32(200)));

SELECT bitmapToArray(subBitmap(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]), toUInt32(34), toUInt16(3)));

-- bitmapMin:
---- Empty
SELECT bitmapMin(bitmapBuild(emptyArrayUInt8()));

SELECT bitmapMin(bitmapBuild(emptyArrayUInt16()));

SELECT bitmapMin(bitmapBuild(emptyArrayUInt32()));

SELECT bitmapMin(bitmapBuild(emptyArrayUInt64()));

---- Small
SELECT bitmapMin(bitmapBuild([1, 5, 7, 9]));

---- Large
SELECT bitmapMin(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]));

-- bitmapMax:
---- Empty
SELECT bitmapMax(bitmapBuild(emptyArrayUInt8()));

SELECT bitmapMax(bitmapBuild(emptyArrayUInt16()));

SELECT bitmapMax(bitmapBuild(emptyArrayUInt32()));

---- Small
SELECT bitmapMax(bitmapBuild([1, 5, 7, 9]));

---- Large
SELECT bitmapMax(bitmapBuild([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 100, 200, 500]));

SELECT
    bitmapCardinality(day_today) AS today_users,
    bitmapCardinality(day_before) AS before_users,
    bitmapOrCardinality(day_today, day_before) AS all_users,
    bitmapAndCardinality(day_today, day_before) AS old_users,
    bitmapAndnotCardinality(day_today, day_before) AS new_users,
    bitmapXorCardinality(day_today, day_before) AS diff_users
FROM
    (
        SELECT
            city_id,
            groupBitmapState(uid) AS day_today
        FROM bitmap_test
        WHERE pickup_date = '2019-01-02'
        GROUP BY
            rand(rand(rand('') % nan = NULL) % 7 % rand(NULL)),
            city_id
    ) AS js1
ALL LEFT JOIN (
        SELECT
            city_id,
            groupBitmapState(uid) AS day_before
        FROM bitmap_test
        WHERE pickup_date = '2019-01-01'
        GROUP BY city_id
    ) AS js2
    USING (city_id)
FORMAT Null;

DROP TABLE bitmap_test;