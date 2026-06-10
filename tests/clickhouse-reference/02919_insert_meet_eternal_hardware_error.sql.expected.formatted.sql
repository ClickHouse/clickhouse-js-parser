-- Tags: zookeeper, no-parallel, no-shared-merge-tree
-- no-shared-merge-tree: This failure injection is only RMT specific
DROP TABLE IF EXISTS t_hardware_error SYNC;

CREATE TABLE t_hardware_error
(
    KeyID UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/{database}/t_async_insert_dedup', '{replica}')
ORDER BY KeyID;

INSERT INTO t_hardware_error;

-- Data is written to ZK but the connection fails right after and we can't recover it
SYSTEM ENABLE FAILPOINT replicated_merge_tree_commit_zk_fail_after_op;

SYSTEM ENABLE FAILPOINT replicated_merge_tree_commit_zk_fail_when_recovering_from_hw_fault;

INSERT INTO t_hardware_error; -- {serverError UNKNOWN_STATUS_OF_INSERT}

SYSTEM DISABLE FAILPOINT replicated_commit_zk_fail_after_op;

SYSTEM DISABLE FAILPOINT replicated_merge_tree_commit_zk_fail_when_recovering_from_hw_fault;

INSERT INTO t_hardware_error;

-- All 3 commits have been written correctly. The unknown status is ok (since it failed after the operation)
SELECT arraySort(groupArray(KeyID))
FROM t_hardware_error;

DROP TABLE t_hardware_error SYNC;