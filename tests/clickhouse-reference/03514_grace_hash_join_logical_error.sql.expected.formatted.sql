DROP TABLE IF EXISTS A;

CREATE TABLE A
(
    A Int64,
    B Int64,
    S String
)
ENGINE = MergeTree()
ORDER BY A AS
SELECT
    number,
    number,
    toString(arrayMap((i -> cityHash64(i * number)), range(10)))
FROM numbers(1000000.);

SET max_threads = '0', join_algorithm = 'grace_hash', grace_hash_join_initial_buckets = '128', grace_hash_join_max_buckets = '256';

SELECT *
FROM
    A AS a
INNER JOIN A AS b
    ON a.A = b.A
LIMIT 1
FORMAT Null;

SET join_algorithm = 'grace_hash', grace_hash_join_initial_buckets = '128', grace_hash_join_max_buckets = '128';

DROP TABLE A;