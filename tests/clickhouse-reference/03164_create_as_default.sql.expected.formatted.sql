DROP TABLE IF EXISTS src_table;

DROP TABLE IF EXISTS copied_table;

CREATE TABLE src_table
(
    time DateTime('UTC') DEFAULT fromUnixTimestamp(sipTimestamp),
    sipTimestamp UInt64
)
ENGINE = MergeTree()
ORDER BY time;

INSERT INTO src_table (sipTimestamp);

CREATE TABLE copied_table AS src_table;

ALTER TABLE copied_table RENAME COLUMN sipTimestamp TO timestamp;

SHOW CREATE TABLE src_table;

SELECT
    name,
    default_expression
FROM `system`.`columns`
WHERE database = currentDatabase()
    AND table = 'src_table'
ORDER BY name ASC;

SELECT *
FROM src_table
ORDER BY time ASC
FORMAT JSONEachRow;

SELECT *
FROM copied_table
ORDER BY time ASC
FORMAT JSONEachRow;

DROP TABLE src_table;

DROP TABLE copied_table;