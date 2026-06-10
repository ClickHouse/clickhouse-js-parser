SET replication_alter_partitions_sync = '2';

DROP TABLE IF EXISTS clear_column;

CREATE TABLE clear_column
(
    d Date,
    num Int64,
    str String
)
ENGINE = MergeTree()
ORDER BY d
PARTITION BY toYYYYMM(d)
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO clear_column;

SELECT data_uncompressed_bytes
FROM `system`.`columns`
WHERE database = currentDatabase()
    AND table = 'clear_column'
    AND name = 'num';

SELECT
    num,
    str
FROM clear_column
ORDER BY num ASC;

ALTER TABLE clear_column CLEAR COLUMN num IN PARTITION '201612';

ALTER TABLE clear_column CLEAR COLUMN num IN PARTITION '201611';

SELECT
    data_compressed_bytes,
    data_uncompressed_bytes
FROM `system`.`columns`
WHERE database = currentDatabase()
    AND table = 'clear_column'
    AND name = 'num';

DROP TABLE clear_column;

DROP TABLE IF EXISTS clear_column1;

DROP TABLE IF EXISTS clear_column2;

SELECT sleep(1)
FORMAT Null;

CREATE TABLE clear_column1
(
    d Date,
    i Int64
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test_00446/tables/clear_column', '1')
ORDER BY d
PARTITION BY toYYYYMM(d)
SETTINGS min_bytes_for_wide_part = '0';

CREATE TABLE clear_column2
(
    d Date,
    i Int64
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test_00446/tables/clear_column', '2')
ORDER BY d
PARTITION BY toYYYYMM(d)
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO clear_column1 (d);

SYSTEM SYNC REPLICA clear_column2;

SET replication_alter_partitions_sync = '2';

ALTER TABLE clear_column1 ADD COLUMN s String;

ALTER TABLE clear_column1 CLEAR COLUMN s IN PARTITION '200001';

INSERT INTO clear_column1;

INSERT INTO clear_column1;

SELECT *
FROM clear_column2
ORDER BY
    d ASC,
    i ASC,
    s ASC;

ALTER TABLE clear_column1 CLEAR COLUMN i IN PARTITION '200001';

ALTER TABLE clear_column1 CLEAR COLUMN i IN PARTITION '200002';

ALTER TABLE clear_column1 CLEAR COLUMN s IN PARTITION '200002';

SELECT DISTINCT *
FROM clear_column2
ORDER BY
    d ASC,
    i ASC,
    s ASC;

SELECT sum(data_uncompressed_bytes)
FROM `system`.`columns`
WHERE database = currentDatabase()
    AND table LIKE 'clear_column_'
    AND (name = 'i'
    OR name = 's')
GROUP BY table;

SET optimize_throw_if_noop = '1';

OPTIMIZE TABLE clear_column1 PARTITION '200001';

OPTIMIZE TABLE clear_column1 PARTITION '200002';

-- clear column in empty partition should be Ok
ALTER TABLE clear_column1 CLEAR COLUMN s IN PARTITION '200012', CLEAR COLUMN i IN PARTITION '200012';

-- Drop empty partition also Ok
ALTER TABLE clear_column1 DROP PARTITION '200012', DROP PARTITION '200011';

DROP TABLE clear_column1;

DROP TABLE clear_column2;