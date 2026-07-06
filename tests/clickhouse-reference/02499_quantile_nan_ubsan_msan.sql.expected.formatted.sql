SELECT quantiles(0.5)(now()::DateTime('UTC'))
WHERE 0;

SELECT quantiles(0.5)(now()::DateTime('UTC'))
WHERE 0
WITH TOTALS;

SELECT arrayReduce('quantiles(0.5)', CAST('[]' AS Array(DateTime('UTC'))));

SELECT quantiles(0.5, 1.1754943508222875e-38, 0.0001, -0., 0.0001, -0., 0.0001, 0., 0.5)(now()::DateTime('UTC'))
WHERE 0
WITH TOTALS;

SELECT DISTINCT arrayReduce('quantiles(0.5)', materialize(CAST('[]' AS Array(DateTime('UTC')))))
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantiles(0, 0.5, 0.9, 1)', materialize(CAST('[]' AS Array(DateTime('UTC')))))
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantiles(0.5)', [18446744073709551615, 18446744073709551614])
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantilesDeterministic(0.5)', materialize(CAST('[]' AS Array(DateTime('UTC')))), CAST('[]' AS Array(UInt64)))
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantilesDeterministic(0, 0.5, 0.9, 1)', materialize(CAST('[]' AS Array(DateTime('UTC')))), CAST('[]' AS Array(UInt64)))
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantiles(0.5)', [CAST(-1 AS UInt256), CAST(-2 AS UInt256)])
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantiles(0.5)', CAST('[]' AS Array(Float64)))
FROM numbers(1000)
LIMIT 10;

SELECT quantile(0.5)(now()::DateTime('UTC'))
WHERE 0;

SELECT quantile(0.5)(now()::DateTime('UTC'))
WHERE 0
WITH TOTALS;

SELECT arrayReduce('quantile(0.5)', CAST('[]' AS Array(DateTime('UTC'))));

SELECT DISTINCT arrayReduce('quantile(0.5)', materialize(CAST('[]' AS Array(DateTime('UTC')))))
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantile(0.5)', [18446744073709551615, 18446744073709551614])
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantileDeterministic(0.5)', materialize(CAST('[]' AS Array(DateTime('UTC')))), CAST('[]' AS Array(UInt64)))
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantile(0.5)', [CAST(-1 AS UInt256), CAST(-2 AS UInt256)])
FROM numbers(1000)
LIMIT 10;

SELECT DISTINCT arrayReduce('quantile(0.5)', CAST('[]' AS Array(Float64)))
FROM numbers(1000)
LIMIT 10;