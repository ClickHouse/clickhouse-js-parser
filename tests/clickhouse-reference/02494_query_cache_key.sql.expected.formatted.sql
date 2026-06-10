SYSTEM CLEAR QUERY CACHE;

DROP DATABASE IF EXISTS db1;

DROP DATABASE IF EXISTS db2;

CREATE DATABASE db1;

CREATE DATABASE db2;

CREATE TABLE db1.tab
(
    a UInt64,
    PRIMARY KEY(a)
);

CREATE TABLE db2.tab
(
    a UInt64,
    PRIMARY KEY(a)
);

INSERT INTO db1.tab;

INSERT INTO db2.tab;

USE db1;

SELECT *
FROM tab
SETTINGS use_query_cache = '1';

USE db2;

DROP DATABASE db1;

DROP DATABASE db2;

-- test with query-level settings
SELECT 1
SETTINGS
    use_query_cache = '1',
    limit = '1',
    use_skip_indexes = '0'
FORMAT Null;

SELECT 1
SETTINGS
    use_query_cache = '1',
    use_skip_indexes = '0'
FORMAT Null;

SELECT 1
SETTINGS
    use_query_cache = '1',
    use_skip_indexes = '1'
FORMAT Null;

SELECT 1
SETTINGS
    use_query_cache = '1',
    max_block_size = '1'
FORMAT Null;

-- 4x the same query but with different settings each. There should yield four entries in the query cache.
SELECT count(query)
FROM `system`.query_cache;

-- test with mixed session-level/query-level settings
SET use_query_cache = '1';

SET limit = '1';

SELECT 1
SETTINGS use_skip_indexes = '0'
FORMAT Null;

SET limit = DEFAULT;

SET use_skip_indexes = '0';

SELECT 1
FORMAT Null;

SET use_skip_indexes = '1';

SELECT 1
SETTINGS use_skip_indexes = '1'
FORMAT Null;

SET use_skip_indexes = DEFAULT;

SET max_block_size = '1';

SET max_block_size = DEFAULT;

SET use_query_cache = DEFAULT;