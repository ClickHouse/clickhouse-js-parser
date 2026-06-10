-- Tags: long
DROP DICTIONARY IF EXISTS TestTblDict;

DROP VIEW IF EXISTS TestTbl_view;

DROP TABLE IF EXISTS TestTbl;

CREATE TABLE TestTbl
(
    id UInt16,
    dt Date,
    val String
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY dt;

CREATE VIEW TestTbl_view
AS
SELECT *
FROM TestTbl
WHERE dt = (
        SELECT max(dt)
        FROM TestTbl
    );

CREATE DICTIONARY IF NOT EXISTS TestTblDict
(
    id UInt16,
    dt Date,
    val String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE TestTbl_view DB currentDatabase()))
LIFETIME(MIN 0 MAX 1)
LAYOUT(COMPLEX_KEY_HASHED());

SELECT
    'view' AS src,
    *
FROM TestTbl_view;

SELECT
    'dict' AS src,
    *
FROM TestTblDict;

INSERT INTO TestTbl;

SELECT sleep(3)
FROM numbers(4)
SETTINGS max_block_size = '1'
FORMAT Null;

INSERT INTO TestTbl;