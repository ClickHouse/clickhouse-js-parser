DROP TABLE IF EXISTS partitioned_table;

DROP TABLE IF EXISTS mv_table;

SET deduplicate_blocks_in_dependent_materialized_views = '1';

CREATE TABLE partitioned_table
(
    key Int64,
    value String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/03008_deduplication_insert_into_partitioned_table', '{replica}')
ORDER BY tuple()
PARTITION BY key % 10;

CREATE MATERIALIZED VIEW mv_table
(
    key Int64,
    value String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/03008_deduplication_insert_into_partitioned_table_mv', '{replica}')
ORDER BY tuple()
AS
SELECT
    key,
    value
FROM partitioned_table;

INSERT INTO partitioned_table;

INSERT INTO partitioned_table;

INSERT INTO partitioned_table;

SELECT *
FROM partitioned_table
ORDER BY `ALL` ASC;

SELECT *
FROM mv_table
ORDER BY `ALL` ASC;

DROP TABLE partitioned_table;

DROP TABLE mv_table;

INSERT INTO partitioned_table SETTINGS insert_deduplication_token = 'token_1';

INSERT INTO partitioned_table SETTINGS insert_deduplication_token = 'token_2';

INSERT INTO partitioned_table SETTINGS insert_deduplication_token = 'token_3';

INSERT INTO partitioned_table SETTINGS insert_deduplication_token = 'token_0';

INSERT INTO partitioned_table SETTINGS insert_deduplication_token = 'token_0';

INSERT INTO partitioned_table SETTINGS insert_deduplication_token = 'token_0';