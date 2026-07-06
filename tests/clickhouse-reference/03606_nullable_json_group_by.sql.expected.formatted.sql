SELECT '{"a" : 42}'::Nullable(JSON)
GROUP BY 1;

SELECT materialize('{"a" : 42}')::Nullable(JSON)
GROUP BY 1;

SELECT NULL::Nullable(JSON)
GROUP BY 1;

SELECT materialize(NULL)::Nullable(JSON)
GROUP BY 1;

SELECT (number % 2 ? NULL : '{"a" : 42}')::Nullable(JSON) AS a
FROM numbers(4)
GROUP BY 1
ORDER BY a ASC;