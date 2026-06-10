CREATE TABLE foo
(
    key int,
    INDEX i1 key TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY key;

CREATE TABLE as_foo AS foo;

CREATE TABLE dist
(
    key int,
    INDEX i1 key TYPE minmax() GRANULARITY 1
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 'foo'); -- { serverError BAD_ARGUMENTS }

CREATE TABLE dist_as_foo AS foo
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 'foo');

DROP TABLE foo;

DROP TABLE as_foo;

DROP TABLE dist_as_foo;