-- Tags: no-replicated-database
-- Tag no-replicated-database: Unsupported type of ALTER query
DROP TABLE IF EXISTS t;

# Memory, MergeTree, and ReplicatedMergeTree
CREATE TABLE t
(
    x UInt8
)
ENGINE = Memory()
COMMENT 'Hello';

SELECT comment
FROM `system`.tables
WHERE database = currentDatabase()
    AND table = 't';

ALTER TABLE t MODIFY COMMENT 'World';

DROP TABLE t;

CREATE TABLE t
(
    x UInt8
)
ENGINE = MergeTree()
ORDER BY ()
COMMENT 'Hello';

# The case when there are many operations in one ALTER
CREATE TABLE t
(
    x UInt8
)
ENGINE = MergeTree()
ORDER BY ()
COMMENT 'Hello';

ALTER TABLE t MODIFY COMMENT 'World', MODIFY COLUMN x UInt16;

# Note that the table comment is not replicated. We can implement it later.
CREATE TABLE t
(
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_comment_table1/t', '1')
ORDER BY ()
COMMENT 'Hello';

DROP TABLE t SYNC;

CREATE TABLE t
(
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_comment_table2/t', '1')
ORDER BY ()
COMMENT 'Hello';

# The cases when there is no comment on creation
CREATE TABLE t
(
    x UInt8
)
ENGINE = Memory();

CREATE TABLE t
(
    x UInt8
)
ENGINE = MergeTree()
ORDER BY ();

CREATE TABLE t
(
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_comment_table3/t', '1')
ORDER BY ();

CREATE TABLE t
(
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_comment_table4/t', '1')
ORDER BY ();