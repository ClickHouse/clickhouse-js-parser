-- Tags: no-ordinary-database, no-fasttest
DROP TABLE IF EXISTS `02418_test` SYNC;

CREATE TABLE `02418_test`
(
    key UInt64,
    value Float64
)
ENGINE = KeeperMap('/' || currentDatabase() || '/test2418', 3)
PRIMARY KEY key;

INSERT INTO `02418_test`;

SELECT count()
FROM `02418_test`;

INSERT INTO `02418_test`; -- { serverError LIMIT_EXCEEDED }

INSERT INTO `02418_test`;

CREATE TABLE `02418_test_another`
(
    key UInt64,
    value Float64
)
ENGINE = KeeperMap('/' || currentDatabase() || '/test2418', 4)
PRIMARY KEY key;

INSERT INTO `02418_test`; -- { serverError LIMIT_EXCEEDED }

INSERT INTO `02418_test_another`;

SELECT count()
FROM `02418_test_another`;

DELETE FROM `02418_test` WHERE key <= 2;

INSERT INTO `02418_test`;

INSERT INTO `02418_test`; -- { serverError LIMIT_EXCEEDED }

DROP TABLE `02418_test` SYNC;

DROP TABLE `02418_test_another` SYNC;