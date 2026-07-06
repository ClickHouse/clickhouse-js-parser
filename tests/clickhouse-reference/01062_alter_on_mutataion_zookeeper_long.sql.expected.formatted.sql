-- Tags: long, zookeeper, no-replicated-database, no-shared-merge-tree
-- Tag no-replicated-database: Old syntax is not allowed
-- no-shared-merge-tree: old syntax not allowed
DROP TABLE IF EXISTS test_alter_on_mutation;

CREATE TABLE test_alter_on_mutation
(
    date Date,
    key UInt64,
    value String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_01062/alter_on_mutation', '1')
ORDER BY key
PARTITION BY date;

INSERT INTO test_alter_on_mutation SELECT
    toDate('2020-01-05'),
    number,
    toString(number)
FROM `system`.numbers
LIMIT 100;

INSERT INTO test_alter_on_mutation SELECT
    toDate('2020-01-06'),
    number,
    toString(number)
FROM `system`.numbers
LIMIT 100;

INSERT INTO test_alter_on_mutation SELECT
    toDate('2020-01-07'),
    number,
    toString(number)
FROM `system`.numbers
LIMIT 100;

SELECT sum(CAST(value AS UInt64))
FROM test_alter_on_mutation;

ALTER TABLE test_alter_on_mutation MODIFY COLUMN value UInt64;

SELECT sum(value)
FROM test_alter_on_mutation;

INSERT INTO test_alter_on_mutation SELECT
    toDate('2020-01-05'),
    number,
    toString(number)
FROM `system`.numbers
LIMIT 100
OFFSET 100;

INSERT INTO test_alter_on_mutation SELECT
    toDate('2020-01-06'),
    number,
    toString(number)
FROM `system`.numbers
LIMIT 100
OFFSET 100;

INSERT INTO test_alter_on_mutation SELECT
    toDate('2020-01-07'),
    number,
    toString(number)
FROM `system`.numbers
LIMIT 100
OFFSET 100;

OPTIMIZE TABLE test_alter_on_mutation FINAL;

ALTER TABLE test_alter_on_mutation MODIFY COLUMN value String;

ALTER TABLE test_alter_on_mutation ADD COLUMN value1 Float64;

SELECT sum(value1)
FROM test_alter_on_mutation;

ALTER TABLE test_alter_on_mutation DROP COLUMN value;

ALTER TABLE test_alter_on_mutation ADD COLUMN value String DEFAULT '10';

ALTER TABLE test_alter_on_mutation MODIFY COLUMN value UInt64 DEFAULT 10;

DROP TABLE IF EXISTS nested_alter;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE nested_alter
(
    d Date,
    k UInt64,
    i32 Int32,
    dt DateTime,
    `n.ui8` Array(UInt8),
    `n.s` Array(String),
    `n.d` Array(Date),
    s String DEFAULT '0'
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_01062/nested_alter', 'r2', d, k, 8192);

INSERT INTO nested_alter;

SELECT *
FROM nested_alter;

ALTER TABLE nested_alter DROP COLUMN `n.d`;

DROP TABLE nested_alter;