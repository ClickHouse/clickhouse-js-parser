DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    Col LowCardinality(String)
)
ENGINE = MergeTree();

INSERT INTO t1;

SELECT *
FROM remote('127.{1,2}', currentDatabase(), t1, multiIf(Col = 'a', 0, Col = 'b', 1, -1))
WHERE Col IN ('a', 'b')
ORDER BY `all` ASC
SETTINGS optimize_skip_unused_shards = '1';