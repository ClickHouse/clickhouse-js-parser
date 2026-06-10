-- Tags: global
DROP TABLE IF EXISTS xp;

DROP TABLE IF EXISTS xp_d;

CREATE TABLE xp
(
    i Nullable(UInt64),
    j UInt64
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS index_granularity = '1', allow_nullable_key = '1';

CREATE TABLE xp_d AS xp
ENGINE = Distributed(test_shard_localhost, currentDatabase(), xp);

INSERT INTO xp SELECT
    number,
    number + 2
FROM numbers(10);

INSERT INTO xp SELECT
    NULL,
    100;

OPTIMIZE TABLE xp FINAL;

SET max_rows_to_read = '2';

SELECT *
FROM xp
WHERE i IN ([0, 1]);

SELECT *
FROM xp
WHERE i GLOBAL IN ([0, 1]);

SELECT *
FROM xp_d
WHERE i IN ([0, 1]);

SELECT *
FROM xp_d
WHERE i GLOBAL IN ([0, 1]);

SET max_rows_to_read = '4'; -- 2 in the subquery, 2 in the query itself

SELECT *
FROM xp
WHERE i IN (
        SELECT *
        FROM numbers(2)
    );

SELECT *
FROM xp
WHERE i GLOBAL IN (
        SELECT *
        FROM numbers(2)
    );

SELECT *
FROM xp_d
WHERE i IN (
        SELECT *
        FROM numbers(2)
    );

SET max_rows_to_read = '6'; -- 2 subquery, 2 from global temp table (GLOBAL IN), 2 from local xp table

SELECT *
FROM xp_d
WHERE i GLOBAL IN (
        SELECT *
        FROM numbers(2)
    );

SET transform_null_in = '1';

SET max_rows_to_read = '0'; -- No rows should be read

SELECT *
FROM xp
WHERE i IN (NULL);

SELECT *
FROM xp
WHERE i GLOBAL IN (NULL);

SELECT *
FROM xp_d
WHERE i IN (NULL);

SELECT *
FROM xp_d
WHERE i GLOBAL IN (NULL);