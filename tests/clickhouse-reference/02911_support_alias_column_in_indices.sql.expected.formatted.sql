-- add_minmax_index_for_numeric_columns=0: Different plan
CREATE TABLE test1
(
    c UInt32,
    a ALIAS c + 1,
    INDEX i a TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY c
SETTINGS index_granularity = '8192', min_index_granularity_bytes = '1024', index_granularity_bytes = '10485760', add_minmax_index_for_numeric_columns = '0'; -- default settings, prevent randomization in tests

INSERT INTO test1 SELECT *
FROM numbers(10);

INSERT INTO test1 SELECT *
FROM numbers(11, 20);

EXPLAIN indexes = '1'
SELECT *
FROM test1
WHERE a > 10
SETTINGS enable_analyzer = '0';

EXPLAIN indexes = '1'
SELECT *
FROM test1
WHERE a > 10
SETTINGS enable_analyzer = '1';

CREATE TABLE test2
(
    c UInt32,
    a1 ALIAS c + 1,
    a2 ALIAS a1 + 1,
    INDEX i a2 TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY c
SETTINGS index_granularity = '8192', min_index_granularity_bytes = '1024', index_granularity_bytes = '10485760', add_minmax_index_for_numeric_columns = '0'; -- default settings, prevent randomization in tests

INSERT INTO test2 SELECT *
FROM numbers(10);

INSERT INTO test2 SELECT *
FROM numbers(11, 20);

EXPLAIN indexes = '1'
SELECT *
FROM test2
WHERE a2 > 15
SETTINGS enable_analyzer = '0';

EXPLAIN indexes = '1'
SELECT *
FROM test2
WHERE a2 > 15
SETTINGS enable_analyzer = '1';