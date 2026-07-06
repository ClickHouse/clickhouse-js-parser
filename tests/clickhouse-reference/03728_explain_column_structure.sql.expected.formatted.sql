SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'header = 1, input_headers = 1', (
                SELECT 1
            ))
    )
WHERE `explain` NOT LIKE 'Expression%';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'header = 1, input_headers = 1, column_structure = 1', (
                SELECT 1
            ))
    )
WHERE `explain` NOT LIKE 'Expression%';