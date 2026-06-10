-- Tags: zookeeper
SET allow_unrestricted_reads_from_keeper = 'true';

DROP TABLE IF EXISTS test_zkinsert;

CREATE TABLE test_zkinsert
(
    name String,
    path String,
    value String
)
ENGINE = Memory();

-- test recursive create and big transaction
INSERT INTO test_zkinsert (name, path, value);

-- insert same value, suppose to have no side effects
INSERT INTO `system`.zookeeper (name, path, value) SELECT
    name,
    '/' || currentDatabase() || path,
    value
FROM test_zkinsert;

SELECT *
FROM (
        SELECT
            path,
            name,
            value
        FROM `system`.zookeeper
        ORDER BY
            path ASC,
            name ASC
    )
WHERE path LIKE '/' || currentDatabase() || '/1-insert-test%';

SELECT '-------------------------';

-- test inserting into root path
INSERT INTO test_zkinsert (name, path, value);

INSERT INTO test_zkinsert (name, path, value);

INSERT INTO test_zkinsert (name, path, value);

INSERT INTO test_zkinsert (name, path);

INSERT INTO test_zkinsert (name, value, path);

SELECT *
FROM (
        SELECT
            path,
            name,
            value
        FROM `system`.zookeeper
        ORDER BY
            path ASC,
            name ASC
    )
WHERE path LIKE '/' || currentDatabase() || '/2-insert-test%';

-- test exceptions
INSERT INTO `system`.zookeeper (name, value); -- { serverError BAD_ARGUMENTS }

INSERT INTO `system`.zookeeper (path, value); -- { serverError BAD_ARGUMENTS }

INSERT INTO `system`.zookeeper (name, version); -- { serverError ILLEGAL_COLUMN }

INSERT INTO `system`.zookeeper (name, versionxyz); -- { serverError NO_SUCH_COLUMN_IN_TABLE }

INSERT INTO `system`.zookeeper (name, path, value); -- { serverError BAD_ARGUMENTS }

INSERT INTO `system`.zookeeper (name, path, value); -- { serverError BAD_ARGUMENTS }

INSERT INTO `system`.zookeeper (name, path, value); -- { serverError BAD_ARGUMENTS }

INSERT INTO `system`.zookeeper (name, path, value); -- { serverError BAD_ARGUMENTS }

-- prepare the root node for auxiliary zookeeper
INSERT INTO `system`.zookeeper (name, path, value);

CREATE TABLE test_zkinsert
(
    name String,
    path String,
    value String,
    zookeeperName String DEFAULT 'zookeeper2'
)
ENGINE = Memory();

-- insert same value, suppose to have no side effects
INSERT INTO `system`.zookeeper (name, path, value, zookeeperName) SELECT
    name,
    '/' || currentDatabase() || path,
    value,
    zookeeperName
FROM test_zkinsert;

SELECT *
FROM (
        SELECT
            path,
            name,
            value
        FROM `system`.zookeeper
        WHERE zookeeperName = 'zookeeper2'
        ORDER BY
            path ASC,
            name ASC
    )
WHERE path LIKE '/' || currentDatabase() || '/1-insert-test%';

SELECT *
FROM (
        SELECT
            path,
            name,
            value
        FROM `system`.zookeeper
        WHERE zookeeperName = 'zookeeper2'
        ORDER BY
            path ASC,
            name ASC
    )
WHERE path LIKE '/' || currentDatabase() || '/2-insert-test%';