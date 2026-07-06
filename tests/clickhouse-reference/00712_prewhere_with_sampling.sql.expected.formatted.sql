DROP TABLE IF EXISTS tab_00712_2;

CREATE TABLE tab_00712_2
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY b % 2
SAMPLE BY b % 2;

INSERT INTO tab_00712_2;

SELECT a
FROM tab_00712_2 SAMPLE 1/2
PREWHERE b = 2;

DROP TABLE IF EXISTS sample_prewhere;

CREATE TABLE sample_prewhere
(
    CounterID UInt32,
    UserID UInt64
)
ENGINE = MergeTree()
ORDER BY UserID
SAMPLE BY UserID;

SELECT count()
FROM sample_prewhere SAMPLE 1/2
PREWHERE CounterID = 1;

DROP TABLE sample_prewhere;