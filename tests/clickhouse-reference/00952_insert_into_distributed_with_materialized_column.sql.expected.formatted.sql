-- Tags: distributed
DROP TABLE IF EXISTS local_00952;

DROP TABLE IF EXISTS distributed_00952;

SET insert_allow_materialized_columns = '0';

SET distributed_foreground_insert = '0';

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE local_00952
(
    date Date,
    value Date MATERIALIZED toDate('2017-08-01')
)
ENGINE = MergeTree(date, date, 8192);

CREATE TABLE distributed_00952 AS local_00952
ENGINE = Distributed('test_cluster_two_shards', currentDatabase(), local_00952, rand());

INSERT INTO distributed_00952;

SYSTEM FLUSH DISTRIBUTED distributed_00952;

SELECT *
FROM distributed_00952;

SELECT
    date,
    value
FROM distributed_00952;

SELECT *
FROM local_00952;

SELECT
    date,
    value
FROM local_00952;

DROP TABLE distributed_00952;

DROP TABLE local_00952;

SET distributed_foreground_insert = '1';

SET insert_allow_materialized_columns = '1';

INSERT INTO distributed_00952 (date, value);