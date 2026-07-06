-- Tags: no-ordinary-database, no-fasttest, no-parallel-replicas, use-rocksdb
-- Tag no-ordinary-database: Sometimes cannot lock file most likely due to concurrent or adjacent tests, but we don't care how it works in Ordinary database
-- Tag no-fasttest: In fasttest, ENABLE_LIBRARIES=0, so rocksdb engine is not enabled by default
DROP TABLE IF EXISTS `03720_test`;

CREATE TABLE `03720_test`
(
    k1 UInt64,
    k2 UInt64,
    val UInt64
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_test` SELECT
    number % 10,
    number,
    number
FROM numbers(100);

SELECT COUNT(1) = 100
FROM `03720_test`; -- Full scan

SELECT COUNT(1) = 5
FROM `03720_test`
WHERE k1 = 5
    AND k2 IN (15, 35, 55, 75, 95); -- Key scan

SELECT COUNT(1) = 0
FROM `03720_test`
WHERE k1 = 6
    AND k2 IN (15, 35, 55, 75, 95);

SELECT COUNT(1) = 1
FROM `03720_test`
WHERE k1 IN (1, 3, 5)
    AND k2 = 15
    AND k1 IN (3, 5, 7);

SELECT COUNT(1) = 0
FROM `03720_test`
WHERE k1 IN (1, 3, 5)
    AND k2 = 15
    AND k1 IN (2, 4, 6);

SELECT COUNT(1) = 6
FROM `03720_test`
WHERE (k1 IN (1, 3, 5)
    OR k1 IN (2, 3, 4, 5, 6))
    AND k2 IN (11, 13, 15, 12, 14, 16);

DROP TABLE `03720_test`;

-- Tuple equality
DROP TABLE IF EXISTS `03720_tuple_equality`;

CREATE TABLE `03720_tuple_equality`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_tuple_equality`;

SELECT val
FROM `03720_tuple_equality`
WHERE (k1, k2) = (1, 10)
ORDER BY val ASC;

SELECT val
FROM `03720_tuple_equality`
WHERE (k1, k2) = (2, 20)
ORDER BY val ASC;

SELECT COUNT(*)
FROM `03720_tuple_equality`
WHERE (k1, k2) = (3, 30); -- non-existent

SELECT COUNT(*)
FROM `03720_tuple_equality`
WHERE k1 = 1
    AND k2 IN ();

DROP TABLE `03720_tuple_equality`;

-- Tuple IN syntax
DROP TABLE IF EXISTS `03720_tuple_in`;

CREATE TABLE `03720_tuple_in`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_tuple_in`;

SELECT val
FROM `03720_tuple_in`
WHERE (k1, k2) IN ((1, 10), (2, 20), (3, 30))
ORDER BY val ASC;

SELECT COUNT(*)
FROM `03720_tuple_in`
WHERE (k1, k2) IN ((1, 10), (5, 50)); -- partial match

DROP TABLE `03720_tuple_in`;

-- Three-column primary key
DROP TABLE IF EXISTS `03720_three_columns`;

CREATE TABLE `03720_three_columns`
(
    k1 UInt32,
    k2 UInt32,
    k3 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2, k3);

INSERT INTO `03720_three_columns`;

SELECT val
FROM `03720_three_columns`
WHERE (k1, k2, k3) = (1, 1, 1)
ORDER BY val ASC;

SELECT val
FROM `03720_three_columns`
WHERE (k1, k2, k3) IN ((1, 1, 1), (2, 1, 1))
ORDER BY val ASC;

SELECT COUNT(*)
FROM `03720_three_columns`
WHERE k1 = 1
    AND k2 = 1
    AND k3 IN (1, 2); -- Cartesian with 3 keys

SELECT COUNT(*)
FROM `03720_three_columns`
WHERE k1 = 1
    AND k2 = 1
    AND k3 = 1
    OR k1 = 1
    AND k2 = 2
    AND k3 = 1; -- OR with all 3 keys specified

DROP TABLE `03720_three_columns`;

-- Four-column
DROP TABLE IF EXISTS `03720_four_columns`;

CREATE TABLE `03720_four_columns`
(
    k1 UInt32,
    k2 UInt32,
    k3 UInt32,
    k4 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2, k3, k4);

INSERT INTO `03720_four_columns`;

SELECT val
FROM `03720_four_columns`
WHERE (k1, k2, k3, k4) = (1, 2, 3, 4);

SELECT COUNT(*)
FROM `03720_four_columns`
WHERE k1 = 1
    AND k2 = 2
    AND k3 = 3
    AND k4 IN (4, 5);

DROP TABLE `03720_four_columns`;

-- String type
DROP TABLE IF EXISTS `03720_string_keys`;

CREATE TABLE `03720_string_keys`
(
    k1 String,
    k2 String,
    val UInt32
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_string_keys`;

SELECT val
FROM `03720_string_keys`
WHERE (k1, k2) = ('foo', 'bar')
ORDER BY val ASC;

SELECT val
FROM `03720_string_keys`
WHERE k1 = 'foo'
    AND k2 IN ('bar', 'baz')
ORDER BY val ASC;

SELECT COUNT(*)
FROM `03720_string_keys`
WHERE (k1, k2) IN (('foo', 'bar'), ('qux', 'bar'));

DROP TABLE `03720_string_keys`;

-- Mixed types
DROP TABLE IF EXISTS `03720_mixed_types`;

CREATE TABLE `03720_mixed_types`
(
    k1 UInt64,
    k2 String,
    val Float32
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_mixed_types`;

SELECT val
FROM `03720_mixed_types`
WHERE (k1, k2) = (100, 'a')
ORDER BY val ASC;

SELECT val
FROM `03720_mixed_types`
WHERE k1 = 100
    AND k2 IN ('a', 'b')
ORDER BY val ASC;

DROP TABLE `03720_mixed_types`;

-- DateTime
DROP TABLE IF EXISTS `03720_datetime`;

CREATE TABLE `03720_datetime`
(
    k1 UInt32,
    k2 DateTime,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_datetime`;

SELECT val
FROM `03720_datetime`
WHERE (k1, k2) = (1, '2024-01-01 00:00:00');

DROP TABLE `03720_datetime`;

-- Enum types
DROP TABLE IF EXISTS `03720_enum`;

CREATE TABLE `03720_enum`
(
    k1 Enum8('a' = 1, 'b' = 2),
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_enum`;

SELECT val
FROM `03720_enum`
WHERE (k1, k2) = ('a', 1);

DROP TABLE `03720_enum`;

-- Single column key (backward compatibility)
DROP TABLE IF EXISTS `03720_single_column`;

CREATE TABLE `03720_single_column`
(
    k1 UInt64,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY k1;

INSERT INTO `03720_single_column`;

SELECT val
FROM `03720_single_column`
WHERE k1 = 1
ORDER BY val ASC;

SELECT val
FROM `03720_single_column`
WHERE k1 IN (1, 3)
ORDER BY val ASC;

DROP TABLE `03720_single_column`;

-- Cartesian product: 5x3 = 15 lookups
DROP TABLE IF EXISTS `03720_cartesian`;

CREATE TABLE `03720_cartesian`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_cartesian`;

SELECT COUNT(*)
FROM `03720_cartesian`
WHERE k1 IN (0, 1, 2, 3, 4)
    AND k2 IN (0, 1, 2);

SELECT COUNT(*)
FROM `03720_cartesian`
WHERE k1 = 5
    AND k2 IN (0, 1, 2, 3, 4);

DROP TABLE `03720_cartesian`;

-- Large Cartesian product
DROP TABLE IF EXISTS `03720_large_cartesian`;

CREATE TABLE `03720_large_cartesian`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_large_cartesian` SELECT
    intDiv(number, 100),
    number % 100,
    toString(number)
FROM numbers(10000);

SELECT COUNT(*)
FROM `03720_large_cartesian`
WHERE k1 IN (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
    AND k2 IN (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);

DROP TABLE `03720_large_cartesian`;

-- Empty result sets
DROP TABLE IF EXISTS `03720_empty_results`;

CREATE TABLE `03720_empty_results`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_empty_results`;

SELECT COUNT(*)
FROM `03720_empty_results`
WHERE (k1, k2) = (2, 2);

SELECT COUNT(*)
FROM `03720_empty_results`
WHERE (k1, k2) IN ((2, 2), (3, 3));

SELECT COUNT(*)
FROM `03720_empty_results`
WHERE k1 = 1
    AND k2 = 2;

DROP TABLE `03720_empty_results`;

-- OR conditions
DROP TABLE IF EXISTS `03720_complex_or`;

CREATE TABLE `03720_complex_or`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_complex_or`;

SELECT COUNT(*)
FROM `03720_complex_or`
WHERE k1 = 1
    AND k2 = 1
    OR k1 = 2
    AND k2 = 2;

SELECT COUNT(*)
FROM `03720_complex_or`
WHERE (k1, k2) IN ((1, 1), (2, 2));

DROP TABLE `03720_complex_or`;

-- Update and upsert operations with multi-column keys
DROP TABLE IF EXISTS `03720_mutations`;

CREATE TABLE `03720_mutations`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_mutations`;

-- Update by overwriting (RocksDB's upsert behavior)
INSERT INTO `03720_mutations`;

SELECT val
FROM `03720_mutations`
WHERE (k1, k2) = (1, 1)
ORDER BY val ASC;

DROP TABLE `03720_mutations`;

-- Partial key filter (should trigger full scan)
DROP TABLE IF EXISTS `03720_partial_key`;

CREATE TABLE `03720_partial_key`
(
    k1 UInt32,
    k2 UInt32,
    k3 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2, k3);

INSERT INTO `03720_partial_key` SELECT
    intDiv(number, 10),
    number % 10,
    number % 3,
    toString(number)
FROM numbers(100);

-- Only k1 specified - should trigger full scan
SELECT COUNT(*)
FROM `03720_partial_key`
WHERE k1 = 1;

DROP TABLE `03720_partial_key`;

-- DELETE operations with multi-column primary keys
DROP TABLE IF EXISTS `03720_deletes`;

CREATE TABLE `03720_deletes`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_deletes`;

-- Delete single row with full key
DELETE FROM `03720_deletes` WHERE k1 = 1
AND k2 = 1;

SELECT COUNT(*)
FROM `03720_deletes`; -- Should be 4

SELECT val
FROM `03720_deletes`
WHERE k1 = 1
ORDER BY val ASC; -- Should be 'b'

-- Delete using tuple equality
DELETE FROM `03720_deletes` WHERE (k1, k2) = (2, 2);

SELECT val
FROM `03720_deletes`
WHERE k1 = 2
ORDER BY val ASC; -- Should be 'c'

-- Delete using tuple IN
DELETE FROM `03720_deletes` WHERE (k1, k2) IN ((1, 2), (3, 3));

SELECT val
FROM `03720_deletes`
ORDER BY val ASC; -- Should be 'c'

DROP TABLE `03720_deletes`;

-- DELETE with three-column primary key
DROP TABLE IF EXISTS `03720_deletes_three_col`;

CREATE TABLE `03720_deletes_three_col`
(
    k1 UInt32,
    k2 UInt32,
    k3 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2, k3);

INSERT INTO `03720_deletes_three_col`;

DELETE FROM `03720_deletes_three_col` WHERE (k1, k2, k3) = (1, 1, 1);

SELECT COUNT(*)
FROM `03720_deletes_three_col`; -- Should be 3

DELETE FROM `03720_deletes_three_col` WHERE (k1, k2, k3) IN ((1, 1, 2), (2, 1, 1));

SELECT val
FROM `03720_deletes_three_col`
ORDER BY val ASC; -- Should be 'c'

DROP TABLE `03720_deletes_three_col`;

-- DELETE with string keys
DROP TABLE IF EXISTS `03720_deletes_string`;

CREATE TABLE `03720_deletes_string`
(
    k1 String,
    k2 String,
    val UInt32
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_deletes_string`;

DELETE FROM `03720_deletes_string` WHERE k1 = 'foo'
AND k2 = 'bar';

SELECT COUNT(*)
FROM `03720_deletes_string`; -- Should be 2

SELECT val
FROM `03720_deletes_string`
WHERE k1 = 'foo'
ORDER BY val ASC; -- Should be 2

DROP TABLE `03720_deletes_string`;

-- UPDATE operations using ALTER TABLE
DROP TABLE IF EXISTS `03720_updates`;

CREATE TABLE `03720_updates`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_updates`;

-- Update using ALTER TABLE
ALTER TABLE `03720_updates` UPDATE val = 'updated' WHERE k1 = 1
AND k2 = 1;

ALTER TABLE `03720_updates` UPDATE val = 'modified' WHERE k1 = 1
AND k2 = 2;

SELECT val
FROM `03720_updates`
WHERE (k1, k2) = (1, 1); -- Should be 'updated'

SELECT val
FROM `03720_updates`
WHERE (k1, k2) = (1, 2); -- Should be 'modified'

SELECT val
FROM `03720_updates`
WHERE (k1, k2) = (2, 1); -- Should be 'test'

SELECT COUNT(*)
FROM `03720_updates`; -- Should be 3

-- Update with tuple equality
ALTER TABLE `03720_updates` UPDATE val = 'changed' WHERE (k1, k2) = (2, 1);

DROP TABLE `03720_updates`;

-- UPDATE with three-column primary key
DROP TABLE IF EXISTS `03720_updates_three_col`;

CREATE TABLE `03720_updates_three_col`
(
    k1 UInt32,
    k2 UInt32,
    k3 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2, k3);

INSERT INTO `03720_updates_three_col`;

ALTER TABLE `03720_updates_three_col` UPDATE val = 'updated_v1' WHERE (k1, k2, k3) = (1, 1, 1);

SELECT val
FROM `03720_updates_three_col`
WHERE (k1, k2, k3) = (1, 1, 1); -- Should be 'updated_v1'

SELECT COUNT(*)
FROM `03720_updates_three_col`; -- Should be 3

DROP TABLE `03720_updates_three_col`;

-- UPDATE with string keys
DROP TABLE IF EXISTS `03720_updates_string`;

CREATE TABLE `03720_updates_string`
(
    k1 String,
    k2 String,
    val UInt32
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_updates_string`;

ALTER TABLE `03720_updates_string` UPDATE val = 999 WHERE k1 = 'foo'
AND k2 = 'bar';

SELECT val
FROM `03720_updates_string`
WHERE (k1, k2) = ('foo', 'bar'); -- Should be 999

SELECT COUNT(*)
FROM `03720_updates_string`; -- Should be 2

DROP TABLE `03720_updates_string`;

-- UPSERT operations (INSERT for new + update existing via INSERT)
DROP TABLE IF EXISTS `03720_upsert`;

CREATE TABLE `03720_upsert`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_upsert`;

-- Upsert: insert new and overwrite existing
INSERT INTO `03720_upsert`;

SELECT val
FROM `03720_upsert`
WHERE (k1, k2) = (1, 1); -- Should be 'upserted'

SELECT val
FROM `03720_upsert`
WHERE (k1, k2) = (2, 2); -- Should be 'new'

SELECT COUNT(*)
FROM `03720_upsert`; -- Should be 3

DROP TABLE `03720_upsert`;

-- JOIN operations with multi-column primary keys
SET join_algorithm = 'direct, hash';

DROP TABLE IF EXISTS `03720_join_left`;

DROP TABLE IF EXISTS `03720_join_right`;

CREATE TABLE `03720_join_left`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

CREATE TABLE `03720_join_right`
(
    k1 UInt32,
    k2 UInt32,
    info String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_join_left`;

INSERT INTO `03720_join_right`;

-- INNER JOIN on multi-column keys
SELECT
    l.val,
    r.info
FROM
    `03720_join_left` AS l
INNER JOIN `03720_join_right` AS r
    ON l.k1 = r.k1
    AND l.k2 = r.k2
ORDER BY l.val ASC;

-- LEFT JOIN on multi-column keys
SELECT
    l.val,
    r.info
FROM
    `03720_join_left` AS l
LEFT JOIN `03720_join_right` AS r
    ON l.k1 = r.k1
    AND l.k2 = r.k2
ORDER BY l.val ASC;

-- COUNT with INNER JOIN
SELECT COUNT(*)
FROM
    `03720_join_left` AS l
INNER JOIN `03720_join_right` AS r
    ON l.k1 = r.k1
    AND l.k2 = r.k2;

DROP TABLE `03720_join_left`;

DROP TABLE `03720_join_right`;

-- JOIN with three-column primary keys
DROP TABLE IF EXISTS `03720_join_three_left`;

DROP TABLE IF EXISTS `03720_join_three_right`;

CREATE TABLE `03720_join_three_left`
(
    k1 UInt32,
    k2 UInt32,
    k3 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2, k3);

CREATE TABLE `03720_join_three_right`
(
    k1 UInt32,
    k2 UInt32,
    k3 UInt32,
    info String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2, k3);

INSERT INTO `03720_join_three_left`;

INSERT INTO `03720_join_three_right`;

SELECT
    l.val,
    r.info
FROM
    `03720_join_three_left` AS l
INNER JOIN `03720_join_three_right` AS r
    ON l.k1 = r.k1
    AND l.k2 = r.k2
    AND l.k3 = r.k3
ORDER BY l.val ASC;

SELECT COUNT(*)
FROM
    `03720_join_three_left` AS l
LEFT JOIN `03720_join_three_right` AS r
    ON l.k1 = r.k1
    AND l.k2 = r.k2
    AND l.k3 = r.k3;

DROP TABLE `03720_join_three_left`;

DROP TABLE `03720_join_three_right`;

-- JOIN with string keys
DROP TABLE IF EXISTS `03720_join_str_left`;

DROP TABLE IF EXISTS `03720_join_str_right`;

CREATE TABLE `03720_join_str_left`
(
    k1 String,
    k2 String,
    val UInt32
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

CREATE TABLE `03720_join_str_right`
(
    k1 String,
    k2 String,
    val UInt32
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

INSERT INTO `03720_join_str_left`;

INSERT INTO `03720_join_str_right`;

SELECT
    l.val,
    r.val
FROM
    `03720_join_str_left` AS l
INNER JOIN `03720_join_str_right` AS r
    ON l.k1 = r.k1
    AND l.k2 = r.k2
ORDER BY l.val ASC;

SELECT COUNT(*)
FROM
    `03720_join_str_left` AS l
LEFT JOIN `03720_join_str_right` AS r
    ON l.k1 = r.k1
    AND l.k2 = r.k2;

DROP TABLE `03720_join_str_left`;

DROP TABLE `03720_join_str_right`;

-- JOIN with mixed table types (RocksDB + MergeTree)
DROP TABLE IF EXISTS `03720_join_rocks`;

DROP TABLE IF EXISTS `03720_join_merge`;

CREATE TABLE `03720_join_rocks`
(
    k1 UInt32,
    k2 UInt32,
    val String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY (k1, k2);

CREATE TABLE `03720_join_merge`
(
    k1 UInt32,
    k2 UInt32,
    info String
)
ENGINE = MergeTree()
ORDER BY (k1, k2);

INSERT INTO `03720_join_rocks`;

INSERT INTO `03720_join_merge`;

SELECT
    r.val,
    m.info
FROM
    `03720_join_rocks` AS r
INNER JOIN `03720_join_merge` AS m
    ON r.k1 = m.k1
    AND r.k2 = m.k2
ORDER BY r.val ASC;

SELECT COUNT(*)
FROM
    `03720_join_rocks` AS r
LEFT JOIN `03720_join_merge` AS m
    ON r.k1 = m.k1
    AND r.k2 = m.k2;

DROP TABLE `03720_join_rocks`;

DROP TABLE `03720_join_merge`;