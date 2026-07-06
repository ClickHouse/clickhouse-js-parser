DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    col1 String,
    col2 String,
    INDEX test_table_col2_idx col2 TYPE set(0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY col1 AS
SELECT
    'v1',
    'v2';

SELECT *
FROM tab
WHERE 1 = 1
    AND col1 = col1
    OR 0
    AND col2 = NULL;

DROP TABLE tab;

SET secondary_indices_enable_bulk_filtering = '1';

CREATE TABLE tab
(
    col Nullable(Boolean),
    INDEX col_idx col TYPE set(0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab;

SELECT count()
FROM tab
WHERE col
    OR col IS NULL;

INSERT INTO tab;

INSERT INTO tab;

SET secondary_indices_enable_bulk_filtering = '0';