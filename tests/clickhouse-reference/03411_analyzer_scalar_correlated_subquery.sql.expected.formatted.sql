SET enable_analyzer = '1';

SET allow_experimental_correlated_subqueries = '1';

EXPLAIN QUERY TREE
SELECT *
FROM numbers(2)
WHERE (
        SELECT count()
        FROM `system`.one
        WHERE number = 2
    ) IS NULL;

SELECT *
FROM numbers(2)
WHERE (
        SELECT count()
        FROM `system`.one
        WHERE number = 2
    ) IS NULL
ORDER BY `all` ASC;