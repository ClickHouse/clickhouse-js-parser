DROP TABLE IF EXISTS t SYNC;

CREATE TABLE t
(
    product Enum8('IU' = 1, 'WS' = 2),
    machine String,
    branch String,
    generated_time DateTime
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/t', 'r1')
ORDER BY (product, machine, branch, generated_time)
PARTITION BY (product, toYYYYMM(generated_time));

INSERT INTO t;

ALTER TABLE t MODIFY COLUMN product Enum8('IU' = 1, 'WS' = 2, 'PS' = 3) SETTINGS alter_sync = '2';

SELECT product
FROM t
GROUP BY product
ORDER BY product ASC;

DROP TABLE t SYNC;