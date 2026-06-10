-- Tags: zookeeper, no-shared-merge-tree
-- no-shared-merge-tree: shared merge tree doesn't loose data parts
SET max_rows_to_read = '0'; -- system.text_log can be really big

CREATE TABLE rmt1
(
    d DateTime,
    n int
)
ENGINE = ReplicatedMergeTree('/test/01165/{database}/rmt', '1')
ORDER BY n
PARTITION BY toYYYYMMDD(d);

CREATE TABLE rmt2
(
    d DateTime,
    n int
)
ENGINE = ReplicatedMergeTree('/test/01165/{database}/rmt', '2')
ORDER BY n
PARTITION BY toYYYYMMDD(d);

SYSTEM STOP REPLICATED SENDS rmt1;

INSERT INTO rmt1; -- { error BAD_ARGUMENTS }

INSERT INTO rmt1 (n) SELECT *
FROM `system`.numbers
LIMIT arrayJoin([1, 2]); -- { serverError BAD_ARGUMENTS, INVALID_LIMIT_EXPRESSION }

INSERT INTO rmt1;

DROP TABLE rmt1;

SYSTEM SYNC REPLICA rmt2;

SELECT lost_part_count
FROM `system`.replicas
WHERE database = currentDatabase()
    AND table = 'rmt2';

DROP TABLE rmt2;

SYSTEM FLUSH LOGS text_log;

SELECT count()
FROM `system`.text_log
WHERE logger_name LIKE '%' || currentDatabase() || '%'
    AND message ILIKE '%table with non-zero lost_part_count equal to%';

CREATE TABLE rmt1
(
    d DateTime,
    n int
)
ENGINE = ReplicatedMergeTree('/test/01165/{database}/rmt', '1')
ORDER BY n
PARTITION BY tuple();

CREATE TABLE rmt2
(
    d DateTime,
    n int
)
ENGINE = ReplicatedMergeTree('/test/01165/{database}/rmt', '2')
ORDER BY n
PARTITION BY tuple();

CREATE TABLE rmt1
(
    n UInt8,
    m Int32,
    d Date,
    t DateTime
)
ENGINE = ReplicatedMergeTree('/test/01165/{database}/rmt', '1')
ORDER BY n
PARTITION BY (n, m, d, t);

CREATE TABLE rmt2
(
    n UInt8,
    m Int32,
    d Date,
    t DateTime
)
ENGINE = ReplicatedMergeTree('/test/01165/{database}/rmt', '2')
ORDER BY n
PARTITION BY (n, m, d, t);

INSERT INTO rmt1;