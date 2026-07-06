-- Tags: no-fasttest
CREATE TABLE t0
(
    c0 Int
)
ENGINE = MergeTree()
ORDER BY tuple();

SET query_plan_enable_optimizations = '0';

ALTER TABLE t0 MODIFY STATISTICS c0 TYPE Uniq, CountMin;

INSERT INTO t0 (c0);

ALTER TABLE t0 MODIFY STATISTICS c0 TYPE CountMin;

ALTER TABLE t0 APPLY DELETED MASK IN PARTITION ID '1';