-- https://github.com/ClickHouse/ClickHouse/issues/23416
SET enable_analyzer = '1';

CREATE TABLE test
(
    TOPIC String,
    `PARTITION` UInt64,
    `OFFSET` UInt64,
    ID UInt64
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_03062', 'r2')
ORDER BY (TOPIC, `PARTITION`, `OFFSET`);

CREATE TABLE test_join
(
    TOPIC String,
    `PARTITION` UInt64,
    `OFFSET` UInt64
)
ENGINE = Join(`ANY`, `LEFT`, TOPIC, `PARTITION`)
SETTINGS join_any_take_last_row = '1';

INSERT INTO test;

INSERT INTO test_join;

SELECT
    *,
    joinGet('test_join', 'OFFSET', TOPIC, `PARTITION`)
FROM test;

SELECT *
FROM
    test
ANY LEFT JOIN test_join
    USING (TOPIC, `PARTITION`);