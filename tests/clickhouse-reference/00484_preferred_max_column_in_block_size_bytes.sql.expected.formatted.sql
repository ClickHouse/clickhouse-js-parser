-- Tags: no-random-settings
DROP TABLE IF EXISTS tab_00484;

CREATE TABLE tab_00484
(
    date Date,
    x UInt64,
    s FixedString(128)
)
ENGINE = MergeTree()
ORDER BY (date, x)
PARTITION BY date
SETTINGS min_bytes_for_wide_part = '0', ratio_of_defaults_for_sparse_serialization = '1';

INSERT INTO tab_00484 SELECT
    today(),
    number,
    toFixedString('', 128)
FROM `system`.numbers
LIMIT 8192;

SET preferred_block_size_bytes = '2000000';

SET preferred_max_column_in_block_size_bytes = '0';

SELECT
    max(blockSize()),
    min(blockSize()),
    any(ignore(*))
FROM tab_00484;

SET preferred_max_column_in_block_size_bytes = '128';

SET preferred_max_column_in_block_size_bytes = '256';

SET preferred_max_column_in_block_size_bytes = '2097152';

SET preferred_max_column_in_block_size_bytes = '4194304';

INSERT INTO tab_00484 SELECT
    today(),
    number,
    toFixedString('', 128)
FROM `system`.numbers
LIMIT 47;

SET preferred_max_column_in_block_size_bytes = '1152';

SELECT
    blockSize(),
    *
FROM tab_00484
WHERE x = 1
    OR x > 36
FORMAT Null;

INSERT INTO tab_00484 SELECT
    today(),
    number,
    toFixedString('', 128)
FROM `system`.numbers
LIMIT 10;

SELECT s
FROM tab_00484
WHERE s = ''
FORMAT Null;

CREATE TABLE tab_00484
(
    date Date,
    x UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY (date, x)
PARTITION BY date
SETTINGS min_bytes_for_wide_part = '0', ratio_of_defaults_for_sparse_serialization = '1';

INSERT INTO tab_00484 SELECT
    today(),
    number,
    'abc'
FROM `system`.numbers
LIMIT 81920;

SET preferred_block_size_bytes = '0';

SELECT count(*)
FROM tab_00484
PREWHERE s != 'abc'
FORMAT Null;

SELECT count(*)
FROM tab_00484
PREWHERE s = 'abc'
FORMAT Null;

DROP TABLE tab_00484;