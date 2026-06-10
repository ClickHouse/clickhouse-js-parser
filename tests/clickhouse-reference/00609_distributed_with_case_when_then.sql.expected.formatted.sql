-- Tags: distributed
DROP TABLE IF EXISTS mergetree_00609;

DROP TABLE IF EXISTS distributed_00609;

CREATE TABLE mergetree_00609
(
    x UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO mergetree_00609;

SELECT caseWithExpression(x, 1, 'hello', 2, 'world', 'unknow')
FROM mergetree_00609;

SELECT count() AS cnt
FROM (
        SELECT caseWithExpression(x, 1, 'hello', 2, 'world', 'unknow')
        FROM mergetree_00609
    );

CREATE TABLE distributed_00609 AS mergetree_00609
ENGINE = Distributed(test_shard_localhost, currentDatabase(), mergetree_00609);

SELECT caseWithExpression(x, 1, 'hello', 2, 'world', 'unknow')
FROM distributed_00609;

SELECT count() AS cnt
FROM (
        SELECT caseWithExpression(x, 1, 'hello', 2, 'world', 'unknow')
        FROM distributed_00609
    );

DROP TABLE mergetree_00609;

DROP TABLE distributed_00609;