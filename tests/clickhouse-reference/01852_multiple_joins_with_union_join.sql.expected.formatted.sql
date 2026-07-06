SET enable_analyzer = '1';

DROP TABLE IF EXISTS v1;

DROP TABLE IF EXISTS v2;

CREATE TABLE v1
(
    id Int32
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE v2
(
    value Int32
)
ENGINE = MergeTree()
ORDER BY value;

INSERT INTO v1 (id);

INSERT INTO v2 (value);

SELECT *
FROM
    v1 AS t1
INNER JOIN v1 AS t2
    USING (id)
INNER JOIN v2 AS n1
    ON t1.id = n1.value
INNER JOIN v2 AS n2
    ON t1.id = n2.value;

SELECT '---';

SELECT *
FROM
    v1 AS t1
INNER JOIN v1 AS t2
    USING (id)
CROSS JOIN v2 AS n1
CROSS JOIN v2 AS n2;

SELECT *
FROM
    v1 AS t1
INNER JOIN v1 AS t2
    USING (id)
INNER JOIN v1 AS t3
    USING (value); -- { serverError UNKNOWN_IDENTIFIER }