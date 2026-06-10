-- Tags: no-random-merge-tree-settings
SET allow_deprecated_syntax_for_merge_tree = '1';

SET optimize_on_insert = '0';

SET optimize_trivial_insert_select = '1';

DROP TABLE IF EXISTS mult_tab;

CREATE TABLE mult_tab
(
    date Date,
    value String,
    version UInt64,
    sign Int8
)
ENGINE = VersionedCollapsingMergeTree(date, date, 8192, sign, version);

INSERT INTO mult_tab SELECT
    '2018-01-31',
    'str_' || toString(number),
    0,
    if(number % 2, 1, -1)
FROM `system`.numbers
LIMIT 10;

SELECT *
FROM mult_tab FINAL
ORDER BY
    date ASC,
    value ASC,
    sign ASC;

OPTIMIZE TABLE mult_tab FINAL;

SELECT *
FROM mult_tab;

SELECT '-------------------------';

CREATE TABLE mult_tab
(
    date Date,
    value String,
    version UInt64,
    sign Int8
)
ENGINE = VersionedCollapsingMergeTree(date, (date, value), 8192, sign, version);

INSERT INTO mult_tab SELECT
    '2018-01-31',
    'str_' || toString(number),
    0,
    if(number % 2, -1, 1)
FROM `system`.numbers
LIMIT 10;

INSERT INTO mult_tab SELECT
    '2018-01-31',
    'str_' || toString(number),
    1,
    if(number % 2, -1, 1)
FROM `system`.numbers
LIMIT 10;

SELECT *
FROM mult_tab FINAL
ORDER BY
    date ASC,
    value ASC,
    version ASC,
    sign ASC;

INSERT INTO mult_tab SELECT
    '2018-01-31',
    'str_' || toString(number),
    1,
    if(number % 3 = 0, 1, -1)
FROM `system`.numbers
LIMIT 10;

INSERT INTO mult_tab SELECT
    '2018-01-31',
    'str_' || toString(number),
    1,
    if(number % 3 = 1, 1, -1)
FROM `system`.numbers
LIMIT 10;

INSERT INTO mult_tab SELECT
    '2018-01-31',
    'str_' || toString(number),
    1,
    if(number % 3 = 2, 1, -1)
FROM `system`.numbers
LIMIT 10;

INSERT INTO mult_tab SELECT
    '2018-01-31',
    'str_' || toString(number),
    0,
    if(number % 2, 1, -1)
FROM `system`.numbers
LIMIT 1000000;

INSERT INTO mult_tab SELECT
    '2018-01-31',
    'str_' || toString(number),
    0,
    if(number % 2, -1, 1)
FROM `system`.numbers
LIMIT 1000000;

CREATE TABLE mult_tab
(
    date Date,
    value UInt64,
    key UInt64,
    version UInt64,
    sign Int8
)
ENGINE = VersionedCollapsingMergeTree(date, date, 8192, sign, version);

INSERT INTO mult_tab SELECT
    '2018-01-31',
    number,
    number,
    0,
    if(number < 64, 1, -1)
FROM `system`.numbers
LIMIT 128;

INSERT INTO mult_tab SELECT
    '2018-01-31',
    number,
    number + 128,
    0,
    if(number < 64, -1, 1)
FROM `system`.numbers
LIMIT 128;

SELECT
    date,
    value,
    version,
    sign
FROM mult_tab FINAL
ORDER BY
    date ASC,
    key ASC,
    sign ASC
SETTINGS max_block_size = '33';

SELECT
    date,
    value,
    version,
    sign
FROM mult_tab;

CREATE TABLE mult_tab
(
    date Date,
    value String,
    version UInt64,
    sign Int8
)
ENGINE = VersionedCollapsingMergeTree(sign, version)
ORDER BY date
SETTINGS enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '1', vertical_merge_algorithm_min_columns_to_activate = '0';

CREATE TABLE mult_tab
(
    date Date,
    value String,
    version UInt64,
    sign Int8
)
ENGINE = VersionedCollapsingMergeTree(sign, version)
ORDER BY (date, value)
SETTINGS enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '1', vertical_merge_algorithm_min_columns_to_activate = '0';

CREATE TABLE mult_tab
(
    date Date,
    value UInt64,
    key UInt64,
    version UInt64,
    sign Int8
)
ENGINE = VersionedCollapsingMergeTree(sign, version)
ORDER BY date
SETTINGS enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '1', vertical_merge_algorithm_min_columns_to_activate = '0';

DROP TABLE mult_tab;