DROP TABLE IF EXISTS src;

CREATE TABLE src
(
    A Int64,
    B String,
    C String
)
ENGINE = MergeTree()
ORDER BY A
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO src;

ALTER TABLE src DETACH PARTITION tuple();

ALTER TABLE src MODIFY COLUMN B Nullable(String);

ALTER TABLE src ATTACH PARTITION tuple();

ALTER TABLE src UPDATE C = 'test1' WHERE 1 SETTINGS mutations_sync = '2';

SELECT *
FROM src;

CREATE TABLE src
(
    A String,
    B String,
    C String
)
ENGINE = MergeTree()
ORDER BY A
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO src;

ALTER TABLE src MODIFY COLUMN A LowCardinality(String);

ALTER TABLE src MODIFY COLUMN C LowCardinality(String);

ALTER TABLE src RENAME COLUMN B TO D;

SELECT '-----';

CREATE TABLE src
(
    A Int64,
    B String,
    C String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test/src1', '1')
ORDER BY A
SETTINGS min_bytes_for_wide_part = '0';

CREATE TABLE src
(
    A String,
    B String,
    C String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test/src2', '1')
ORDER BY A
SETTINGS min_bytes_for_wide_part = '0';

CREATE TABLE src
(
    A String,
    B String,
    C String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test/src3', '1')
ORDER BY A
SETTINGS min_bytes_for_wide_part = '0';

CREATE TABLE src
(
    A String,
    B String,
    C String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test/src4', '1')
ORDER BY A
SETTINGS min_bytes_for_wide_part = '0';