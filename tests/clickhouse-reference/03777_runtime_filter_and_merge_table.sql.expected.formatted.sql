SET enable_analyzer = '1';

DROP TABLE IF EXISTS foo;

DROP TABLE IF EXISTS foo1;

DROP TABLE IF EXISTS foo_merge;

DROP TABLE IF EXISTS t2;

CREATE TABLE foo
(
    Id Int32,
    Val Int32
)
ENGINE = MergeTree()
ORDER BY Id
PARTITION BY Val;

CREATE TABLE foo1
(
    Id Int32,
    Val Decimal32(9)
)
ENGINE = MergeTree()
ORDER BY Id
PARTITION BY Val;

INSERT INTO foo SELECT
    number,
    number % 5
FROM numbers(1000);

INSERT INTO foo1 SELECT
    number,
    1
FROM numbers(1000);

CREATE TABLE foo_merge AS foo
ENGINE = Merge(currentDatabase(), '^foo');

CREATE TABLE t2
(
    Id Int32,
    Val Int64,
    X UInt256
)
ENGINE = Memory();

INSERT INTO t2;

SELECT `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT count()
                FROM
                    foo_merge
                INNER JOIN t2
                    USING (Val)
                SETTINGS
                    enable_join_runtime_filters = '1',
                    parallel_replicas_local_plan = '1'
            ))
    );

SELECT count()
FROM
    foo_merge
INNER JOIN t2
    USING (Val)
SETTINGS enable_join_runtime_filters = '0';

SELECT count()
FROM
    foo_merge
INNER JOIN t2
    USING (Val)
SETTINGS enable_join_runtime_filters = '1';