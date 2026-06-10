DROP TABLE IF EXISTS test_grouping_sets_predicate;

CREATE TABLE test_grouping_sets_predicate
(
    day_ Date,
    type_1 String
)
ENGINE = MergeTree()
ORDER BY day_;

INSERT INTO test_grouping_sets_predicate SELECT
    toDate('2023-01-05') AS day_,
    'hello, world'
FROM numbers(10);

SET group_by_use_nulls = true;

SELECT *
FROM (
        SELECT
            day_,
            type_1
        FROM test_grouping_sets_predicate
        GROUP BY GROUPING SETS ((day_, type_1), (day_))
    )
WHERE day_ = '2023-01-05'
ORDER BY `ALL` ASC;

SELECT *
FROM (
        SELECT *
        FROM test_grouping_sets_predicate
        GROUP BY GROUPING SETS ((day_, type_1), (day_))
    )
WHERE day_ = '2023-01-05'
ORDER BY `ALL` ASC;

SELECT *
FROM (
        SELECT day_
        FROM test_grouping_sets_predicate
        GROUP BY GROUPING SETS ((day_, type_1), (day_))
    )
WHERE day_ = '2023-01-05'
ORDER BY * ASC
SETTINGS enable_analyzer = '1';

SELECT *
FROM (
        SELECT *
        FROM test_grouping_sets_predicate
        GROUP BY GROUPING SETS ((day_, type_1), (day_))
    )
WHERE day_ = '2023-01-05'
GROUP BY *
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT *
FROM (
        SELECT *
        FROM test_grouping_sets_predicate
        GROUP BY GROUPING SETS ((*), (day_))
    )
WHERE day_ = '2023-01-05'
GROUP BY GROUPING SETS ((*))
ORDER BY type_1 ASC
SETTINGS enable_analyzer = '1';

SELECT *
FROM (
        SELECT
            day_,
            COUNT(*)
        FROM test_grouping_sets_predicate
        GROUP BY GROUPING SETS ((day_, type_1), (day_))
    )
WHERE day_ = '2023-01-05'
ORDER BY `ALL` ASC;

SELECT t2.*
FROM (
        SELECT t1.*
        FROM test_grouping_sets_predicate AS t1
        GROUP BY GROUPING SETS ((day_, type_1), (day_))
    ) AS t2
WHERE day_ = '2023-01-05'
ORDER BY `ALL` ASC;