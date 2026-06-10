-- Tags: no-parallel-replicas
-- It generates plan with _reading_ from storage join, but reading from storage join with complex keys is currently not supported.
SET enable_parallel_replicas = '0';

DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS tj;

DROP TABLE IF EXISTS tjj;

CREATE TABLE t1
(
    key1 UInt64,
    key2 UInt64,
    key3 UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t1;

CREATE TABLE tj
(
    key2 UInt64,
    key1 UInt64,
    key3 UInt64,
    attr UInt64
)
ENGINE = Join(`ALL`, `INNER`, key3, key2, key1);

INSERT INTO tj;

CREATE TABLE tjj
(
    key2 UInt64,
    key1 UInt64,
    key3 UInt64,
    attr UInt64
)
ENGINE = Join(`ALL`, `INNER`, key3, key2, key1);

INSERT INTO tjj;

SELECT '--- using ---';

SELECT *
FROM
    t1
ALL INNER JOIN tj
    USING (key1, key2, key3)
ORDER BY key1 ASC;

SELECT
    key1,
    key2,
    key3,
    attr
FROM
    t1
ALL INNER JOIN tj
    USING (key1, key2, key3)
ORDER BY key1 ASC;

SELECT
    key1,
    key2,
    key3,
    attr
FROM
    t1
ALL INNER JOIN tj
    USING (key2, key3, key1)
ORDER BY key1 ASC;

SELECT
    key1,
    key2,
    key3,
    attr
FROM
    t1
ALL INNER JOIN tj
    USING (key3, key2, key1)
ORDER BY key1 ASC;

SELECT
    key1,
    key2,
    key3,
    attr
FROM
    t1
ALL INNER JOIN tj
    USING (key1, key3, key2)
ORDER BY key1 ASC;

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key3 = tj.key3
    AND t1.key2 = tj.key2
    AND t1.key1 = tj.key1
ORDER BY t1.key1 ASC;

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key2 = tj.key2
    AND t1.key3 = tj.key3
    AND t1.key1 = tj.key1
ORDER BY t1.key1 ASC;

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key3 = tj.key3
    AND t1.key1 = tj.key1
    AND t1.key2 = tj.key2
ORDER BY t1.key1 ASC;

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key1 = tj.key1
    AND t1.key3 = tj.key3
    AND t1.key2 = tj.key2
ORDER BY t1.key1 ASC;

SELECT *
FROM
    (
        SELECT
            key3 AS c,
            key1 AS a,
            key2 AS b
        FROM t1
    ) AS t1
ALL INNER JOIN tj
    ON t1.a = tj.key1
    AND t1.c = tj.key3
    AND t1.b = tj.key2
ORDER BY t1.a ASC;

SELECT *
FROM
    (
        SELECT
            key3 AS c,
            key1 AS a,
            key2 AS b
        FROM t1
    ) AS t1
ALL INNER JOIN tj
    ON t1.a = tj.key1
    AND t1.b = tj.key2
    AND t1.c = tj.key3
ORDER BY t1.a ASC;

SELECT *
FROM
    (
        SELECT
            key3 AS c,
            key1 AS a,
            key2 AS b
        FROM t1
    ) AS t1
ALL INNER JOIN tj
    ON t1.c = tj.key3
    AND t1.a = tj.key1
    AND t1.b = tj.key2
ORDER BY t1.a ASC;

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key1 = tj.key1
    AND t1.key3 = tj.key3
    AND t1.key2 = tj.key2
    AND 0; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,INVALID_JOIN_ON_EXPRESSION }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key1 = tj.key1
    AND t1.key3 = tj.key3
    AND t1.key2 = tj.key2
    AND 1 > 1; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,INVALID_JOIN_ON_EXPRESSION }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON 1; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,INVALID_JOIN_ON_EXPRESSION }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON 0; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,INVALID_JOIN_ON_EXPRESSION }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON NULL; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,INVALID_JOIN_ON_EXPRESSION }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON 1 != 1; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,INVALID_JOIN_ON_EXPRESSION }

-- Here is another error code because equality is handled differently in CollectJoinOnKeysVisitor.
-- We can change the error code, but it will become inconsistent for other cases
-- where we actually expect AMBIGUOUS_COLUMN_NAME instead of INVALID_JOIN_ON_EXPRESSION/INCOMPATIBLE_TYPE_OF_JOIN.
-- These checks are more reliable after switching to a new analyzer, they return INCOMPATIBLE_TYPE_OF_JOIN consistent with cases above
SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON 1 = 1; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,AMBIGUOUS_COLUMN_NAME }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON 1 = 2; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,AMBIGUOUS_COLUMN_NAME }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    USING (key1, key2, attr); -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,UNKNOWN_IDENTIFIER }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    USING (key1, key2, key3, attr); -- { serverError INCOMPATIBLE_TYPE_OF_JOIN,UNKNOWN_IDENTIFIER }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    USING (key2, key3); -- { serverError INCOMPATIBLE_TYPE_OF_JOIN }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key1 = tj.attr; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key1 = tj.key1; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key1 = tj.key1
    AND t1.key2 = tj.key2
    AND t1.key3 = tj.attr; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN }

SELECT *
FROM
    t1
ALL INNER JOIN tj
    ON t1.key1 = tj.key1
    AND t1.key2 = tj.key2
    AND t1.key3 = tj.key3
    AND t1.key1 = tj.key1; -- { serverError INCOMPATIBLE_TYPE_OF_JOIN }

SELECT *
FROM
    t1
ALL INNER JOIN tjj
    ON t1.key1 = tjj.key1
    AND t1.key1 = tjj.key2
    AND t1.key1 = tjj.key3
ORDER BY t1.key1 ASC;

SELECT *
FROM
    t1
ALL INNER JOIN tjj
    ON t1.key1 = tjj.key1
    AND t1.key1 = tjj.key3
    AND t1.key1 = tjj.key2
ORDER BY t1.key1 ASC;