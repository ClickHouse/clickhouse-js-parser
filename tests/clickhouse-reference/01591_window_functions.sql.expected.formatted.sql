-- Tags: long
SET enable_analyzer = '1';

-- Too slow
SET max_bytes_before_external_sort = '0';

SET max_bytes_ratio_before_external_sort = '0';

SET max_bytes_before_external_group_by = '0';

SET max_bytes_ratio_before_external_group_by = '0';

-- { echo }
-- just something basic
SELECT
    number,
    count() OVER (PARTITION BY intDiv(number, 3) ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(10);

-- proper calculation across blocks
SELECT
    number,
    max(number) OVER (PARTITION BY intDiv(number, 3) ORDER BY number DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(10)
SETTINGS max_block_size = '2';

-- not a window function
SELECT
    number,
    abs(number) OVER (PARTITION BY toString(intDiv(number, 3)) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(10); -- { serverError UNKNOWN_AGGREGATE_FUNCTION }

-- no partition by
SELECT
    number,
    avg(number) OVER (ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(10);

-- no order by
SELECT
    number,
    quantileExact(number) OVER (PARTITION BY intDiv(number, 3) AS value ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(10);

-- can add an alias after window spec
SELECT
    number,
    quantileExact(number) OVER (PARTITION BY intDiv(number, 3) AS value ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS q
FROM numbers(10);

-- now we should be able to compute expressions with window functions
SELECT
    number,
    q * 10,
    quantileExact(number) OVER (PARTITION BY intDiv(number, 3) ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS q
FROM numbers(10)
ORDER BY number ASC;

-- must work in WHERE if you wrap it in a subquery
SELECT *
FROM (
        SELECT count(*) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS c
        FROM numbers(3)
    )
WHERE c > 0;

-- should work in ORDER BY
SELECT
    number,
    max(number) OVER (PARTITION BY intDiv(number, 3) ORDER BY number DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS m
FROM numbers(10)
ORDER BY
    m DESC,
    number ASC;

-- also works in ORDER BY if you wrap it in a subquery
SELECT *
FROM (
        SELECT count(*) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS c
        FROM numbers(3)
    )
ORDER BY c ASC;

-- Example with window function only in ORDER BY. Here we make a rank of all
-- numbers sorted descending, and then sort by this rank descending, and must get
-- the ascending order.
SELECT *
FROM (
        SELECT *
        FROM numbers(5)
        ORDER BY rand() ASC
    )
ORDER BY count() OVER (ORDER BY number DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) DESC;

-- Aggregate functions as window function arguments. This query is semantically
-- the same as the above one, only we replace `number` with
-- `any(number) group by number` and so on.
SELECT *
FROM (
        SELECT *
        FROM numbers(5)
        ORDER BY rand() ASC
    )
GROUP BY number
ORDER BY sum(any(number + 1)) OVER (ORDER BY min(number) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) DESC;

-- some more simple cases w/aggregate functions
SELECT sum(any(number)) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(1);

SELECT sum(any(number) + 1) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(1);

SELECT sum(any(number + 1)) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(1);

-- different windows
-- an explain test would also be helpful, but it's too immature now and I don't
-- want to change reference all the time
SELECT
    number,
    max(number) OVER (PARTITION BY intDiv(number, 3) ORDER BY number DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
    count(number) OVER (PARTITION BY intDiv(number, 5) ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS m
FROM numbers(31)
ORDER BY number ASC
SETTINGS max_block_size = '2';

-- two functions over the same window
-- an explain test would also be helpful, but it's too immature now and I don't
-- want to change reference all the time
SELECT
    number,
    max(number) OVER (PARTITION BY intDiv(number, 3) ORDER BY number DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
    count(number) OVER (PARTITION BY intDiv(number, 3) ORDER BY number DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS m
FROM numbers(7)
ORDER BY number ASC
SETTINGS max_block_size = '2';

-- check that we can work with constant columns
SELECT median(x) OVER (PARTITION BY x)
FROM (
        SELECT 1 AS x
    );

-- an empty window definition is valid as well
SELECT groupArray(number) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(3);

SELECT groupArray(number) OVER ()
FROM numbers(3);

-- This one tests we properly process the window  function arguments.
-- Seen errors like 'column `1` not found' from count(1).
SELECT
    count(1) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
    max(number + 1) OVER ()
FROM numbers(3);

-- Should work in DISTINCT
SELECT DISTINCT sum(0) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(2);

SELECT DISTINCT any(number) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(2);

-- Various kinds of aliases are properly substituted into various parts of window
-- function definition.
WITH number + 1 AS x

SELECT
    intDiv(number, 3) AS y,
    sum(x + y) OVER (PARTITION BY y ORDER BY x ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(7);

-- WINDOW clause
SELECT 1
WINDOW w1 AS ();

SELECT
    sum(number) OVER w1,
    sum(number) OVER w2
FROM numbers(10)
WINDOW
    w1 AS (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
    w2 AS (PARTITION BY intDiv(number, 3) AS value ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);

-- FIXME both functions should use the same window, but they don't. Add an
-- EXPLAIN test for this.
SELECT
    sum(number) OVER w1,
    sum(number) OVER (PARTITION BY intDiv(number, 3) AS value ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(10)
WINDOW w1 AS (PARTITION BY intDiv(number, 3) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);

-- RANGE frame
-- It's the default
SELECT sum(number) OVER ()
FROM numbers(3);

-- Try some mutually prime sizes of partition, group and block, for the number
-- of rows that is their least common multiple + 1, so that we see all the
-- interesting corner cases.
SELECT
    number,
    intDiv(number, 3) AS p,
    mod(number, 2) AS o,
    count(number) OVER w AS c
FROM numbers(31)
WINDOW w AS (PARTITION BY p ORDER BY o ASC, number ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY number ASC
SETTINGS max_block_size = '5';

SELECT
    number,
    intDiv(number, 5) AS p,
    mod(number, 3) AS o,
    count(number) OVER w AS c
FROM numbers(31)
WINDOW w AS (PARTITION BY p ORDER BY o ASC, number ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY number ASC
SETTINGS max_block_size = '2';

SELECT
    number,
    intDiv(number, 5) AS p,
    mod(number, 2) AS o,
    count(number) OVER w AS c
FROM numbers(31)
WINDOW w AS (PARTITION BY p ORDER BY o ASC, number ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY number ASC
SETTINGS max_block_size = '3';

SELECT
    number,
    intDiv(number, 3) AS p,
    mod(number, 5) AS o,
    count(number) OVER w AS c
FROM numbers(31)
WINDOW w AS (PARTITION BY p ORDER BY o ASC, number ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY number ASC
SETTINGS max_block_size = '2';

SELECT
    number,
    intDiv(number, 2) AS p,
    mod(number, 5) AS o,
    count(number) OVER w AS c
FROM numbers(31)
WINDOW w AS (PARTITION BY p ORDER BY o ASC, number ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY number ASC
SETTINGS max_block_size = '3';

SELECT
    number,
    intDiv(number, 2) AS p,
    mod(number, 3) AS o,
    count(number) OVER w AS c
FROM numbers(31)
WINDOW w AS (PARTITION BY p ORDER BY o ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY number ASC
SETTINGS max_block_size = '5';

-- A case where the partition end is in the current block, and the frame end
-- is triggered by the partition end.
SELECT min(number) OVER (PARTITION BY p)
FROM (
        SELECT
            number,
            intDiv(number, 3) AS p
        FROM numbers(10)
    );

-- UNBOUNDED FOLLOWING frame end
SELECT
    min(number) OVER wa,
    min(number) OVER wo,
    max(number) OVER wa,
    max(number) OVER wo
FROM (
        SELECT
            number,
            intDiv(number, 3) AS p,
            mod(number, 5) AS o
        FROM numbers(31)
    )
WINDOW
    wa AS (PARTITION BY p ORDER BY o ASC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
    wo AS (PARTITION BY p ORDER BY o ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
SETTINGS max_block_size = '2';

-- ROWS offset frame start
SELECT
    number,
    p,
    count(*) OVER (PARTITION BY p ORDER BY number ASC ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING),
    count(*) OVER (PARTITION BY p ORDER BY number ASC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING),
    count(*) OVER (PARTITION BY p ORDER BY number ASC ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING)
FROM (
        SELECT
            number,
            intDiv(number, 5) AS p
        FROM numbers(31)
    )
ORDER BY
    p ASC,
    number ASC
SETTINGS max_block_size = '2';

-- ROWS offset frame start and end
SELECT
    number,
    p,
    count(*) OVER (PARTITION BY p ORDER BY number ASC ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING)
FROM (
        SELECT
            number,
            intDiv(number, 7) AS p
        FROM numbers(71)
    )
ORDER BY
    p ASC,
    number ASC
SETTINGS max_block_size = '2';

SELECT count(*) OVER (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM numbers(4);

-- frame boundaries that runs into the partition end
SELECT
    count() OVER (PARTITION BY intDiv(number, 3) ROWS BETWEEN 100 FOLLOWING AND UNBOUNDED FOLLOWING),
    count() OVER (PARTITION BY intDiv(number, 3) ROWS BETWEEN CURRENT ROW AND 100 FOLLOWING)
FROM numbers(10);

-- seen a use-after-free under MSan in this query once
SELECT
    number,
    max(number) OVER (PARTITION BY intDiv(number, 7) ORDER BY number ASC NULLS LAST ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(1024)
SETTINGS max_block_size = '2'
FORMAT Null;

-- a corner case
SELECT count() OVER ();

-- RANGE CURRENT ROW frame start
SELECT
    number,
    p,
    o,
    count(*) OVER (PARTITION BY p ORDER BY o ASC RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM (
        SELECT
            number,
            intDiv(number, 5) AS p,
            mod(number, 3) AS o
        FROM numbers(31)
    )
ORDER BY
    p ASC,
    o ASC,
    number ASC
SETTINGS max_block_size = '2';

SELECT
    count(*) OVER (ROWS BETWEEN CURRENT ROW AND CURRENT ROW),
    count(*) OVER (RANGE BETWEEN CURRENT ROW AND CURRENT ROW)
FROM numbers(3);

-- RANGE OFFSET
-- a basic RANGE OFFSET frame
SELECT
    x,
    min(x) OVER w,
    max(x) OVER w,
    count(x) OVER w
FROM (
        SELECT toUInt8(number) AS x
        FROM numbers(11)
    )
WINDOW w AS (ORDER BY x ASC RANGE BETWEEN 1 PRECEDING AND 2 FOLLOWING)
ORDER BY x ASC;

-- overflow conditions
SELECT
    x,
    min(x) OVER w,
    max(x) OVER w,
    count(x) OVER w
FROM (
        SELECT toUInt8(if(mod(number, 2), toInt64(255 - intDiv(number, 2)), toInt64(intDiv(number, 2)))) AS x
        FROM numbers(10)
    )
WINDOW w AS (ORDER BY x ASC RANGE BETWEEN 1 PRECEDING AND 2 FOLLOWING)
ORDER BY x ASC;

SELECT
    x,
    min(x) OVER w,
    max(x) OVER w,
    count(x) OVER w
FROM (
        SELECT toInt8(multiIf(mod(number, 3) = 0, toInt64(intDiv(number, 3)), mod(number, 3) = 1, toInt64(127 - intDiv(number, 3)), toInt64(-128 + intDiv(number, 3)))) AS x
        FROM numbers(15)
    )
WINDOW w AS (ORDER BY x ASC RANGE BETWEEN 1 PRECEDING AND 2 FOLLOWING)
ORDER BY x ASC;

-- We need large offsets to trigger overflow to positive direction, or
-- else the frame end runs into partition end w/o overflow and doesn't move
-- after that. The frame from this query is equivalent to the entire partition.
SELECT
    x,
    min(x) OVER w,
    max(x) OVER w,
    count(x) OVER w
FROM (
        SELECT toUInt8(if(mod(number, 2), toInt64(255 - intDiv(number, 2)), toInt64(intDiv(number, 2)))) AS x
        FROM numbers(10)
    )
WINDOW w AS (ORDER BY x ASC RANGE BETWEEN 255 PRECEDING AND 255 FOLLOWING)
ORDER BY x ASC;

-- RANGE OFFSET ORDER BY DESC
SELECT
    x,
    min(x) OVER w,
    max(x) OVER w,
    count(x) OVER w
FROM (
        SELECT toUInt8(number) AS x
        FROM numbers(11)
    ) AS t
WINDOW w AS (ORDER BY x DESC RANGE BETWEEN 1 PRECEDING AND 2 FOLLOWING)
ORDER BY x ASC
SETTINGS max_block_size = '1';

SELECT
    x,
    min(x) OVER w,
    max(x) OVER w,
    count(x) OVER w
FROM (
        SELECT toUInt8(number) AS x
        FROM numbers(11)
    ) AS t
WINDOW w AS (ORDER BY x DESC RANGE BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING)
ORDER BY x ASC
SETTINGS max_block_size = '2';

SELECT
    x,
    min(x) OVER w,
    max(x) OVER w,
    count(x) OVER w
FROM (
        SELECT toUInt8(number) AS x
        FROM numbers(11)
    ) AS t
WINDOW w AS (ORDER BY x DESC RANGE BETWEEN UNBOUNDED PRECEDING AND 2 FOLLOWING)
ORDER BY x ASC
SETTINGS max_block_size = '3';

SELECT
    x,
    min(x) OVER w,
    max(x) OVER w,
    count(x) OVER w
FROM (
        SELECT toUInt8(number) AS x
        FROM numbers(11)
    ) AS t
WINDOW w AS (ORDER BY x DESC RANGE BETWEEN UNBOUNDED PRECEDING AND 2 PRECEDING)
ORDER BY x ASC
SETTINGS max_block_size = '4';

-- Check that we put windows in such an order that we can reuse the sort.
-- First, check that at least the result is correct when we have many windows
-- with different sort order.
SELECT
    number,
    count(*) OVER (PARTITION BY p ORDER BY number ASC),
    count(*) OVER (PARTITION BY p ORDER BY number ASC, o ASC),
    count(*) OVER (),
    count(*) OVER (ORDER BY number ASC),
    count(*) OVER (ORDER BY o ASC),
    count(*) OVER (ORDER BY o ASC, number ASC),
    count(*) OVER (ORDER BY number ASC, o ASC),
    count(*) OVER (PARTITION BY p ORDER BY o ASC, number ASC),
    count(*) OVER (PARTITION BY p),
    count(*) OVER (PARTITION BY p ORDER BY o ASC),
    count(*) OVER (PARTITION BY p, o ORDER BY number ASC)
FROM (
        SELECT
            number,
            intDiv(number, 3) AS p,
            mod(number, 5) AS o
        FROM numbers(16)
    ) AS t
ORDER BY number ASC;

-- The EXPLAIN for the above query would be difficult to understand, so check some
-- simple cases instead.
EXPLAIN
SELECT
    count(*) OVER (PARTITION BY p),
    count(*) OVER (),
    count(*) OVER (PARTITION BY p ORDER BY o ASC)
FROM (
        SELECT
            number,
            intDiv(number, 3) AS p,
            mod(number, 5) AS o
        FROM numbers(16)
    ) AS t;

EXPLAIN
SELECT
    count(*) OVER (ORDER BY o ASC, number ASC),
    count(*) OVER (ORDER BY number ASC)
FROM (
        SELECT
            number,
            intDiv(number, 3) AS p,
            mod(number, 5) AS o
        FROM numbers(16)
    ) AS t;

-- A test case for the sort comparator found by fuzzer.
SELECT
    max(number) OVER (ORDER BY number DESC NULLS FIRST),
    max(number) OVER (ORDER BY number ASC NULLS FIRST)
FROM numbers(2);

-- optimize_read_in_order conflicts with sorting for window functions, check that
-- it is disabled.
DROP TABLE IF EXISTS window_mt;

CREATE TABLE window_mt
ENGINE = MergeTree()
ORDER BY number AS
SELECT
    number,
    mod(number, 3) AS p
FROM numbers(100);

SELECT
    number,
    count(*) OVER (PARTITION BY p)
FROM window_mt
ORDER BY number ASC
LIMIT 10
SETTINGS optimize_read_in_order = '0';

SELECT
    number,
    count(*) OVER (PARTITION BY p)
FROM window_mt
ORDER BY number ASC
LIMIT 10
SETTINGS optimize_read_in_order = '1';

DROP TABLE window_mt;

-- some true window functions -- rank and friends
SELECT
    number,
    p,
    o,
    count(*) OVER w,
    rank() OVER w,
    dense_rank() OVER w,
    row_number() OVER w
FROM (
        SELECT
            number,
            intDiv(number, 5) AS p,
            mod(number, 3) AS o
        FROM numbers(31)
        ORDER BY
            o ASC,
            number ASC
    ) AS t
WINDOW w AS (PARTITION BY p ORDER BY o ASC, number ASC)
ORDER BY
    p ASC,
    o ASC,
    number ASC
SETTINGS max_block_size = '2';

-- our replacement for lag/lead
SELECT
    anyOrNull(number) OVER (ORDER BY number ASC ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING),
    anyOrNull(number) OVER (ORDER BY number ASC ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING)
FROM numbers(5);

-- variants of lag/lead that respect the frame
SELECT
    number,
    p,
    pp,
    lagInFrame(number) OVER w AS lag1,
    lagInFrame(number, number - pp) OVER w AS lag2,
    lagInFrame(number, number - pp, number * 11) OVER w AS lag,
    leadInFrame(number, number - pp, number * 11) OVER w AS lead
FROM (
        SELECT
            number,
            intDiv(number, 5) AS p,
            p * 5 AS pp
        FROM numbers(16)
    )
WINDOW w AS (PARTITION BY p ORDER BY number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
ORDER BY number ASC
SETTINGS max_block_size = '3';

;

-- careful with auto-application of Null combinator
SELECT lagInFrame(toNullable(1)) OVER ();

SELECT lagInFrameOrNull(1) OVER (); -- { serverError BAD_ARGUMENTS }

-- this is the same as `select max(Null::Nullable(Nothing))`
SELECT
    intDiv(1, NULL) AS x,
    toTypeName(x),
    max(x) OVER ();

-- to make lagInFrame return null for out-of-frame rows, cast the argument to
-- Nullable; otherwise, it returns default values.
SELECT
    number,
    lagInFrame(toNullable(number), 1) OVER w,
    lagInFrame(toNullable(number), 2) OVER w,
    lagInFrame(number, 1) OVER w,
    lagInFrame(number, 2) OVER w
FROM numbers(4)
WINDOW w AS (ORDER BY number ASC);

-- case-insensitive SQL-standard synonyms for any and anyLast
SELECT
    number,
    fIrSt_VaLue(number) OVER w,
    lAsT_vAlUe(number) OVER w
FROM numbers(10)
WINDOW w AS (ORDER BY number ASC RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING)
ORDER BY number ASC;

-- nth_value without specific frame range given
SELECT
    number,
    nth_value(number, 1) OVER w AS firstValue,
    nth_value(number, 2) OVER w AS secondValue,
    nth_value(number, 3) OVER w AS thirdValue,
    nth_value(number, 4) OVER w AS fourthValue
FROM numbers(10)
WINDOW w AS (ORDER BY number ASC)
ORDER BY number ASC;

-- nth_value with frame range specified
SELECT
    number,
    nth_value(number, 1) OVER w AS firstValue,
    nth_value(number, 2) OVER w AS secondValue,
    nth_value(number, 3) OVER w AS thirdValue,
    nth_value(number, 4) OVER w AS fourthValue
FROM numbers(10)
WINDOW w AS (ORDER BY number ASC RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING)
ORDER BY number ASC;

-- to make nth_value return null for out-of-frame rows, cast the argument to
-- Nullable; otherwise, it returns default values.
SELECT
    number,
    nth_value(toNullable(number), 1) OVER w AS firstValue,
    nth_value(toNullable(number), 3) OVER w AS thridValue
FROM numbers(5)
WINDOW w AS (ORDER BY number ASC);

-- nth_value UBsan
SELECT nth_value(1, -1) OVER (); -- { serverError BAD_ARGUMENTS }

SELECT nth_value(1, 0) OVER (); -- { serverError BAD_ARGUMENTS }

SELECT nth_value(
    1, /* INT64_MAX+1 */
    9223372036854775807 + 1
) OVER (); -- { serverError BAD_ARGUMENTS }

SELECT nth_value(
    1, /* INT64_MAX */
    9223372036854775807
) OVER ();

SELECT nth_value(1, 1) OVER ();

-- lagInFrame UBsan
SELECT lagInFrame(1, -1) OVER (); -- { serverError BAD_ARGUMENTS }

SELECT lagInFrame(1, 0) OVER ();

SELECT lagInFrame(
    1, /* INT64_MAX+1 */
    9223372036854775807 + 1
) OVER (); -- { serverError BAD_ARGUMENTS }

SELECT lagInFrame(
    1, /* INT64_MAX */
    9223372036854775807
) OVER ();

SELECT lagInFrame(1, 1) OVER ();

-- leadInFrame UBsan
SELECT leadInFrame(1, -1) OVER (); -- { serverError BAD_ARGUMENTS }

SELECT leadInFrame(1, 0) OVER ();

SELECT leadInFrame(
    1, /* INT64_MAX+1 */
    9223372036854775807 + 1
) OVER (); -- { serverError BAD_ARGUMENTS }

SELECT leadInFrame(
    1, /* INT64_MAX */
    9223372036854775807
) OVER ();

SELECT leadInFrame(1, 1) OVER ();

-- nth_value Msan
SELECT nth_value(1, '') OVER (); -- { serverError BAD_ARGUMENTS }

-- lagInFrame Msan
SELECT lagInFrame(1, '') OVER (); -- { serverError BAD_ARGUMENTS }

-- leadInFrame Msan
SELECT leadInFrame(1, '') OVER (); -- { serverError BAD_ARGUMENTS }

-- In this case, we had a problem with PartialSortingTransform returning zero-row
-- chunks for input chunks w/o columns.
SELECT count() OVER ()
FROM numbers(4)
WHERE number < 2;

-- floating point RANGE frame
SELECT
    count(*) OVER (ORDER BY toFloat32(number) ASC RANGE BETWEEN 5 PRECEDING AND CURRENT ROW),
    count(*) OVER (ORDER BY toFloat64(number) ASC RANGE BETWEEN 5 PRECEDING AND CURRENT ROW),
    count(*) OVER (ORDER BY toFloat32(number) ASC RANGE BETWEEN CURRENT ROW AND 5 FOLLOWING),
    count(*) OVER (ORDER BY toFloat64(number) ASC RANGE BETWEEN CURRENT ROW AND 5 FOLLOWING)
FROM numbers(7);

-- negative offsets should not be allowed
SELECT count() OVER (ORDER BY toInt64(number) ASC RANGE BETWEEN -1 PRECEDING AND UNBOUNDED FOLLOWING)
FROM numbers(1); -- { serverError BAD_ARGUMENTS }

SELECT count() OVER (ORDER BY toInt64(number) ASC RANGE BETWEEN -1 FOLLOWING AND UNBOUNDED FOLLOWING)
FROM numbers(1); -- { serverError BAD_ARGUMENTS }

SELECT count() OVER (ORDER BY toInt64(number) ASC RANGE BETWEEN UNBOUNDED PRECEDING AND -1 PRECEDING)
FROM numbers(1); -- { serverError BAD_ARGUMENTS }

SELECT count() OVER (ORDER BY toInt64(number) ASC RANGE BETWEEN UNBOUNDED PRECEDING AND -1 FOLLOWING)
FROM numbers(1); -- { serverError BAD_ARGUMENTS }

-- a test with aggregate function that allocates memory in arena
SELECT sum(a[length(a)])
FROM (
        SELECT groupArray(number) OVER (PARTITION BY modulo(number, 11) ORDER BY modulo(number, 1111) ASC, number ASC) AS a
        FROM numbers_mt(10000)
    )
SETTINGS max_block_size = '7';

-- a test with aggregate function which is -state type
SELECT bitmapCardinality(bs)
FROM (
        SELECT groupBitmapMergeState(bm) OVER (ORDER BY k ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS bs
        FROM (
                SELECT
                    groupBitmapState(number) AS bm,
                    k
                FROM (
                        SELECT
                            number,
                            number % 3 AS k
                        FROM numbers(3)
                    )
                GROUP BY k
            )
    );

-- -INT_MIN row offset that can lead to problems with negation, found when fuzzing
-- under UBSan. Should be limited to at most INT_MAX.
SELECT count() OVER (ROWS BETWEEN 2147483648 PRECEDING AND 2147493648 FOLLOWING)
FROM numbers(2); -- { serverError BAD_ARGUMENTS }

-- Somehow in this case WindowTransform gets empty input chunks not marked as
-- input end, and then two (!) empty input chunks marked as input end. Whatever.
SELECT count() OVER ()
FROM
    (
        SELECT 1 AS a
    ) AS l
INNER JOIN (
        SELECT 2 AS a
    ) AS r
    USING (a);

-- This case works as expected, one empty input chunk marked as input end.
SELECT count() OVER ()
WHERE NULL;

-- Inheriting another window.
SELECT
    number,
    count() OVER (w1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(10)
WINDOW
    w0 AS (PARTITION BY intDiv(number, 5) AS p),
    w1 AS (w0 ORDER BY mod(number, 3) AS o ASC, number ASC)
ORDER BY
    p ASC,
    o ASC,
    number ASC;

-- can't redefine PARTITION BY
SELECT count() OVER (w PARTITION BY number)
FROM numbers(1)
WINDOW w AS (PARTITION BY intDiv(number, 5)); -- { serverError BAD_ARGUMENTS }

-- can't redefine existing ORDER BY
SELECT count() OVER (w ORDER BY number ASC)
FROM numbers(1)
WINDOW w AS (PARTITION BY intDiv(number, 5) ORDER BY mod(number, 3) ASC); -- { serverError BAD_ARGUMENTS }

-- parent window can't have frame
SELECT count() OVER (w RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM numbers(1)
WINDOW w AS (PARTITION BY intDiv(number, 5) ORDER BY mod(number, 3) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW); -- { serverError BAD_ARGUMENTS }

-- looks weird but probably should work -- this is a window that inherits and changes nothing
SELECT count() OVER (w)
FROM numbers(1)
WINDOW w AS ();

-- nonexistent parent window
SELECT count() OVER (w2 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW); -- { serverError BAD_ARGUMENTS }