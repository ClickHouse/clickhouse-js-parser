SET allow_experimental_nullable_tuple_type = '1';

DROP TABLE IF EXISTS tuple_test;

CREATE TABLE tuple_test
(
    id UInt64,
    tup Nullable(Tuple(u UInt64, s String)),
    n Nullable(UInt64)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tuple_test (id, tup, n);

SELECT
    id,
    tup,
    n,
    isNull(tup),
    isNull(n)
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tup.u,
    tup.s,
    toTypeName(tup.u),
    toTypeName(tup.s)
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tupleElement(tup, 'u') AS u,
    tupleElement(tup, 's') AS s
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tupleElement(tup, 1) AS `first`,
    tupleElement(tup, 2) AS second
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tup
FROM tuple_test
WHERE tup IS NULL
ORDER BY id ASC;

SELECT
    id,
    tup
FROM tuple_test
WHERE tup IS NOT NULL
ORDER BY id ASC;

SELECT
    id,
    tup.u
FROM tuple_test
WHERE tup.u > 20
ORDER BY id ASC;

SELECT
    id,
    tup
FROM tuple_test
WHERE tup.u IS NULL
ORDER BY id ASC;

SELECT
    id,
    tup
FROM tuple_test
WHERE tup.u IS NOT NULL
ORDER BY id ASC;

SELECT
    id,
    tup.s
FROM tuple_test
WHERE tup.s = 'alpha'
ORDER BY id ASC;

SELECT
    id,
    tup
FROM tuple_test
WHERE tup IS NOT NULL
    AND tup.u > 20
    AND tup.s LIKE '%a%'
ORDER BY id ASC;

SELECT
    id,
    tup,
    n
FROM tuple_test
WHERE tup IS NOT NULL
    OR n IS NOT NULL
ORDER BY id ASC;

SELECT
    id,
    tup
FROM tuple_test
ORDER BY
    tup ASC,
    id ASC;

SELECT
    id,
    tup
FROM tuple_test
ORDER BY
    tup DESC,
    id ASC;

SELECT
    id,
    tup
FROM tuple_test
ORDER BY
    tup ASC NULLS FIRST,
    id ASC;

SELECT
    id,
    tup
FROM tuple_test
ORDER BY
    tup ASC NULLS LAST,
    id ASC;

SELECT
    id,
    tup.u
FROM tuple_test
ORDER BY
    tup.u ASC,
    id ASC;

SELECT
    id,
    tup.u
FROM tuple_test
ORDER BY
    tup.u DESC,
    id ASC;

SELECT
    id,
    tup.u
FROM tuple_test
ORDER BY
    tup.u ASC NULLS FIRST,
    id ASC;

SELECT
    id,
    tup.u
FROM tuple_test
ORDER BY
    tup.u ASC NULLS LAST,
    id ASC;

SELECT
    id,
    tup.s
FROM tuple_test
ORDER BY
    tup.s ASC NULLS LAST,
    id ASC;

SELECT
    id,
    tup.u,
    tup.s
FROM tuple_test
ORDER BY
    tup.u ASC NULLS LAST,
    tup.s ASC,
    id ASC;

SELECT
    id,
    tup,
    n
FROM tuple_test
ORDER BY
    n ASC NULLS LAST,
    tup.u ASC;

SELECT
    tup,
    count() AS cnt
FROM tuple_test
GROUP BY tup
ORDER BY tup ASC NULLS LAST;

SELECT
    tup.u,
    count() AS cnt,
    sum(n) AS sum_n
FROM tuple_test
GROUP BY tup.u
ORDER BY tup.u ASC NULLS LAST;

SELECT
    tup.s,
    count() AS cnt
FROM tuple_test
GROUP BY tup.s
ORDER BY tup.s ASC NULLS LAST;

SELECT
    tup.u,
    tup.s,
    count() AS cnt
FROM tuple_test
GROUP BY
    tup.u,
    tup.s
ORDER BY
    tup.u ASC NULLS LAST,
    tup.s ASC;

SELECT
    isNull(tup) AS is_null,
    count() AS cnt
FROM tuple_test
GROUP BY isNull(tup)
ORDER BY is_null ASC;

SELECT
    coalesce(tup.u, 0) AS u_value,
    count() AS cnt
FROM tuple_test
GROUP BY coalesce(tup.u, 0)
ORDER BY u_value ASC;

SELECT
    tup.u,
    count() AS cnt
FROM tuple_test
GROUP BY tup.u
HAVING cnt > 1
ORDER BY tup.u ASC NULLS LAST;

SELECT
    tup.u,
    sum(n) AS sum_n
FROM tuple_test
GROUP BY tup.u
HAVING sum_n > 400
ORDER BY tup.u ASC NULLS LAST;

SELECT
    tup.u,
    count() AS cnt
FROM tuple_test
GROUP BY tup.u
HAVING tup.u > 10
ORDER BY tup.u ASC;

SELECT
    count() AS total,
    count(tup) AS non_null_tuples,
    count(tup.u) AS non_null_u
FROM tuple_test;

SELECT
    min(tup.u) AS min_u,
    max(tup.u) AS max_u,
    min(tup.s) AS min_s,
    max(tup.s) AS max_s
FROM tuple_test;

SELECT
    sum(tup.u) AS sum_u,
    avg(tup.u) AS avg_u
FROM tuple_test;

SELECT
    groupArray(tup) AS all_tuples,
    groupArray(tup.u) AS all_u_values
FROM tuple_test;

SELECT
    uniq(tup) AS unique_tuples,
    uniqExact(tup.u) AS unique_u_values
FROM tuple_test;

SELECT
    any(tup) AS any_tuple,
    anyLast(tup.u) AS anylast_u
FROM tuple_test;

SELECT
    countIf(tup IS NULL) AS null_count,
    countIf(tup.u > 20) AS u_gt_20_count
FROM tuple_test;

SELECT
    t1.id AS id1,
    t2.id AS id2,
    t1.tup AS tup1
FROM
    tuple_test AS t1
INNER JOIN tuple_test AS t2
    ON t1.tup = t2.tup
WHERE t1.id < t2.id
ORDER BY
    id1 ASC,
    id2 ASC;

SELECT
    t1.id AS id1,
    t2.id AS id2,
    t1.tup.u AS u_value
FROM
    tuple_test AS t1
INNER JOIN tuple_test AS t2
    ON t1.tup.u = t2.tup.u
WHERE t1.id < t2.id
ORDER BY
    id1 ASC,
    id2 ASC
SETTINGS enable_analyzer = '1'; -- t1.tup.u notation is not recognized in old analyzer

SELECT
    t1.id,
    t1.tup AS tup1,
    t2.tup AS tup2
FROM
    tuple_test AS t1
LEFT JOIN tuple_test AS t2
    ON t1.tup.u = t2.tup.u
    AND t1.id != t2.id
ORDER BY
    t1.id ASC,
    t2.id ASC NULLS LAST
SETTINGS enable_analyzer = '1'; -- t1.tup.u notation is not recognized in old analyzer

SELECT
    t1.id AS id1,
    t2.id AS id2
FROM
    tuple_test AS t1
INNER JOIN tuple_test AS t2
    ON t1.tup = t2.tup
WHERE t1.tup IS NOT NULL
ORDER BY
    id1 ASC,
    id2 ASC;

SELECT DISTINCT tup
FROM tuple_test
ORDER BY tup ASC NULLS LAST;

SELECT DISTINCT tup.u
FROM tuple_test
ORDER BY tup.u ASC NULLS LAST;

SELECT DISTINCT
    tup.u,
    tup.s
FROM tuple_test
ORDER BY
    tup.u ASC NULLS LAST,
    tup.s ASC;

SELECT tup
FROM (
        SELECT tup
        FROM tuple_test
        WHERE id <= 3
        UNION ALL
        SELECT tup
        FROM tuple_test
        WHERE id >= 3
    )
ORDER BY tup ASC NULLS LAST;

SELECT value
FROM (
        SELECT tup.u AS value
        FROM tuple_test
        UNION DISTINCT
        SELECT n AS value
        FROM tuple_test
    )
ORDER BY value ASC NULLS LAST;

SELECT tup.u
FROM tuple_test
WHERE tup.u IS NOT NULL
INTERSECT
SELECT n
FROM tuple_test
WHERE n IS NOT NULL
ORDER BY tup.u ASC;

SELECT tup.u
FROM tuple_test
WHERE tup.u IS NOT NULL
EXCEPT
SELECT n
FROM tuple_test
WHERE n IS NOT NULL
ORDER BY tup.u ASC;

SELECT
    id,
    tup
FROM tuple_test
WHERE tup.u IN (
        SELECT tup.u
        FROM tuple_test
        WHERE tup.s LIKE '%a%'
    )
ORDER BY id ASC;

SELECT
    id,
    tup
FROM tuple_test AS t1
WHERE exists((
        SELECT 1
        FROM tuple_test AS t2
        WHERE t1.tup.u = t2.tup.u
            AND t1.id != t2.id
    ))
ORDER BY id ASC
SETTINGS enable_analyzer = '1'; -- t1.tup.u notation is not recognized in old analyzer

SELECT
    id,
    tup.u,
    (
        SELECT max(tup.u)
        FROM tuple_test
    ) AS max_u
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tup.u,
    (
        SELECT count()
        FROM tuple_test AS t2
        WHERE t2.tup.u = t1.tup.u
    ) AS count_same_u
FROM tuple_test AS t1
ORDER BY id ASC
SETTINGS enable_analyzer = '1'; -- t1.tup.u notation is not recognized in old analyzer

SELECT
    id,
    multiIf(tup IS NULL, 'null tuple', tup.u > 30, 'high', 'low') AS category
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tup.u,
    caseWithExpression(tup.u, 11, 'eleven', 33, 'thirty-three', 44, 'forty-four', 'other') AS u_label
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    if(tup IS NULL, 'NULL', concat('u=', toString(tup.u))) AS result
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    multiIf(tup IS NULL, 'null', tup.u < 20, 'small', tup.u < 40, 'medium', 'large') AS size_category
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tup.u,
    row_number() OVER (ORDER BY tup.u ASC, id ASC NULLS LAST) AS rn
FROM tuple_test
ORDER BY
    rn ASC,
    id ASC;

SELECT
    id,
    tup.u,
    rank() OVER (ORDER BY tup.u ASC NULLS LAST) AS rnk,
    dense_rank() OVER (ORDER BY tup.u ASC NULLS LAST) AS dense_rnk
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tup.u,
    isNull(tup),
    row_number() OVER (PARTITION BY isNull(tup) ORDER BY tup.u ASC, id ASC NULLS LAST) AS rn_in_partition
FROM tuple_test
ORDER BY
    isNull(tup) ASC,
    rn_in_partition ASC,
    id ASC;

SELECT
    id,
    tup.u,
    sum(tup.u) OVER (ORDER BY id ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumsum,
    avg(tup.u) OVER (ORDER BY id ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg
FROM tuple_test
ORDER BY id ASC;

SELECT
    t1.id AS id1,
    t2.id AS id2,
    t1.tup = t2.tup AS is_equal,
    t1.tup != t2.tup AS is_not_equal
FROM
    tuple_test AS t1,
    tuple_test AS t2
WHERE t1.id = 1
    AND t2.id IN (1, 2, 3)
ORDER BY
    id1 ASC,
    id2 ASC;

SELECT
    id,
    tup.u = 11 AS u_is_11,
    tup.s = 'alpha' AS s_is_alpha
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tup.u > 20 AS u_gt_20,
    tup.u < 50 AS u_lt_50,
    tup.u >= 10
    AND tup.u <= 40 AS u_between
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    tup.s LIKE '%a%' AS has_a,
    tup.s IN ('alpha', 'beta') AS is_alpha_or_beta
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    toString(tup) AS tup_str,
    toString(tup.u) AS u_str
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    CAST(tup.u AS Float64) AS u_float,
    CAST(tup.s AS FixedString(10)) AS s_fixed
FROM tuple_test
WHERE tup IS NOT NULL
ORDER BY id ASC;

SELECT
    id,
    coalesce(tup.u, 999) AS u_with_default,
    coalesce(tup.s, 'N/A') AS s_with_default
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    ifNull(tup.u, 0) AS u_or_zero,
    ifNull(tup.s, 'empty') AS s_or_empty
FROM tuple_test
ORDER BY id ASC;

SELECT
    id,
    assumeNotNull(tup.u) AS u_not_null,
    toTypeName(assumeNotNull(tup.u)) AS type
FROM tuple_test
WHERE tup IS NOT NULL
ORDER BY id ASC;

SELECT
    id,
    isNull(tup) AS tup_is_null,
    isNotNull(tup) AS tup_is_not_null,
    isNull(tup.u) AS u_is_null
FROM tuple_test
ORDER BY id ASC;

WITH filtered AS (
    SELECT
        id,
        tup
    FROM tuple_test
    WHERE tup IS NOT NULL
)

SELECT
    id,
    tup.u,
    tup.s
FROM filtered
ORDER BY id ASC
SETTINGS enable_analyzer = '1'; -- CTE tup.u notation is not recognized in old analyzer

WITH stats AS (
    SELECT
        avg(tup.u) AS avg_u,
        max(tup.u) AS max_u
    FROM tuple_test
)

SELECT
    id,
    tup.u,
    tup.u - (
        SELECT avg_u
        FROM stats
    ) AS diff_from_avg
FROM tuple_test
WHERE tup IS NOT NULL
ORDER BY id ASC;

SELECT groupArray(tup) AS tuple_array
FROM tuple_test;

SELECT
    groupArray(tup) AS tuple_array,
    tuple_array[1] AS first_tuple,
    tuple_array[1].u AS first_u
FROM tuple_test;

SELECT arrayFilter((x -> isNotNull(x)), groupArray(tup)) AS non_null_tuples
FROM tuple_test;

SELECT arrayMap((x -> x.u), arrayFilter((x -> isNotNull(x)), groupArray(tup))) AS all_u_values
FROM tuple_test
SETTINGS enable_analyzer = '1'; -- Lambda tup.u notation is not recognized in old analyzer

SELECT
    tup.u AS u_value,
    count() AS cnt,
    sum(n) AS total_n,
    avg(n) AS avg_n,
    groupArray(id) AS ids
FROM tuple_test
WHERE tup IS NOT NULL
GROUP BY tup.u
HAVING cnt > 0
    AND avg_n > 200
ORDER BY u_value ASC;

SELECT
    category,
    count() AS cnt,
    avg(tup.u) AS avg_u
FROM (
        SELECT
            id,
            tup,
            multiIf(tup.u < 30, 'low', 'high') AS category
        FROM tuple_test
        WHERE tup IS NOT NULL
    )
GROUP BY category
ORDER BY category ASC
SETTINGS enable_analyzer = '1'; -- Here, tup.u notation is not recognized in old analyzer

DROP TABLE IF EXISTS test_nullable_tuple;

CREATE TABLE test_nullable_tuple
(
    data Nullable(Tuple(String, UInt64))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_nullable_tuple;

SELECT
    tupleElement(data, 1),
    tupleElement(data, 1),
    tupleElement(data, 2)
FROM test_nullable_tuple;