DROP TABLE IF EXISTS xy;

CREATE TABLE xy
(
    x int,
    y int
)
ENGINE = MergeTree()
ORDER BY y
PARTITION BY intHash64(x) % 2
SETTINGS index_granularity = '1';

-- intHash64(0) % 2 = 0
-- intHash64(2) % 2 = 1
-- intHash64(8) % 2 = 0
-- intHash64(9) % 2 = 1
INSERT INTO xy;

-- Now we have two partitions: 0 and 1, each of which contains 2 values.
-- minmax index for the first partition is 0 <= x <= 8
-- minmax index for the second partition is 2 <= x <= 9
SET max_rows_to_read = '2';

SELECT *
FROM xy
WHERE intHash64(x) % 2 = intHash64(2) % 2;

-- Equality is another special operator that can be treated as an always monotonic indicator for deterministic functions.
-- minmax index is not enough.
SELECT *
FROM xy
WHERE x = 8;

-- Test if we provide enough columns to generate a partition value
DROP TABLE IF EXISTS xyz;

CREATE TABLE xyz
(
    x int,
    y int,
    z int
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY if(toUInt8(x), y, z)
SETTINGS index_granularity = '1';

INSERT INTO xyz;

SELECT *
FROM xyz
WHERE y = 2;

-- Test if we obey strict rules when facing NOT contitions
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    d Date,
    k Int64,
    s String
)
ENGINE = MergeTree()
ORDER BY (d, k)
PARTITION BY (toYYYYMM(d), k);

INSERT INTO test;

INSERT INTO test;

SELECT *
FROM test
WHERE d != '2020-01-01';

DROP TABLE test;

-- Test if single value partition pruning works correctly for Date = String
DROP TABLE IF EXISTS myTable;

CREATE TABLE myTable
(
    myDay Date,
    myOrder Int32,
    someData String
)
ENGINE = ReplacingMergeTree()
ORDER BY myOrder
PARTITION BY floor(toYYYYMMDD(myDay), -1);

INSERT INTO myTable (myDay, myOrder);

INSERT INTO myTable (myDay, myOrder); -- This row should be returned

INSERT INTO myTable (myDay, myOrder);

SELECT *
FROM myTable AS mt
WHERE myDay = '2021-01-02';

DROP TABLE myTable;