-- Tags: zookeeper, no-parallel, no-shared-merge-tree
# no-shared-merge-tree: quorum logic is specifit to replicated tables
DROP TABLE IF EXISTS quorum1;

DROP TABLE IF EXISTS quorum2;

CREATE TABLE quorum1
(
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_02887/quorum', '1')
ORDER BY x;

CREATE TABLE quorum2
(
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_02887/quorum', '2')
ORDER BY x;

SET insert_keeper_fault_injection_probability = '0';

SET insert_keeper_max_retries = '0';

SET insert_quorum = '2';

SYSTEM ENABLE FAILPOINT replicated_merge_tree_insert_quorum_fail_0;

INSERT INTO quorum1; -- {serverError UNKNOWN_STATUS_OF_INSERT}

INSERT INTO quorum1;

SELECT count()
FROM quorum1;

DROP TABLE quorum1 SYNC;

DROP TABLE quorum2 SYNC;