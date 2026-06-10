-- Tags: no-replicated-database, no-fasttest, no-shared-merge-tree
-- Tag no-replicated-database: different number of replicas
CREATE TABLE tableIn
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/02916/{database}/table', '1')
ORDER BY tuple()
SETTINGS storage_policy = 's3_cache', sleep_before_commit_local_part_in_replicated_table_ms = '5000';

CREATE TABLE tableOut
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/02916/{database}/table', '2')
ORDER BY tuple()
SETTINGS storage_policy = 's3_cache';

SET send_logs_level = 'error';

INSERT INTO tableIn;

INSERT INTO tableIn;

SYSTEM SYNC REPLICA tableOut;

SELECT count()
FROM tableOut;

DROP TABLE tableIn;

DROP TABLE tableOut;