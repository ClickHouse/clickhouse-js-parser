WITH 2 AS `b.c`,

[4, 5] AS a,

6 AS u,

3 AS v,

2 AS d,

true AS e,

1 AS f,

0 AS g,

2 AS h,

'Hello' AS i,

'World' AS j,

'hi' AS w,

NULL AS k,

(1, 2) AS l,

2 AS m,

3 AS n,

[] AS o,

[1] AS p,

1 AS q,

q AS r,

1 AS s,

1 AS t

SELECT toIntervalMinute(caseWithExpression(multiIf(NOT -a[`b.c`] * u DIV v + d IS NOT NULL
    AND e
    OR f >= g
    AND f <= h, i, j), w, k, NULL) || [l, (m, n)]) IS NULL
    OR NOT o::Array(INT) = p != q < r > s != t AS upyachka;