-- Tags: use-rocksdb
DROP TABLE IF EXISTS rdb;

DROP TABLE IF EXISTS t2;

CREATE TABLE rdb
(
    key UInt32,
    value String
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY key;

INSERT INTO rdb;

CREATE TABLE t2
(
    k UInt16
)
ENGINE = TinyLog();

INSERT INTO t2;

SELECT value = 'direct,parallel_hash,hash'
FROM `system`.`settings`
WHERE name = 'join_algorithm';

SELECT
    countIf(`explain` LIKE '%Algorithm: DirectKeyValueJoin%'),
    countIf(`explain` LIKE '%Algorithm: HashJoin%')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    (
                        SELECT k AS key
                        FROM t2
                    ) AS t2
                INNER JOIN rdb
                    ON rdb.key = t2.key
                ORDER BY key ASC
            ))
    );

SET join_algorithm = 'direct, hash';

SELECT value = 'direct,hash'
FROM `system`.`settings`
WHERE name = 'join_algorithm';

SET join_algorithm = 'hash, direct';

SELECT value = 'hash,direct'
FROM `system`.`settings`
WHERE name = 'join_algorithm';

SET join_algorithm = 'grace_hash,hash';

SELECT value = 'grace_hash,hash'
FROM `system`.`settings`
WHERE name = 'join_algorithm';

SELECT
    countIf(`explain` LIKE '%Algorithm: GraceHashJoin%'),
    countIf(`explain` LIKE '%Algorithm: HashJoin%')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    (
                        SELECT
                            number AS key,
                            number * 10 AS key2
                        FROM numbers_mt(10)
                    ) AS t1
                INNER JOIN (
                        SELECT
                            k AS key,
                            k + 100 AS key2
                        FROM t2
                    ) AS t2
                    ON t1.key = t2.key
                    OR t1.key2 = t2.key2
            ))
    );

SELECT
    countIf(`explain` LIKE '%Algorithm: GraceHashJoin%'),
    countIf(`explain` LIKE '%Algorithm: HashJoin%')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM
                    (
                        SELECT
                            number AS key,
                            number * 10 AS key2
                        FROM numbers_mt(10)
                    ) AS t1
                INNER JOIN (
                        SELECT
                            k AS key,
                            k + 100 AS key2
                        FROM t2
                    ) AS t2
                    ON t1.key = t2.key
            ))
    );

SET join_algorithm = 'grace_hash, hash, auto';

SELECT value = 'grace_hash,hash,auto'
FROM `system`.`settings`
WHERE name = 'join_algorithm';

DROP DICTIONARY IF EXISTS dict;

DROP TABLE IF EXISTS src;

CREATE TABLE src
(
    id UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY id AS
SELECT
    number,
    toString(number)
FROM numbers(1000000);

CREATE DICTIONARY dict
(
    id UInt64,
    s String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'src' DB currentDatabase()))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SET join_algorithm = 'default';

SELECT
    countIf(`explain` LIKE '%Algorithm: DirectKeyValueJoin%'),
    countIf(`explain` LIKE '%Algorithm: HashJoin%')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT s
                FROM
                    (
                        SELECT toUInt64(9911) AS id
                    ) AS t1
                INNER JOIN dict AS t2
                    USING (id)
            ))
    );

SET join_algorithm = 'direct,hash';

SET join_algorithm = 'hash,direct';

SET join_algorithm = 'grace_hash';

-- Cannot execute the grace hash with OR condition
SELECT *
FROM
    (
        SELECT
            number AS key,
            number * 10 AS key2
        FROM numbers_mt(10)
    ) AS t1
INNER JOIN (
        SELECT
            k AS key,
            k + 100 AS key2
        FROM t2
    ) AS t2
    ON t1.key = t2.key
    OR t1.key2 = t2.key2; -- { serverError NOT_IMPLEMENTED }

-- But for CROSS choose `hash` algorithm even though it's not enabled
SELECT *
FROM
    (
        SELECT
            number AS key,
            number * 10 AS key2
        FROM numbers_mt(10)
    ) AS t1
CROSS JOIN (
        SELECT
            k AS key,
            k + 100 AS key2
        FROM t2
    ) AS t2
FORMAT Null
SETTINGS enable_analyzer = '1';

-- ... (not for old analyzer)
SELECT *
FROM
    (
        SELECT
            number AS key,
            number * 10 AS key2
        FROM numbers_mt(10)
    ) AS t1
CROSS JOIN (
        SELECT
            k AS key,
            k + 100 AS key2
        FROM t2
    ) AS t2
FORMAT Null
SETTINGS enable_analyzer = '0'; -- { serverError NOT_IMPLEMENTED }