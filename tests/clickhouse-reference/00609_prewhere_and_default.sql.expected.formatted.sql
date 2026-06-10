DROP TABLE IF EXISTS table_00609;

CREATE TABLE table_00609
(
    key UInt64,
    val UInt64
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS index_granularity = '8192';

INSERT INTO table_00609 SELECT
    number,
    number / 8192
FROM `system`.numbers
LIMIT 100000;

ALTER TABLE table_00609 ADD COLUMN def UInt64 DEFAULT val + 1;

SELECT *
FROM table_00609
PREWHERE val > 2
FORMAT Null;

SELECT *
FROM table_00609
PREWHERE val > 2
FORMAT Null
SETTINGS max_block_size = '100';

SELECT *
FROM table_00609
PREWHERE val > 2
FORMAT Null
SETTINGS max_block_size = '1000';

SELECT *
FROM table_00609
PREWHERE val > 2
FORMAT Null
SETTINGS max_block_size = '10000';

SELECT *
FROM table_00609
PREWHERE val > 2
FORMAT Null
SETTINGS max_block_size = '20000';

SELECT *
FROM table_00609
PREWHERE val > 2
FORMAT Null
SETTINGS max_block_size = '30000';

SELECT *
FROM table_00609
PREWHERE val > 2
FORMAT Null
SETTINGS max_block_size = '40000';

SELECT *
FROM table_00609
PREWHERE val > 2
FORMAT Null
SETTINGS max_block_size = '80000';

ALTER TABLE table_00609 ADD COLUMN def UInt64;