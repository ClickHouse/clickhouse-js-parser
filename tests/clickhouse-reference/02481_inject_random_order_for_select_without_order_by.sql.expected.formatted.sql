-- A test for setting `inject_random_order_for_select_without_order_by`
-- The setting is disabled by default, enable it for the test.
SET inject_random_order_for_select_without_order_by = '1';

-- Works only with enabled analyzer
SET enable_analyzer = '1';

SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT number
                FROM numbers(5)
            ))
    )
WHERE `explain` LIKE '%Sorting%';

SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT number
                FROM numbers(5)
                ORDER BY number ASC
            ))
    )
WHERE `explain` LIKE '%Sorting%';

SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT number
                FROM numbers(5)
                UNION ALL
                SELECT number
                FROM numbers(5)
            ))
    )
WHERE `explain` LIKE '%Sorting%';

-- Now disable the setting
SET inject_random_order_for_select_without_order_by = '0';