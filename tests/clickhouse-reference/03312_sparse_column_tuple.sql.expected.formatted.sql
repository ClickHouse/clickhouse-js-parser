DROP TABLE IF EXISTS dst_sparse;

DROP TABLE IF EXISTS mytable_sparse;

CREATE TABLE dst_sparse
(
    id Int64,
    budget Tuple(currencyCode String)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS ratio_of_defaults_for_sparse_serialization = 0.9, serialization_info_version = 'basic' AS
SELECT
    number,
    arrayJoin([tuple('')])
FROM numbers(999);

INSERT INTO dst_sparse;

OPTIMIZE TABLE dst_sparse FINAL;

CREATE TABLE mytable_sparse
ENGINE = MergeTree()
ORDER BY id
SETTINGS ratio_of_defaults_for_sparse_serialization = 1., serialization_info_version = 'basic' AS
SELECT
    id,
    budget
FROM dst_sparse;

SELECT count()
FROM mytable_sparse;

SELECT DISTINCT
    table,
    column,
    serialization_kind,
    subcolumns.names,
    subcolumns.serializations
FROM `system`.parts_columns
WHERE database = currentDatabase()
    AND table IN ('dst_sparse', 'mytable_sparse')
    AND active
    AND column = 'budget'
ORDER BY table ASC;

CREATE TABLE mytable_sparse
ENGINE = MergeTree()
ORDER BY id
SETTINGS ratio_of_defaults_for_sparse_serialization = 0.9, serialization_info_version = 'basic' AS
SELECT
    id,
    budget
FROM dst_sparse;