SELECT '--- int, single part';

CREATE TABLE single_int
(
    k Int64,
    c Nullable(Int64)
)
ENGINE = MergeTree()
ORDER BY k;

INSERT INTO single_int;

SELECT c
FROM single_int
ORDER BY `ALL` ASC
SETTINGS extremes = '1';

CREATE TABLE multi_int
(
    k Int64,
    c Nullable(Int64)
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY k;

INSERT INTO multi_int;

SELECT c
FROM multi_int
ORDER BY `ALL` ASC
SETTINGS extremes = '1';

CREATE TABLE single_float
(
    k Int64,
    c Float64
)
ENGINE = MergeTree()
ORDER BY c;

INSERT INTO single_float;

SELECT c
FROM single_float
ORDER BY `ALL` ASC
SETTINGS extremes = '1';

CREATE TABLE multi_float
(
    k Int64,
    c Float64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY k;

INSERT INTO multi_float;

SELECT c
FROM multi_float
ORDER BY `ALL` ASC
SETTINGS extremes = '1';