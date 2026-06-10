-- insert data duplicates by providing deduplication token on insert
DROP TABLE IF EXISTS insert_dedup_token1 SYNC;

DROP TABLE IF EXISTS insert_dedup_token2 SYNC;

CREATE TABLE insert_dedup_token1
(
    id Int32,
    val UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/insert_dedup_token', 'r1')
ORDER BY id;

INSERT INTO insert_dedup_token1;

SELECT *
FROM insert_dedup_token1
ORDER BY id ASC;

SYSTEM FLUSH LOGS `system`.part_log;

SELECT DISTINCT exception
FROM `system`.part_log
WHERE table = 'insert_dedup_token1'
    AND database = currentDatabase()
    AND event_type = 'NewPart'
    AND error = 389;

SET insert_deduplication_token = '1';

INSERT INTO insert_dedup_token1;

SET insert_deduplication_token = '';

CREATE TABLE insert_dedup_token2
(
    id Int32,
    val UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/insert_dedup_token', 'r2')
ORDER BY id;

SYSTEM SYNC REPLICA insert_dedup_token2;

INSERT INTO insert_dedup_token2; -- deduplicated by data digest

SELECT *
FROM insert_dedup_token2
ORDER BY id ASC;

INSERT INTO insert_dedup_token2; -- deduplicated by dedup token

SET insert_deduplication_token = '2';

INSERT INTO insert_dedup_token2; -- inserted

DROP TABLE insert_dedup_token1 SYNC;

DROP TABLE insert_dedup_token2 SYNC;