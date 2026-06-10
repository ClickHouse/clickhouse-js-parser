-- Tags: distributed
CREATE TABLE table_1
(
    x UInt32,
    y String,
    INDEX a length(y) TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS index_granularity = '2';

INSERT INTO table_1;

CREATE TABLE distr_table
(
    x UInt32,
    y String
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), 'table_1');

-- { echoOn }
SET max_rows_to_read = '2';

SELECT *
FROM table_1
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_1', 'x > 3')];

SELECT *
FROM table_1
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_1', 'x < 3')];

SELECT *
FROM table_1
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_1', 'length(y) >= 3')];

SELECT *
FROM table_1
ORDER BY x ASC
SETTINGS additional_table_filters = [('table_1', 'length(y) < 3')];

SET max_rows_to_read = '4';

SELECT *
FROM distr_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('distr_table', 'x > 3')];

SELECT *
FROM distr_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('distr_table', 'x < 3')];

SELECT *
FROM distr_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('distr_table', 'length(y) > 3')];

SELECT *
FROM distr_table
ORDER BY x ASC
SETTINGS additional_table_filters = [('distr_table', 'length(y) < 3')];