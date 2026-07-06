SET allow_experimental_statistics = '1';

SET allow_statistics_optimize = '1';

SET mutations_sync = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    a Float64 STATISTICS(tdigest())
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT number
FROM `system`.numbers
LIMIT 10000;

SELECT count(*)
FROM tab
WHERE a < '10';

DROP TABLE tab;

CREATE TABLE tab
(
    a Int32 STATISTICS(tdigest())
)
ENGINE = MergeTree()
ORDER BY tuple();

SELECT count(*)
FROM tab
WHERE a < '10.5'; -- { serverError TYPE_MISMATCH }

SELECT count(*)
FROM tab
WHERE a < 10.5;

CREATE TABLE tab
(
    a Int16 STATISTICS(tdigest())
)
ENGINE = MergeTree()
ORDER BY tuple();

SELECT count(*)
FROM tab
WHERE a < '9999999999999999999999999';