SET enable_named_columns_in_function_tuple = '1';

SET enable_analyzer = '1';

DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO x;

SELECT toTypeName(tuple(i, j))
FROM x;

SELECT tupleNames(tuple(i, j))
FROM x;

SELECT toTypeName(tuple(1, j))
FROM x;

SELECT tupleNames(tuple(1, j))
FROM x;

SELECT toTypeName(tuple(1 AS k, j))
FROM x;

SELECT tupleNames(tuple(1 AS k, j))
FROM x;

SELECT toTypeName(tuple(i, i, j, j))
FROM x;

SELECT tupleNames(tuple(i, i, j, j))
FROM x;

SELECT tupleNames(1); -- { serverError 43 }

DROP TABLE x;

DROP TABLE IF EXISTS tbl;

-- Make sure named tuple won't break Values insert
CREATE TABLE tbl
(
    x Tuple(a Int32, b Int32, c Int32)
)
ENGINE = MergeTree()
ORDER BY ();

INSERT INTO tbl; -- without tuple it's interpreted differently inside values block.

SELECT *
FROM tbl;

DROP TABLE tbl;

-- Avoid generating named tuple for special keywords
SELECT
    toTypeName(tuple(NULL)),
    toTypeName(tuple(true)),
    toTypeName(tuple(false));