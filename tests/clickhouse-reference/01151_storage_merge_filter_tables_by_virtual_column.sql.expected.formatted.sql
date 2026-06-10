DROP TABLE IF EXISTS src_table_1;

DROP TABLE IF EXISTS src_table_2;

DROP TABLE IF EXISTS src_table_3;

DROP TABLE IF EXISTS `set`;

CREATE TABLE src_table_1
(
    n UInt64
)
ENGINE = Memory() AS
SELECT *
FROM numbers(10);

CREATE TABLE src_table_2
(
    n UInt64
)
ENGINE = Log() AS
SELECT number * 10
FROM numbers(10);

CREATE TABLE src_table_3
(
    n UInt64
)
ENGINE = MergeTree()
ORDER BY n AS
SELECT number * 100
FROM numbers(10);

CREATE TABLE `set`
(
    s String
)
ENGINE = Set() AS
SELECT arrayJoin(['src_table_1', 'src_table_2']);

CREATE TEMPORARY TABLE tmp
(
    s String
);

INSERT INTO tmp;

SELECT
    count(),
    sum(n)
FROM merge(currentDatabase(), 'src_table');

-- FIXME #21401 select count(), sum(n) from merge(currentDatabase(), 'src_table') where _table = 'src_table_1' or toInt8(substr(_table, 11, 1)) = 2;
SELECT
    count(),
    sum(n)
FROM merge(currentDatabase(), 'src_table')
WHERE _table IN ('src_table_2', 'src_table_3');

SELECT
    count(),
    sum(n)
FROM merge(currentDatabase(), 'src_table')
WHERE _table IN ('src_table_2', 'src_table_3')
    AND n % 20 = 0;

SELECT
    count(),
    sum(n)
FROM merge(currentDatabase(), 'src_table')
WHERE _table IN (`set`);

SELECT
    count(),
    sum(n)
FROM merge(currentDatabase(), 'src_table')
WHERE _table IN (tmp);

SELECT
    count(),
    sum(n)
FROM merge(currentDatabase(), 'src_table')
WHERE _table IN (`set`)
    AND n % 2 = 0;

SELECT
    count(),
    sum(n)
FROM merge(currentDatabase(), 'src_table')
WHERE n % 2 = 0
    AND _table IN (tmp);

DROP TABLE src_table_1;

DROP TABLE src_table_2;

DROP TABLE src_table_3;

DROP TABLE `set`;