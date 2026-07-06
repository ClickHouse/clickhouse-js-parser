DROP TABLE IF EXISTS enum_test;

CREATE TABLE enum_test
(
    timestamp DateTime,
    host String,
    e Enum8('IU' = 1, 'WS' = 2)
)
ENGINE = MergeTree()
ORDER BY (timestamp, host)
PARTITION BY toDate(timestamp);

INSERT INTO enum_test SELECT
    '2020-10-09 00:00:00',
    'h1',
    'WS'
FROM numbers(1);

ALTER TABLE enum_test MODIFY COLUMN e Enum8('IU' = 1, 'WS' = 2, 'PS' = 3);

INSERT INTO enum_test SELECT
    '2020-10-09 00:00:00',
    'h1',
    'PS'
FROM numbers(1);

SELECT *
FROM enum_test
ORDER BY
    timestamp ASC,
    e DESC
SETTINGS optimize_read_in_order = '1';