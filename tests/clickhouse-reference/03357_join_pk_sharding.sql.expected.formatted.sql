-- Tags: long, no-asan, no-msan
SET use_statistics = '0';

DROP TABLE IF EXISTS tab_l;

DROP TABLE IF EXISTS tab_m;

DROP TABLE IF EXISTS tab_r;

CREATE TABLE tab_l
(
    a UInt32,
    b UInt32,
    c UInt32,
    d UInt32
)
ENGINE = MergeTree()
ORDER BY (a * 2, b + c);

CREATE TABLE tab_m
(
    a UInt32,
    b UInt32,
    c UInt32,
    d UInt32
)
ENGINE = MergeTree()
ORDER BY (c + d, b * 2);

CREATE TABLE tab_r
(
    a UInt32,
    b UInt32,
    c UInt32,
    d UInt32
)
ENGINE = MergeTree()
ORDER BY (a * 2, c * 2);

INSERT INTO tab_l SELECT
    number,
    number,
    number,
    number
FROM numbers(1000000.);

INSERT INTO tab_m SELECT
    number,
    number,
    number,
    number
FROM numbers(1000000.);

INSERT INTO tab_r SELECT
    number,
    number,
    number,
    number
FROM numbers(1000000.);

--select explain e from (explain actions = 1 )
--where e like '%ReadFromMergeTree%' or e like '%Expression%' or e like '%Join%' or e like '%Clauses%' or e like '%Sharding%';
SET enable_analyzer = '1';

SET query_plan_join_swap_table = '0';

SET query_plan_join_shard_by_pk_ranges = '1';

SET allow_experimental_parallel_reading_from_replicas = '0';

SET enable_join_runtime_filters = '0';

SET max_threads = '4';

-- { echo On }
-- two tables
SELECT *
FROM
    tab_l AS l
INNER JOIN tab_m AS m
    ON l.a * 2 = m.c + m.d
    AND l.d = m.a
    AND l.b + l.c = m.b * 2
ORDER BY l.a ASC
LIMIT 10
OFFSET 999990;

SELECT `explain` AS e
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    tab_l AS l
                INNER JOIN tab_m AS m
                    ON l.a * 2 = m.c + m.d
                    AND l.b + l.c = m.b * 2
            ))
    )
WHERE e LIKE '%ReadFromMergeTree%'
    OR e LIKE '%Expression%'
    OR e LIKE '%Join%'
    OR e LIKE '%Clauses%'
    OR e LIKE '%Sharding%';

-- three tables
SELECT *
FROM
    tab_l AS l
INNER JOIN tab_m AS m
    ON l.a * 2 = m.c + m.d
    AND l.d = m.a
    AND l.b + l.c = m.b * 2
INNER JOIN tab_r AS r
    ON l.a * 2 = r.a * 2
    AND l.b + l.c = r.c * 2
    AND l.d = r.d
ORDER BY l.a ASC
LIMIT 10
OFFSET 999990;

SELECT `explain` AS e
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    tab_l AS l
                INNER JOIN tab_m AS m
                    ON l.a * 2 = m.c + m.d
                    AND l.d = m.a
                    AND l.b + l.c = m.b * 2
                INNER JOIN tab_r AS r
                    ON l.a * 2 = r.a * 2
                    AND l.b + l.c = r.c * 2
                    AND l.d = r.d
            ))
    )
WHERE e LIKE '%ReadFromMergeTree%'
    OR e LIKE '%Expression%'
    OR e LIKE '%Join%'
    OR e LIKE '%Clauses%'
    OR e LIKE '%Sharding%';

--- three tables, where m table matches one key, so that r table can match only one key as well
SELECT *
FROM
    tab_l AS l
INNER JOIN tab_m AS m
    ON l.a * 2 = m.c + m.d
    AND l.d = m.a
INNER JOIN tab_r AS r
    ON l.a * 2 = r.a * 2
    AND l.b + l.c = r.c * 2
    AND l.d = r.d
ORDER BY l.a ASC
LIMIT 10
OFFSET 999990;

SELECT `explain` AS e
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    tab_l AS l
                INNER JOIN tab_m AS m
                    ON l.a * 2 = m.c + m.d
                    AND l.d = m.a
                INNER JOIN tab_r AS r
                    ON l.a * 2 = r.a * 2
                    AND l.b + l.c = r.c * 2
                    AND l.d = r.d
            ))
    )
WHERE e LIKE '%ReadFromMergeTree%'
    OR e LIKE '%Expression%'
    OR e LIKE '%Join%'
    OR e LIKE '%Clauses%'
    OR e LIKE '%Sharding%';

--- three tables, right table matches one key
SELECT *
FROM
    tab_l AS l
INNER JOIN tab_m AS m
    ON l.a * 2 = m.c + m.d
    AND l.d = m.a
    AND l.b + l.c = m.b * 2
INNER JOIN tab_r AS r
    ON l.a * 2 = r.a * 2
    AND l.d = r.d
ORDER BY l.a ASC
LIMIT 10
OFFSET 999990;

SELECT `explain` AS e
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    tab_l AS l
                INNER JOIN tab_m AS m
                    ON l.a * 2 = m.c + m.d
                    AND l.d = m.a
                    AND l.b + l.c = m.b * 2
                INNER JOIN tab_r AS r
                    ON l.a * 2 = r.a * 2
                    AND l.d = r.d
            ))
    )
WHERE e LIKE '%ReadFromMergeTree%'
    OR e LIKE '%Expression%'
    OR e LIKE '%Join%'
    OR e LIKE '%Clauses%'
    OR e LIKE '%Sharding%';

--- three tables, tab_m table matches noting, so right table can match both keys
SELECT *
FROM
    tab_l AS l
INNER JOIN tab_m AS m
    ON l.d = m.a
INNER JOIN tab_r AS r
    ON l.a * 2 = r.a * 2
    AND l.b + l.c = r.c * 2
    AND l.d = r.d
ORDER BY l.a ASC
LIMIT 10
OFFSET 999990;

SELECT `explain` AS e
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    tab_l AS l
                INNER JOIN tab_m AS m
                    ON l.d = m.a
                INNER JOIN tab_r AS r
                    ON l.a * 2 = r.a * 2
                    AND l.b + l.c = r.c * 2
                    AND l.d = r.d
            ))
    )
WHERE e LIKE '%ReadFromMergeTree%'
    OR e LIKE '%Expression%'
    OR e LIKE '%Join%'
    OR e LIKE '%Clauses%'
    OR e LIKE '%Sharding%';

SET join_use_nulls = '1';

-- two tables
SELECT *
FROM
    tab_l AS l
RIGHT JOIN tab_m AS m
    ON l.a * 2 = m.c + m.d
    AND l.d = m.a
    AND l.b + l.c = m.b * 2
ORDER BY l.a ASC
LIMIT 10
OFFSET 999990;

SELECT `explain` AS e
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    tab_l AS l
                RIGHT JOIN tab_m AS m
                    ON l.a * 2 = m.c + m.d
                    AND l.b + l.c = m.b * 2
            ))
    )
WHERE e LIKE '%ReadFromMergeTree%'
    OR e LIKE '%Expression%'
    OR e LIKE '%Join%'
    OR e LIKE '%Clauses%'
    OR e LIKE '%Sharding%';

-- three tables
SELECT *
FROM
    tab_l AS l
LEFT JOIN tab_m AS m
    ON l.a * 2 = m.c + m.d
    AND l.d = m.a
    AND l.b + l.c = m.b * 2
LEFT JOIN tab_r AS r
    ON l.a * 2 = r.a * 2
    AND l.b + l.c = r.c * 2
    AND l.d = r.d
ORDER BY l.a ASC
LIMIT 10
OFFSET 999990;

SELECT `explain` AS e
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    tab_l AS l
                LEFT JOIN tab_m AS m
                    ON l.a * 2 = m.c + m.d
                    AND l.d = m.a
                    AND l.b + l.c = m.b * 2
                LEFT JOIN tab_r AS r
                    ON l.a * 2 = r.a * 2
                    AND l.b + l.c = r.c * 2
                    AND l.d = r.d
            ))
    )
WHERE e LIKE '%ReadFromMergeTree%'
    OR e LIKE '%Expression%'
    OR e LIKE '%Join%'
    OR e LIKE '%Clauses%'
    OR e LIKE '%Sharding%';