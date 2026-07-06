-- Tags: global
DROP TABLE IF EXISTS xp;

DROP TABLE IF EXISTS xp_d;

CREATE TABLE xp
(
    A Date,
    B Int64,
    S String
)
ENGINE = MergeTree()
ORDER BY B
PARTITION BY toYYYYMM(A);

INSERT INTO xp SELECT
    '2020-01-01',
    number,
    ''
FROM numbers(100000);

CREATE TABLE xp_d AS xp
ENGINE = Distributed(test_shard_localhost, currentDatabase(), xp);

SELECT count()
FROM xp_d
PREWHERE toYYYYMM(A) GLOBAL IN (
        SELECT toYYYYMM(min(A))
        FROM xp_d
    )
WHERE B > -1;