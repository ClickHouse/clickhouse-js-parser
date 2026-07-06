SET any_join_distinct_right_table_keys = '1';

SET joined_subquery_requires_alias = '0';

SELECT
    k,
    x,
    y
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY FULL JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

SELECT
    k,
    x
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY FULL JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

SELECT
    k,
    y
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY FULL JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

SELECT
    x,
    y
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY FULL JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

SELECT k
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY FULL JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

SELECT
    k,
    x,
    y
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY RIGHT JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

SELECT
    k,
    x
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY RIGHT JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

SELECT
    k,
    y
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY RIGHT JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

SELECT
    x,
    y
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY RIGHT JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

SELECT k
FROM
    (
        SELECT
            arrayJoin([1, 2, 3]) AS k,
            'Hello' AS x
    )
ANY RIGHT JOIN (
        SELECT
            range(k) AS y,
            arrayJoin([3, 4, 5]) AS k
    )
    USING (k)
WHERE k < 10
ORDER BY k ASC;

DROP TABLE IF EXISTS t1_00203;

DROP TABLE IF EXISTS t2_00203;

CREATE TABLE t1_00203
(
    k1 UInt32,
    k2 UInt32,
    k3 UInt32,
    val_t1 String
)
ENGINE = TinyLog();

CREATE TABLE t2_00203
(
    val_t2 String,
    k3 UInt32,
    k2 UInt32,
    k1 UInt32
)
ENGINE = TinyLog();

INSERT INTO t1_00203;

INSERT INTO t2_00203;

SELECT
    k1,
    k2,
    k3,
    val_t1,
    val_t2
FROM
    t1_00203
ANY FULL JOIN t2_00203
    USING (k3, k1, k2)
ORDER BY
    k1 ASC,
    k2 ASC,
    k3 ASC;

SELECT
    k1,
    k2,
    k3,
    val_t1,
    val_t2
FROM
    t1_00203
ANY RIGHT JOIN t2_00203
    USING (k3, k1, k2)
ORDER BY
    k1 ASC,
    k2 ASC,
    k3 ASC;

SET any_join_distinct_right_table_keys = '0';

DROP TABLE t1_00203;

DROP TABLE t2_00203;