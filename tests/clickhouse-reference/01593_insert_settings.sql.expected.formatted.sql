DROP TABLE IF EXISTS data_01593;

CREATE TABLE data_01593
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key
PARTITION BY key;

INSERT INTO data_01593 SELECT *
FROM numbers_mt(10);

INSERT INTO data_01593 SELECT *
FROM numbers_mt(10)
SETTINGS max_partitions_per_insert_block = '1'; -- { serverError TOO_MANY_PARTS }

-- throw_on_max_partitions_per_insert_block=false means we'll just log that the limit was reached rather than throw
INSERT INTO data_01593 SELECT *
FROM numbers_mt(10)
SETTINGS
    max_partitions_per_insert_block = '1',
    throw_on_max_partitions_per_insert_block = false;

-- settings for INSERT is prefered
INSERT INTO data_01593 SETTINGS max_partitions_per_insert_block = '100' SELECT *
FROM numbers_mt(10)
SETTINGS max_partitions_per_insert_block = '1';

DROP TABLE data_01593;