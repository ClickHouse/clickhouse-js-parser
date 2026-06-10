SET enable_analyzer = '1';

CREATE TABLE table0
(
    id Int64,
    val String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE table1
(
    id2 Int64,
    val String
)
ENGINE = MergeTree()
ORDER BY id2;

CREATE TABLE table2
(
    id Int64,
    id2 Int64,
    val String
)
ENGINE = MergeTree()
ORDER BY (id, id2);

INSERT INTO table0;

INSERT INTO table1;

INSERT INTO table2;

-- { echoOn }
SELECT *
FROM
    table0
INNER JOIN table2
    USING (id)
INNER JOIN table1
    USING (id2)
ORDER BY `ALL` ASC;

SELECT *
FROM
    table0 AS t0
INNER JOIN table2
    USING (val)
INNER JOIN table1
    USING (val)
ORDER BY `ALL` ASC;

WITH t0 AS (
    SELECT *
    FROM table0
    WHERE val LIKE 'b%'
)

SELECT *
FROM
    t0
INNER JOIN table2 AS t2
    USING (id)
INNER JOIN table1 AS t1
    USING (id2)
ORDER BY `ALL` ASC;