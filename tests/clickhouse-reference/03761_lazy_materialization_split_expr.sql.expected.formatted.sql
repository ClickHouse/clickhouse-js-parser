-- Tags: no-random-merge-tree-settings, no-random-settings
SET query_plan_optimize_lazy_materialization = '1';

SET query_plan_max_limit_for_lazy_materialization = '10';

SET enable_analyzer = '1';

CREATE TABLE tab
(
    x UInt32,
    y UInt32,
    z UInt32
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT
    number,
    number,
    number
FROM numbers(1000000.);

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT
                            sin(x) + y AS a,
                            sin(x) - z AS b
                        FROM tab
                    )
                ORDER BY b ASC
                LIMIT 10
                SETTINGS
                    query_plan_max_limit_for_lazy_materialization = '0',
                    query_plan_execute_functions_after_sorting = '0'
            ))
    )
WHERE `explain` LIKE '%Lazily read columns%';