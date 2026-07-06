CREATE TABLE rmt
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/02468/{database}', '1')
ORDER BY tuple()
PARTITION BY n % 2
SETTINGS replicated_max_ratio_of_wrong_parts = '0', max_suspicious_broken_parts = '0', max_suspicious_broken_parts_bytes = '0';

CREATE TABLE rmt1
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/02468/{database}', '2')
ORDER BY tuple()
PARTITION BY n % 2
SETTINGS replicated_max_ratio_of_wrong_parts = '0', max_suspicious_broken_parts = '0', max_suspicious_broken_parts_bytes = '0';

SYSTEM STOP CLEANUP rmt;

SYSTEM STOP MERGES rmt1;

INSERT INTO rmt SELECT *
FROM numbers(10)
SETTINGS
    max_block_size = '1',
    max_insert_threads = '1';

ALTER TABLE rmt DROP PARTITION ID '0';

TRUNCATE TABLE rmt1;

SYSTEM SYNC REPLICA rmt;

SYSTEM SYNC REPLICA rmt1;

DETACH TABLE rmt SYNC;

DETACH TABLE rmt1 SYNC;

ATTACH TABLE rmt;

ATTACH TABLE rmt1;

INSERT INTO rmt;

INSERT INTO rmt1;

SELECT
    *,
    _table
FROM merge(currentDatabase(), '')
ORDER BY
    _table ASC,
    (*,) ASC;

SELECT 0;

CREATE TABLE rmt2
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/02468/{database}2', '1')
ORDER BY tuple()
PARTITION BY n % 2
SETTINGS replicated_max_ratio_of_wrong_parts = '0', max_suspicious_broken_parts = '0', max_suspicious_broken_parts_bytes = '0';

SYSTEM SYNC REPLICA rmt1 LIGHTWEIGHT;

ALTER TABLE rmt REPLACE PARTITION ID '0' FROM rmt2;

ALTER TABLE rmt1 MOVE PARTITION ID '1' TO TABLE rmt2;

SYSTEM SYNC REPLICA rmt2;

CREATE TABLE rmt3
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/02468/{database}3', '1')
ORDER BY tuple()
SETTINGS replicated_max_ratio_of_wrong_parts = '0', max_suspicious_broken_parts = '0', max_suspicious_broken_parts_bytes = '0';

SET insert_keeper_fault_injection_probability = '0';

INSERT INTO rmt3;

INSERT INTO rmt3;

INSERT INTO rmt3;

SYSTEM STOP CLEANUP rmt3;

SYSTEM SYNC REPLICA rmt3 PULL;

ALTER TABLE rmt3 DROP PART 'all_1_1_0';

OPTIMIZE TABLE rmt3 FINAL;

DETACH TABLE rmt3 SYNC;

ATTACH TABLE rmt3;

SELECT *
FROM rmt3
ORDER BY n ASC;