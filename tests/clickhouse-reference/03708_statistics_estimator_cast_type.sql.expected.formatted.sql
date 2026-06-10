-- Tags: no-fasttest
CREATE TABLE dt64test
(
    dt64_column DateTime64(3),
    dt_column DateTime DEFAULT toDateTime(dt64_column)
)
ENGINE = MergeTree()
ORDER BY dt64_column
PARTITION BY toYYYYMM(dt64_column)
SETTINGS auto_statistics_types = 'tdigest';

SET use_statistics = '1';

INSERT INTO dt64test (dt64_column);

SELECT 'dt < const dt64'
FROM dt64test
WHERE dt_column < toDateTime64('2020-01-13 13:37:00', 3);

CREATE TABLE t1
(
    c0 Decimal(18, 0)
)
ENGINE = MergeTree()
ORDER BY c0
SETTINGS auto_statistics_types = 'countmin';

INSERT INTO t1 (c0);

SELECT c0 = CAST('6812671276462221925' AS Int64)
FROM t1;

SELECT 1
FROM t1
WHERE c0 = CAST('6812671276462221925' AS Int64);