SET analyzer_compatibility_join_using_top_level_identifier = '1';

DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

DROP TABLE IF EXISTS t3;

CREATE TABLE t1
(
    id String,
    val String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t2
(
    id String,
    code String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t3
(
    id String,
    code String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t1;

INSERT INTO t2;

INSERT INTO t3;

SET enable_analyzer = '1';

SELECT
    t1.id || '_1' AS id,
    t1.val
FROM
    t1
LEFT JOIN t2
    ON t1.id = t2.id
LEFT JOIN t3
    USING (id)
ORDER BY t1.val ASC;

SELECT
    t2.id || '_1' AS id,
    t1.val
FROM
    t1
LEFT JOIN t2
    ON t1.id = t2.id
LEFT JOIN t3
    USING (id)
ORDER BY t1.val ASC;

SELECT
    t2.id || '_1' AS id,
    t1.val
FROM
    t1
LEFT JOIN t2
    ON t1.id = t2.id
LEFT JOIN t3
    USING (id)
ORDER BY t1.val ASC
SETTINGS join_use_nulls = '1';

SELECT
    t2.id || '_1' AS id,
    t1.val
FROM
    t1
RIGHT JOIN t2
    ON t1.id = t2.id
RIGHT JOIN t3
    USING (id)
ORDER BY t1.val ASC
SETTINGS join_use_nulls = '1';

SELECT
    t2.id || '_1' AS id,
    t1.val
FROM
    t1
FULL JOIN t2
    ON t1.id = t2.id
FULL JOIN t3
    USING (id)
ORDER BY t1.val ASC
SETTINGS join_use_nulls = '1';

SELECT
    t1.id || t2.id || '_1' AS id,
    t1.val
FROM
    t1
INNER JOIN t2
    ON t1.id = t2.id
LEFT JOIN t3
    USING (id)
ORDER BY t1.val ASC; -- { serverError AMBIGUOUS_IDENTIFIER }