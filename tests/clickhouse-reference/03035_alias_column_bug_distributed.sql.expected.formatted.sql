-- https://github.com/ClickHouse/ClickHouse/issues/44414
SET enable_analyzer = '1';

DROP TABLE IF EXISTS alias_bug;

DROP TABLE IF EXISTS alias_bug_dist;

CREATE TABLE alias_bug
(
    src String,
    theAlias String ALIAS trimBoth(src)
)
ENGINE = MergeTree()
ORDER BY src;

CREATE TABLE alias_bug_dist AS alias_bug
ENGINE = Distributed('test_shard_localhost', currentDatabase(), 'alias_bug', rand());

INSERT INTO alias_bug;

-- OK
SELECT
    theAlias,
    CAST(NULL AS Nullable(String)) AS src
FROM alias_bug
LIMIT 1
FORMAT Null;

-- Not OK
SELECT
    theAlias,
    CAST(NULL AS Nullable(String)) AS src
FROM alias_bug_dist
LIMIT 1
FORMAT Null;

CREATE TABLE alias_bug
(
    s String,
    src String,
    theAlias String ALIAS trimBoth(src)
)
ENGINE = MergeTree()
ORDER BY src;

-- Unknown identifier
SELECT
    CAST(123 AS String) AS src,
    theAlias
FROM alias_bug_dist
LIMIT 1
FORMAT Null;