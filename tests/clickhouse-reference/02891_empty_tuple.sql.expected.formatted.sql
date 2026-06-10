DROP TABLE IF EXISTS x;

CREATE TABLE x
ENGINE = MergeTree()
ORDER BY () AS
SELECT
    () AS a,
    () AS b;

INSERT INTO x;

SELECT count()
FROM x;

SELECT *
FROM x
ORDER BY () ASC;

SELECT ();

SET allow_experimental_nullable_tuple_type = '0';

CREATE TABLE x
(
    i Nullable(Tuple())
)
ENGINE = MergeTree()
ORDER BY (); -- { serverError ILLEGAL_COLUMN }

SET allow_experimental_nullable_tuple_type = '1';

SET allow_experimental_nullable_tuple_type = DEFAULT;

DROP TABLE x;

CREATE TABLE x
(
    i LowCardinality(Tuple())
)
ENGINE = MergeTree()
ORDER BY (); -- { serverError 43 }

CREATE TABLE x
(
    i Tuple(),
    j Array(Tuple())
)
ENGINE = MergeTree()
ORDER BY ();

INSERT INTO x;

SELECT *
FROM x
ORDER BY () ASC
SETTINGS max_threads = '1';