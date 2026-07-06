-- add_minmax_index_for_numeric_columns=0: Different plan
SET use_statistics = '0';

SELECT *
FROM (
        SELECT
            col1,
            col2
        FROM (
                SELECT
                    '1' AS col1,
                    '2' AS col2
            )
        GROUP BY
            col1,
            col2
    ) AS expr_qry
WHERE col2 != '';

SELECT *
FROM (
        SELECT
            materialize('1') AS s1,
            materialize('2') AS s2
        GROUP BY
            s1,
            s2
    )
WHERE s2 = '2';

SELECT *
FROM (
        SELECT
            materialize([1]) AS s1,
            materialize('2') AS s2
        GROUP BY
            s1,
            s2
    )
WHERE s2 = '2';

SELECT *
FROM (
        SELECT
            materialize([[1]]) AS s1,
            materialize('2') AS s2
        GROUP BY
            s1,
            s2
    )
WHERE s2 = '2';

DROP TABLE IF EXISTS Test;

CREATE TABLE Test
ENGINE = MergeTree()
PRIMARY KEY (String1, String2)
ORDER BY (String1, String2)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi', add_minmax_index_for_numeric_columns = '0' AS
SELECT
    'String1_' || toString(number) AS String1,
    'String2_' || toString(number) AS String2,
    'String3_' || toString(number) AS String3,
    'String4_' || toString(number % 4) AS String4
FROM numbers(1);

SELECT *
FROM (
        SELECT
            String1,
            String2,
            String3,
            String4,
            COUNT(*)
        FROM Test
        GROUP BY
            String1,
            String2,
            String3,
            String4
    ) AS expr_qry;

SELECT *
FROM (
        SELECT
            String1,
            String2,
            String3,
            String4,
            COUNT(*)
        FROM Test
        GROUP BY
            String1,
            String2,
            String3,
            String4
    ) AS expr_qry
WHERE String4 = 'String4_0';

SELECT
    x,
    y
FROM
    (
        SELECT
            [0, 1, 2] AS y,
            1 AS a,
            2 AS b
    )
ARRAY JOIN y AS x
WHERE a = 1
    AND b = 2
    AND (x = 1
    OR x != 1)
    AND x = 1;

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    a UInt8
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t SELECT *
FROM numbers(2);

SELECT a
FROM
    t AS t1
INNER JOIN t AS t2
    ON t1.a = t2.a
WHERE t1.a;

DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    id Int64,
    create_time DateTime
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi', add_minmax_index_for_numeric_columns = '0';

CREATE TABLE t2
(
    delete_time DateTime
)
ENGINE = MergeTree()
ORDER BY delete_time
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi', add_minmax_index_for_numeric_columns = '0';

INSERT INTO t1;

INSERT INTO t2;

EXPLAIN indexes = '1'
SELECT
    id,
    delete_time
FROM
    t1
CROSS JOIN (
        SELECT delete_time
        FROM t2
    ) AS d
WHERE create_time < delete_time
    AND id = 101
SETTINGS enable_analyzer = '0';

EXPLAIN indexes = '1'
SELECT
    id,
    delete_time
FROM
    t1
CROSS JOIN (
        SELECT delete_time
        FROM t2
    ) AS d
WHERE create_time < delete_time
    AND id = 101
SETTINGS enable_analyzer = '1';

-- expected to get row (1, 3, 1, 4) from JOIN and empty result from the query
SELECT *
FROM
    (
        SELECT *
        FROM Values('id UInt64, t UInt64', (1, 3))
    ) AS t1
ASOF INNER JOIN (
        SELECT *
        FROM Values('id UInt64, t UInt64', (1, 1), (1, 2), (1, 3), (1, 4), (1, 5))
    ) AS t2
    ON t1.id = t2.id
    AND t1.t < t2.t
WHERE t2.t != 4;