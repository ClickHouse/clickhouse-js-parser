-- Tags: long, replica
-- in case of keeper fault injection on insert, set bigger number of retries because partitions
SET insert_keeper_max_retries = '100';

SET insert_keeper_retry_max_backoff_ms = '10';

-- Testing basic functionality with compact parts
SET replication_alter_partitions_sync = '2';

DROP TABLE IF EXISTS mt_compact;

CREATE TABLE mt_compact
(
    a UInt64,
    b UInt64 DEFAULT a * a,
    s String,
    n Nested(x UInt32, y String),
    lc LowCardinality(String)
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test_01201/mt_compact_replicated', '1')
ORDER BY a
PARTITION BY a % 10
SETTINGS index_granularity = '8', min_rows_for_wide_part = '10';

INSERT INTO mt_compact (a, s, n.y, lc) SELECT
    number,
    toString((number * 2132214234 + 5434543) % 2133443),
    ['a', 'b', 'c'],
    number % 2 ? 'bar' : 'baz'
FROM numbers(90);

INSERT INTO mt_compact (a, s, n.x, lc) SELECT
    number % 3,
    toString((number * 75434535 + 645645) % 2133443),
    [1, 2],
    toString(number)
FROM numbers(5);

ALTER TABLE mt_compact DROP COLUMN n.y;

ALTER TABLE mt_compact ADD COLUMN `n.y` Array(String) DEFAULT ['qwqw'] AFTER n.x;

SELECT *
FROM mt_compact
ORDER BY
    a ASC,
    s ASC
LIMIT 10;

ALTER TABLE mt_compact UPDATE b = 42 WHERE 1 SETTINGS mutations_sync = '2';

SELECT *
FROM mt_compact
WHERE a > 1
ORDER BY
    a ASC,
    s ASC
LIMIT 10;