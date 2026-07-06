SET enable_analyzer = '1';

SET group_by_use_nulls = '1';

SET optimize_group_by_function_keys = '1';

SET optimize_injective_functions_in_group_by = '1';

SELECT 3 + 3
FROM numbers(10)
GROUP BY GROUPING SETS (('str'), (3 + 3))
ORDER BY `all` ASC;

SELECT materialize(3)
FROM numbers(10)
GROUP BY GROUPING SETS (('str'), (materialize(3)))
ORDER BY `all` ASC;

SELECT ignore(3)
FROM numbers(10)
GROUP BY GROUPING SETS (('str'), (ignore(3)))
ORDER BY `all` ASC;

SELECT materialize(ignore(3))
FROM numbers(10)
GROUP BY GROUPING SETS (('str'), (materialize(ignore(3))))
ORDER BY `all` ASC;

SELECT ignore(materialize(3))
FROM numbers(10)
GROUP BY GROUPING SETS (('str'), (ignore(materialize(3))))
ORDER BY `all` ASC;