CREATE TABLE merge_kek_1
(
    x UInt32,
    y UInt32
)
ENGINE = MergeTree()
ORDER BY x;

CREATE TABLE merge_kek_2
(
    x UInt32,
    y UInt32
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO merge_kek_1 SELECT
    number,
    number
FROM numbers(100);

INSERT INTO merge_kek_2 SELECT
    number + 500,
    number + 500
FROM numbers(1000000.);

SELECT
    sum(x),
    min(x + x),
    max(x + x)
FROM merge(currentDatabase(), '^merge_kek_.$')
WHERE x > 200
    AND y IN (
        SELECT 500 + number * 2
        FROM numbers(100)
    )
SETTINGS max_threads = '2';