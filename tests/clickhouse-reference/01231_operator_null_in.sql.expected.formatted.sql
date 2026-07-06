-- Tags: no-parallel-replicas
DROP TABLE IF EXISTS null_in;

CREATE TABLE null_in
(
    dt DateTime,
    idx int,
    i Nullable(int),
    s Nullable(String)
)
ENGINE = MergeTree()
ORDER BY idx
PARTITION BY dt
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO null_in;

SELECT count() = 2
FROM null_in
WHERE i IN (1, 3, NULL);

SELECT count() = 2
FROM null_in
WHERE i IN (range(4));

SELECT count() = 2
FROM null_in
WHERE s IN ('1', '3', NULL);

SELECT count() = 2
FROM null_in
WHERE i GLOBAL IN (1, 3, NULL);

SELECT count() = 2
FROM null_in
WHERE i GLOBAL IN (range(4));

SELECT count() = 2
FROM null_in
WHERE s GLOBAL IN ('1', '3', NULL);

SELECT count() = 1
FROM null_in
WHERE i NOT IN (1, 3, NULL);

SELECT count() = 1
FROM null_in
WHERE i NOT IN (range(4));

SELECT count() = 1
FROM null_in
WHERE s NOT IN ('1', '3', NULL);

SELECT count() = 1
FROM null_in
WHERE i GLOBAL NOT IN (1, 3, NULL);

SELECT count() = 1
FROM null_in
WHERE i GLOBAL NOT IN (range(4));

SELECT count() = 1
FROM null_in
WHERE s GLOBAL NOT IN ('1', '3', NULL);

SET transform_null_in = '1';

SELECT count() = 4
FROM null_in
WHERE i IN (1, 3, NULL);

SELECT count() = 4
FROM null_in
WHERE s IN ('1', '3', NULL);

SELECT count() = 4
FROM null_in
WHERE i GLOBAL IN (1, 3, NULL);

SELECT count() = 4
FROM null_in
WHERE s GLOBAL IN ('1', '3', NULL);

SELECT count() = 3
FROM null_in
WHERE i NOT IN (range(4));

SELECT count() = 3
FROM null_in
WHERE i GLOBAL NOT IN (range(4));

SELECT count() = 3
FROM null_in
WHERE i NOT IN (1, 3);

SELECT count() = 3
FROM null_in
WHERE s NOT IN ('1', '3');

SELECT count() = 3
FROM null_in
WHERE i GLOBAL NOT IN (1, 3);

SELECT count() = 3
FROM null_in
WHERE s GLOBAL NOT IN ('1', '3');

DROP TABLE IF EXISTS test_set;

CREATE TABLE test_set
(
    i Nullable(int)
)
ENGINE = Set();

INSERT INTO test_set;

SET transform_null_in = '0';

SELECT count() = 1
FROM null_in
WHERE i IN (test_set);

SELECT count() = 2
FROM null_in
WHERE i NOT IN (test_set);

SELECT count() = 1
FROM null_in
WHERE i GLOBAL IN (test_set);

SELECT count() = 2
FROM null_in
WHERE i GLOBAL NOT IN (test_set);

SELECT count() = 3
FROM null_in
WHERE i IN (test_set);

SELECT count() = 3
FROM null_in
WHERE i GLOBAL IN (test_set);

-- Create with transform_null_in
CREATE TABLE test_set2
(
    i Nullable(int)
)
ENGINE = Set();

INSERT INTO test_set2;

SELECT count() = 1
FROM null_in
WHERE i IN (test_set2);

SELECT count() = 2
FROM null_in
WHERE i NOT IN (test_set2);

SELECT count() = 1
FROM null_in
WHERE i GLOBAL IN (test_set2);

SELECT count() = 2
FROM null_in
WHERE i GLOBAL NOT IN (test_set2);

SELECT count() = 3
FROM null_in
WHERE i IN (test_set2);

SELECT count() = 3
FROM null_in
WHERE i GLOBAL IN (test_set2);

DROP TABLE test_set2;