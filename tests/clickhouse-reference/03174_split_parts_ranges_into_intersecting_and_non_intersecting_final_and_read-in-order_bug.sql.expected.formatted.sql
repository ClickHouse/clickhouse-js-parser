-- Tags: no-tsan, no-asan, no-msan, no-fasttest
-- Test is slow
CREATE TABLE tab
(
    x DateTime('UTC'),
    y UInt32,
    v Int32
)
ENGINE = ReplacingMergeTree(v)
ORDER BY x;

INSERT INTO tab SELECT
    toDateTime('2000-01-01', 'UTC') + number,
    number,
    1
FROM numbers(10000000.);

OPTIMIZE TABLE tab FINAL;

WITH 60 * 60 * 24 AS d

SELECT
    toStartOfDay(x) AS k,
    sum(y) AS v,
    (z + d) * (z + d - 1) / 2 - (toUInt64(k - toDateTime('2000-01-01', 'UTC')) AS z) * (z - 1) / 2 AS est,
    est - v AS delta
FROM tab FINAL
GROUP BY k
ORDER BY k ASC
SETTINGS
    max_threads = '8',
    optimize_aggregation_in_order = '1',
    split_parts_ranges_into_intersecting_and_non_intersecting_final = '1';