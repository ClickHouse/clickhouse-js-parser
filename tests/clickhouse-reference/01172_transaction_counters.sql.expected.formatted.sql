-- Tags: no-ordinary-database, no-encrypted-storage
DROP TABLE IF EXISTS txn_counters;

CREATE TABLE txn_counters
(
    n Int64,
    creation_tid DEFAULT transactionID()
)
ENGINE = MergeTree()
ORDER BY n
SETTINGS old_parts_lifetime = '3600';

INSERT INTO txn_counters (n);

SELECT transactionID();

-- stop background cleanup
SYSTEM STOP MERGES txn_counters;

SET throw_on_unsupported_query_inside_transaction = '0';

BEGIN TRANSACTION;

INSERT INTO txn_counters (n);

SELECT
    1,
    `system`.parts.name,
    txn_counters.creation_tid = `system`.parts.creation_tid
FROM
    txn_counters
INNER JOIN `system`.parts
    ON txn_counters._part = `system`.parts.name
WHERE database = currentDatabase()
    AND table = 'txn_counters'
ORDER BY `system`.parts.name ASC;

SELECT
    2,
    name,
    creation_csn,
    removal_tid,
    removal_csn
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'txn_counters'
ORDER BY `system`.parts.name ASC;

ROLLBACK;

INSERT INTO txn_counters (n);

SELECT
    3,
    `system`.parts.name,
    txn_counters.creation_tid = `system`.parts.creation_tid
FROM
    txn_counters
INNER JOIN `system`.parts
    ON txn_counters._part = `system`.parts.name
WHERE database = currentDatabase()
    AND table = 'txn_counters'
ORDER BY `system`.parts.name ASC;

SELECT
    4,
    name,
    creation_csn,
    removal_tid,
    removal_csn
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'txn_counters'
ORDER BY `system`.parts.name ASC;

SELECT
    5,
    transactionID().3 = serverUUID();

COMMIT;

DETACH TABLE txn_counters;

ATTACH TABLE txn_counters;

INSERT INTO txn_counters (n);

SELECT
    6,
    `system`.parts.name,
    txn_counters.creation_tid = `system`.parts.creation_tid
FROM
    txn_counters
INNER JOIN `system`.parts
    ON txn_counters._part = `system`.parts.name
WHERE database = currentDatabase()
    AND table = 'txn_counters'
ORDER BY `system`.parts.name ASC;

SELECT
    7,
    name,
    removal_tid,
    removal_csn
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'txn_counters'
    AND active
ORDER BY `system`.parts.name ASC;

SELECT
    8,
    transactionID().3 = serverUUID();

INSERT INTO txn_counters (n);

ALTER TABLE txn_counters DROP PARTITION ID 'all';

SYSTEM FLUSH LOGS transactions_info_log;

SELECT
    indexOf((
        SELECT arraySort(groupUniqArray(tid))
        FROM `system`.transactions_info_log
        WHERE database = currentDatabase()
            AND table = 'txn_counters'
    ), tid),
    type,
    thread_id != 0,
    length(query_id) = length(queryID())
    OR type = 'Commit'
    AND query_id = '', -- ignore fault injection after commit
    tid_hash != 0,
    csn = 0,
    part
FROM `system`.transactions_info_log
WHERE tid IN (
        SELECT tid
        FROM `system`.transactions_info_log
        WHERE database = currentDatabase()
            AND table = 'txn_counters'
            AND NOT((tid).1 = 1
            AND (tid).2 = 1)
    )
    OR database = currentDatabase()
    AND table = 'txn_counters'
ORDER BY event_time ASC;

DROP TABLE txn_counters;