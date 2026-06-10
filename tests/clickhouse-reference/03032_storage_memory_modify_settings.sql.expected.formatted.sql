-- Tags: memory-engine
SET max_block_size = '65409'; -- Default value

DROP TABLE IF EXISTS memory;

CREATE TABLE memory
(
    i UInt32
)
ENGINE = Memory()
SETTINGS min_bytes_to_keep = '8192', max_bytes_to_keep = '32768';

INSERT INTO memory SELECT *
FROM numbers(0, 100); -- 1024 bytes

INSERT INTO memory SELECT *
FROM numbers(0, 3000); -- 16384 bytes

SELECT total_bytes
FROM `system`.tables
WHERE name = 'memory'
    AND database = currentDatabase(); -- 17408 in total

ALTER TABLE memory MODIFY SETTING min_bytes_to_keep = '4096', max_bytes_to_keep = '16384';

INSERT INTO memory SELECT *
FROM numbers(3000, 10000); -- 65536 bytes

CREATE TABLE memory
(
    i UInt32
)
ENGINE = Memory()
SETTINGS min_rows_to_keep = '200', max_rows_to_keep = '2000';

INSERT INTO memory SELECT *
FROM numbers(100, 1000); -- 1000 rows

SELECT total_rows
FROM `system`.tables
WHERE name = 'memory'
    AND database = currentDatabase(); -- 1100 in total

ALTER TABLE memory MODIFY SETTING min_rows_to_keep = '100', max_rows_to_keep = '1000';

INSERT INTO memory SELECT *
FROM numbers(1000, 500); -- 500 rows

CREATE TABLE memory
(
    i UInt32
)
ENGINE = Memory();

INSERT INTO memory SELECT *
FROM numbers(0, 50); -- 50 rows

INSERT INTO memory SELECT *
FROM numbers(50, 950); -- 950 rows

INSERT INTO memory SELECT *
FROM numbers(2000, 70); -- 70 rows

INSERT INTO memory SELECT *
FROM numbers(3000, 1100); -- 1100 rows

ALTER TABLE memory MODIFY SETTING min_rows_to_keep = '100'; -- { serverError SETTING_CONSTRAINT_VIOLATION }

ALTER TABLE memory MODIFY SETTING min_bytes_to_keep = '100'; -- { serverError SETTING_CONSTRAINT_VIOLATION }

ALTER TABLE memory MODIFY SETTING max_rows_to_keep = '1000';

ALTER TABLE memory MODIFY SETTING max_bytes_to_keep = '1000';

DROP TABLE memory;