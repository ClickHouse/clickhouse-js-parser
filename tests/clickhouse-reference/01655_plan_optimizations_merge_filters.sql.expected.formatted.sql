SET query_plan_merge_filters = '1';

SET enable_analyzer = '1';

SELECT `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT
                            sum(number) AS v,
                            bitAnd(number, 15) AS key
                        FROM numbers(100000000.)
                        GROUP BY key
                        HAVING v != 0
                    )
                WHERE key = 7
            ))
    )
WHERE `explain` LIKE '%Filter%'
    OR `explain` LIKE '%Aggregating%';

SET enable_analyzer = '0';