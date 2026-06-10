DROP TABLE IF EXISTS data_01295;

CREATE TABLE data_01295
(
    key Int
)
ENGINE = AggregatingMergeTree()
ORDER BY key;

INSERT INTO data_01295;

SELECT *
FROM data_01295;

INSERT INTO data_01295 SELECT *
FROM data_01295; -- no stuck for now

INSERT INTO data_01295 SELECT *
FROM data_01295 FINAL
SETTINGS max_threads = '2'; -- stuck with multiple threads

SET max_insert_threads = '2';

DROP TABLE data_01295;