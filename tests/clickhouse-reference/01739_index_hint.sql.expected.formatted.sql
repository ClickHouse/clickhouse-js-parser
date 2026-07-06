-- add_minmax_index_for_numeric_columns=0: Disable minmax index to not interfere with the indexHint tests. With it it would filter out more rows (correctly)
-- { echo }
DROP TABLE IF EXISTS tbl;

CREATE TABLE tbl
(
    p Int64,
    t Int64,
    f Float64
)
ENGINE = MergeTree()
ORDER BY t
PARTITION BY p
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';

INSERT INTO tbl SELECT
    number / 4,
    number,
    0
FROM numbers(16);

SELECT *
FROM tbl
WHERE indexHint(t = 1)
ORDER BY t ASC;

SELECT *
FROM tbl
WHERE indexHint(t IN (
        SELECT toInt64(number) + 2
        FROM numbers(3)
    ))
ORDER BY t ASC;

SELECT *
FROM tbl
WHERE indexHint(p = 2)
ORDER BY t ASC;

SELECT *
FROM tbl
WHERE indexHint(p IN (
        SELECT toInt64(number) - 2
        FROM numbers(3)
    ))
ORDER BY t ASC;

DROP TABLE tbl;

DROP TABLE IF EXISTS XXXX;

CREATE TABLE XXXX
(
    t Int64,
    f Float64
)
ENGINE = MergeTree()
ORDER BY t
SETTINGS index_granularity = '128', index_granularity_bytes = '10Mi';

INSERT INTO XXXX SELECT
    number * 60,
    0
FROM numbers(100000);

SELECT sum(t)
FROM XXXX
WHERE indexHint(t = 42);

CREATE TABLE XXXX
(
    t Int64,
    f Float64
)
ENGINE = MergeTree()
ORDER BY t
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SELECT count()
FROM XXXX
WHERE indexHint(t = toDateTime(0))
SETTINGS optimize_use_implicit_projections = '1';

DROP TABLE XXXX;

CREATE TABLE XXXX
(
    p Nullable(Int64),
    k Decimal(76, 39)
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toDate(p)
SETTINGS index_granularity = '1', allow_nullable_key = '1';

INSERT INTO XXXX;

SELECT count()
FROM XXXX
WHERE indexHint(p = 1.)
SETTINGS
    optimize_use_implicit_projections = '1',
    enable_analyzer = '0';

-- TODO: optimize_use_implicit_projections ignores indexHint (with analyzer) because source columns might be aliased.
SELECT count()
FROM XXXX
WHERE indexHint(p = 1.)
SETTINGS
    optimize_use_implicit_projections = '1',
    enable_analyzer = '1';