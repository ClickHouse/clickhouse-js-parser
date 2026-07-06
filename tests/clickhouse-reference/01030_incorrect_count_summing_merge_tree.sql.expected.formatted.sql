SET optimize_on_insert = '0';

SELECT '-- SummingMergeTree with Nullable column without duplicates.';

DROP TABLE IF EXISTS tst;

CREATE TABLE tst
(
    timestamp DateTime,
    val Nullable(Int8)
)
ENGINE = SummingMergeTree()
ORDER BY timestamp
PARTITION BY toYYYYMM(timestamp);

INSERT INTO tst;

SELECT *
FROM tst FINAL
ORDER BY timestamp ASC;

SELECT count()
FROM tst;

SELECT count()
FROM tst FINAL;

SELECT count()
FROM tst
WHERE timestamp IS NOT NULL;

SELECT count()
FROM tst FINAL
WHERE timestamp IS NOT NULL;

SELECT count()
FROM tst
WHERE val IS NOT NULL;

SELECT count()
FROM tst FINAL
WHERE val IS NOT NULL;

SELECT count()
FROM tst FINAL
WHERE timestamp > 0;

SELECT count()
FROM tst FINAL
PREWHERE timestamp > 0;

SELECT count()
FROM tst FINAL
WHERE timestamp > '2017-01-01 00:00:00';

SELECT count()
FROM tst FINAL
PREWHERE timestamp > '2017-01-01 00:00:00';

SELECT count()
FROM tst FINAL
WHERE val > 0;

SELECT count()
FROM tst FINAL
PREWHERE val > 0;

INSERT INTO tst;

CREATE TABLE tst
(
    timestamp DateTime,
    val Int8
)
ENGINE = SummingMergeTree()
ORDER BY timestamp
PARTITION BY toYYYYMM(timestamp);

DROP TABLE tst;