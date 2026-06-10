DROP TABLE IF EXISTS collapsing;

CREATE TABLE collapsing
(
    key String,
    value String,
    sign Int8
)
ENGINE = CollapsingMergeTree(sign)
ORDER BY key
SETTINGS enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0';

INSERT INTO collapsing;

INSERT INTO collapsing;

INSERT INTO collapsing;

INSERT INTO collapsing;

OPTIMIZE TABLE collapsing PARTITION tuple() FINAL;

SELECT *
FROM collapsing
ORDER BY key ASC;

DROP TABLE collapsing;