DROP TABLE IF EXISTS limit_by;

CREATE TABLE limit_by
(
    id Int,
    val Int
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO limit_by;

SELECT *
FROM limit_by
ORDER BY
    id ASC,
    val ASC
LIMIT 2, 2 BY id;

SELECT *
FROM limit_by
ORDER BY
    id ASC,
    val ASC
LIMIT 1, 2 BY id;

SELECT *
FROM limit_by
ORDER BY
    id ASC,
    val ASC
LIMIT 1, 2 BY id
LIMIT 3;

SELECT *
FROM limit_by
ORDER BY
    id ASC,
    val ASC
LIMIT 1, 2 BY id
LIMIT 3
OFFSET 1;

DROP TABLE limit_by;