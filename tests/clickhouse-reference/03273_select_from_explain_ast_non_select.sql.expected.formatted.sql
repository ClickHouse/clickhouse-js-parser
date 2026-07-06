SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN AST', '', (
                SELECT *
                FROM numbers(10)
            ))
    );