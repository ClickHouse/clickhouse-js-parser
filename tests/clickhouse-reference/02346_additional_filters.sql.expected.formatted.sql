-- Tags: distributed
DROP TABLE IF EXISTS table_1;

DROP TABLE IF EXISTS table_2;

DROP TABLE IF EXISTS v_numbers;

DROP TABLE IF EXISTS mv_table;

SET max_rows_to_read = '0';

CREATE TABLE table_1
(
    x UInt32,
    y String
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO table_1;

CREATE TABLE distr_table
(
    x UInt32,
    y String
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), 'table_1');

-- { echoOn }
SELECT *
FROM table_1;

SELECT *
FROM table_1
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT *
FROM table_1
SETTINGS additional_table_filters = [('table_1', 'x != 2 and x != 3')];

SELECT x
FROM table_1
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT y
FROM table_1
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT *
FROM table_1
WHERE x != 3
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT *
FROM table_1
PREWHERE x != 4
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT *
FROM table_1
PREWHERE x != 4
WHERE x != 3
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT x
FROM table_1
WHERE x != 3
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT x
FROM table_1
PREWHERE x != 4
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT x
FROM table_1
PREWHERE x != 4
WHERE x != 3
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT y
FROM table_1
WHERE x != 3
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT y
FROM table_1
PREWHERE x != 4
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT y
FROM table_1
PREWHERE x != 4
WHERE x != 3
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT x
FROM table_1
WHERE x != 2
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT x
FROM table_1
PREWHERE x != 2
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT x
FROM table_1
PREWHERE x != 2
WHERE x != 2
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT *
FROM remote('127.0.0.{1,2}', `system`.one)
SETTINGS additional_table_filters = [('system.one', 'dummy = 0')];

SELECT *
FROM remote('127.0.0.{1,2}', `system`.one)
SETTINGS additional_table_filters = [('system.one', 'dummy != 0')];

SELECT *
FROM distr_table
SETTINGS additional_table_filters = [('distr_table', 'x = 2')];

SELECT *
FROM distr_table
SETTINGS additional_table_filters = [('distr_table', 'x != 2 and x != 3')];

SELECT *
FROM `system`.numbers
LIMIT 5;

SELECT *
FROM `system`.numbers AS t
LIMIT 5
SETTINGS additional_table_filters = [('t', 'number % 2 != 0')];

SELECT *
FROM `system`.numbers
LIMIT 5
SETTINGS additional_table_filters = [('system.numbers', 'number != 3')];

SELECT *
FROM `system`.numbers
LIMIT 5
SETTINGS additional_table_filters = [('system.numbers', 'number != 3'), ('table_1', 'x!=2')];

SELECT *
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 5
        UNION ALL
        SELECT x
        FROM table_1
    )
ORDER BY number ASC
SETTINGS additional_table_filters = [('system.numbers', 'number != 3'), ('table_1', 'x!=2')];

SELECT
    number,
    x,
    y
FROM
    (
        SELECT number
        FROM `system`.numbers
        LIMIT 5
    ) AS f
ANY LEFT JOIN (
        SELECT
            x,
            y
        FROM table_1
    ) AS s
    ON f.number = s.x
ORDER BY `all` ASC
SETTINGS additional_table_filters = [('system.numbers', 'number != 3'), ('table_1', 'x != 2')];

SELECT b + 1 AS c
FROM (
        SELECT a + 1 AS b
        FROM (
                SELECT x + 1 AS a
                FROM table_1
            )
    )
SETTINGS additional_table_filters = [('table_1', 'x != 2 and x != 3')];

SELECT dummy
FROM `system`.one
SETTINGS additional_table_filters = [('system.one', 'dummy in (select number from numbers(2))')];

-- { echoOff }
CREATE VIEW v_numbers
AS
SELECT number + 1 AS x
FROM `system`.numbers
LIMIT 5;

-- { echoOn }
SELECT *
FROM v_numbers;

SELECT *
FROM v_numbers
SETTINGS additional_table_filters = [('system.numbers', 'number != 3')];

SELECT *
FROM v_numbers
SETTINGS additional_table_filters = [('v_numbers', 'x != 3')];

SELECT *
FROM v_numbers
SETTINGS additional_table_filters = [('system.numbers', 'number != 3'), ('v_numbers', 'x != 3')];

-- { echoOff }
CREATE TABLE table_2
(
    x UInt32,
    y String
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO table_2;

CREATE MATERIALIZED VIEW mv_table
TO table_2
(
    x UInt32,
    y String
)
AS
SELECT *
FROM table_1;

-- additional filter for inner tables for Materialized View does not work because it does not create internal interpreter
-- probably it is expected
-- { echoOn }
SELECT *
FROM mv_table;

SELECT *
FROM mv_table
SETTINGS additional_table_filters = [('mv_table', 'x != 5')];

SELECT *
FROM mv_table
SETTINGS additional_table_filters = [('table_1', 'x != 5')];

SELECT *
FROM mv_table
SETTINGS additional_table_filters = [('table_2', 'x != 5')];

-- { echoOff }
CREATE TABLE m_table
(
    x UInt32,
    y String
)
ENGINE = Merge(currentDatabase(), '^table_');

-- additional filter for inner tables for Merge does not work because it does not create internal interpreter
-- probably it is expected
-- { echoOn }
SELECT *
FROM m_table
ORDER BY x ASC;

SELECT *
FROM m_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_1', 'x != 2')];

SELECT *
FROM m_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_2', 'x != 5')];

SELECT *
FROM m_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_1', 'x != 2'), ('table_2', 'x != 5')];

SELECT *
FROM m_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_1', 'x != 4')];

SELECT *
FROM m_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_2', 'x != 4')];

SELECT *
FROM m_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_1', 'x != 4'), ('table_2', 'x != 4')];

SELECT *
FROM m_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('m_table', 'x != 4')];

SELECT *
FROM m_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('m_table', 'x != 4'), ('table_1', 'x != 2'), ('table_2', 'x != 5')];

-- additional_result_filter
SELECT *
FROM table_1
SETTINGS additional_result_filter = 'x != 2';

SELECT
    *,
    x != 2
FROM table_1
SETTINGS additional_result_filter = 'x != 2';

SELECT *
FROM table_1
WHERE x != 1
SETTINGS additional_result_filter = 'x != 2';

SELECT *
FROM table_1
WHERE x != 1
SETTINGS additional_result_filter = 'x != 2 and x != 3';

SELECT *
FROM table_1
PREWHERE x != 3
WHERE x != 1
SETTINGS additional_result_filter = 'x != 2';

SELECT *
FROM table_1
LIMIT 3
SETTINGS additional_result_filter = 'x != 2';

SELECT x + 1
FROM table_1
SETTINGS additional_result_filter = '`plus(x, 1)` != 2';

SELECT *
FROM (
        SELECT
            x + 1 AS a,
            y
        FROM table_1
        UNION ALL
        SELECT
            x AS a,
            y
        FROM table_1
    )
ORDER BY
    a ASC,
    y ASC
SETTINGS additional_result_filter = 'a = 3';

SELECT *
FROM (
        SELECT
            x + 1 AS a,
            y
        FROM table_1
        UNION ALL
        SELECT
            x AS a,
            y
        FROM table_1
    )
ORDER BY
    a ASC,
    y ASC
SETTINGS additional_result_filter = 'a != 3';