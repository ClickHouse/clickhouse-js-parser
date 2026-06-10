-- Tags: no-ordinary-database, no-fasttest, use-rocksdb
DROP TABLE IF EXISTS `02416_rocksdb`;

CREATE TABLE `02416_rocksdb`
(
    key UInt64,
    value String,
    value2 UInt64
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY key;

INSERT INTO `02416_rocksdb`;

SELECT *
FROM `02416_rocksdb`
ORDER BY key ASC;

SELECT '-----------';

DELETE FROM `02416_rocksdb` WHERE value LIKE 'Some%string';

ALTER TABLE `02416_rocksdb` DELETE WHERE key >= 4;

DELETE FROM `02416_rocksdb` WHERE 1 = 1;

SELECT count()
FROM `02416_rocksdb`;

INSERT INTO `02416_rocksdb`;

ALTER TABLE `02416_rocksdb` UPDATE value = 'Another' WHERE key > 2;

ALTER TABLE `02416_rocksdb` UPDATE key = key * 10 WHERE 1 = 1; -- { serverError BAD_ARGUMENTS }

ALTER TABLE `02416_rocksdb` UPDATE value2 = value2 * 10 + 2 WHERE 1 = 1;