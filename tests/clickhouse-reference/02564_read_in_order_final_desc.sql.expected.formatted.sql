SET optimize_read_in_order = '1';

DROP TABLE IF EXISTS mytable;

CREATE TABLE mytable
(
    timestamp UInt64,
    insert_timestamp UInt64,
    key UInt64,
    value Float64
)
ENGINE = ReplacingMergeTree(insert_timestamp)
PRIMARY KEY (key, timestamp)
ORDER BY (key, timestamp);

INSERT INTO mytable (timestamp, insert_timestamp, key, value);

SELECT
    timestamp,
    value
FROM mytable FINAL
WHERE key = 5
ORDER BY timestamp DESC;

SELECT if(`explain` LIKE '%ReadType: InOrder%', 'Ok', 'Error: ' || `explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    timestamp,
                    value
                FROM mytable FINAL
                WHERE key = 5
                ORDER BY timestamp ASC
                SETTINGS enable_vertical_final = '0'
            ))
    )
WHERE `explain` LIKE '%ReadType%';

SELECT if(`explain` LIKE '%ReadType: Default%', 'Ok', 'Error: ' || `explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    timestamp,
                    value
                FROM mytable FINAL
                WHERE key = 5
                ORDER BY timestamp DESC
            ))
    )
WHERE `explain` LIKE '%ReadType%';