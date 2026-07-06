SELECT '-- remote table function columns description';

CREATE TABLE t0
(
    c Int DEFAULT 7
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO FUNCTION remote('localhost:9000', database(), 't0', 'default', '');

INSERT INTO t0;

SELECT *
FROM t0
ORDER BY `ALL` ASC;

CREATE TABLE fuzz_87972
(
    c0 Int MATERIALIZED 1,
    c1 Int EPHEMERAL
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO FUNCTION remote('localhost:9000', database(), 'fuzz_87972', 'default', ''); -- { error EMPTY_LIST_OF_COLUMNS_PASSED }

INSERT INTO FUNCTION file(database() || '_test.csv', CSV, 'a Int, b Int DEFAULT 77') SELECT
    number,
    if(number % 2 = 1, NULL, number)
FROM numbers(3);

INSERT INTO FUNCTION file(database() || '_test.csv', CSV, 'a Int, b Int DEFAULT 77');

SELECT *
FROM file(database() || '_test.csv')
ORDER BY `ALL` ASC;