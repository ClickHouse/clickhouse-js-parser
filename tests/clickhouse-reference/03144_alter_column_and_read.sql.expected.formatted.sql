DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    x UInt32
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT number
FROM numbers(10);

SET alter_sync = '0';

ALTER TABLE tab UPDATE x = x + sleepEachRow(0.1) WHERE 1;

ALTER TABLE tab MODIFY COLUMN x String;

ALTER TABLE tab ADD COLUMN y String DEFAULT x || '_42';

SELECT
    x,
    y
FROM tab
ORDER BY x ASC;