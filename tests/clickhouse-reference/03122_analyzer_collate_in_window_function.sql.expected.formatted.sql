-- Tags: no-fasttest
-- https://github.com/ClickHouse/ClickHouse/issues/44039
SET enable_analyzer = '1';

CREATE TABLE test_window_collate
(
    c1 String,
    c2 String
)
ENGINE = MergeTree()
ORDER BY c1;

INSERT INTO test_window_collate;

INSERT INTO test_window_collate;

INSERT INTO test_window_collate;

SELECT
    c2,
    groupArray(c2) OVER (PARTITION BY c1 ORDER BY c2 ASC COLLATE 'zh_Hans_CN') AS res
FROM test_window_collate
ORDER BY c2 ASC COLLATE 'zh_Hans_CN';