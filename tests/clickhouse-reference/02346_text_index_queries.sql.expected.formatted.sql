-- Tags: no-fasttest
-- no-fasttest: It can be slow
SET enable_full_text_index = '1';

SET log_queries = '1';

SET merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 0.;

-- Affects the number of read rows.
SET use_skip_indexes_on_data_read = '0';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    k UInt64,
    s String,
    INDEX af s TYPE text(tokenizer = ngrams(2)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY k
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';

INSERT INTO tab;

-- check text index was created
SELECT
    name,
    type
FROM `system`.data_skipping_indices
WHERE table = 'tab'
    AND database = currentDatabase()
LIMIT 1;

-- throw in a random consistency check
CHECK TABLE tab SETTINGS check_query_single_value_result = '1';

-- search text index with ==
SELECT *
FROM tab
WHERE s = 'Alick a01';

-- check the query only read 1 granules (2 rows total; each granule has 2 rows)
SYSTEM FLUSH LOGS query_log;

SELECT read_rows = 2
FROM `system`.query_log
WHERE query_kind = 'Select'
    AND current_database = currentDatabase()
    AND endsWith(trimRight(query), 'SELECT * FROM tab WHERE s == ''Alick a01'';')
    AND type = 'QueryFinish'
    AND result_rows = 1
LIMIT 1;

-- search text index with LIKE
SELECT *
FROM tab
WHERE s LIKE '%01%'
ORDER BY k ASC;

SELECT read_rows = 4
FROM `system`.query_log
WHERE query_kind = 'Select'
    AND current_database = currentDatabase()
    AND endsWith(trimRight(query), 'SELECT * FROM tab WHERE s LIKE ''%01%'' ORDER BY k;')
    AND type = 'QueryFinish'
    AND result_rows = 2
LIMIT 1;

-- search text index with hasToken
SELECT *
FROM tab
WHERE hasToken(s, 'Click')
ORDER BY k ASC;

SELECT read_rows = 8
FROM `system`.query_log
WHERE query_kind = 'Select'
    AND current_database = currentDatabase()
    AND endsWith(trimRight(query), 'SELECT * FROM tab WHERE hasToken(s, ''Click'') ORDER BY k;')
    AND type = 'QueryFinish'
    AND result_rows = 4
LIMIT 1;

DROP TABLE IF EXISTS tab_x;

CREATE TABLE tab_x
(
    k UInt64,
    s String,
    INDEX af s TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY k
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';

INSERT INTO tab_x;

-- check text index was created
SELECT
    name,
    type
FROM `system`.data_skipping_indices
WHERE table = 'tab_x'
    AND database = currentDatabase()
LIMIT 1;

-- search text index with hasToken
SELECT *
FROM tab_x
WHERE hasToken(s, 'Alick')
ORDER BY k ASC;

SELECT read_rows = 8
FROM `system`.query_log
WHERE query_kind = 'Select'
    AND current_database = currentDatabase()
    AND endsWith(trimRight(query), 'SELECT * FROM tab_x WHERE hasToken(s, ''Alick'');')
    AND type = 'QueryFinish'
    AND result_rows = 4
LIMIT 1;

-- search text index with IN operator
SELECT *
FROM tab_x
WHERE s IN ('x Alick a01 y', 'x Alick a06 y')
ORDER BY k ASC;

SELECT read_rows = 4
FROM `system`.query_log
WHERE query_kind = 'Select'
    AND current_database = currentDatabase()
    AND endsWith(trimRight(query), 'SELECT * FROM tab_x WHERE s IN (''x Alick a01 y'', ''x Alick a06 y'') ORDER BY k;')
    AND type = 'QueryFinish'
    AND result_rows = 2
LIMIT 1;

CREATE TABLE tab
(
    k UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY k
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';

INSERT INTO tab;

INSERT INTO tab;

ALTER TABLE tab ADD INDEX af s TYPE text(tokenizer = ngrams(2)) GRANULARITY 100000000 SETTINGS mutations_sync = '2';

OPTIMIZE TABLE tab FINAL;

-- check text index was created
SELECT
    name,
    type
FROM `system`.data_skipping_indices
WHERE table = 'tab'
    AND database = currentDatabase()
LIMIT 1;

SELECT read_rows = 6
FROM `system`.query_log
WHERE query_kind = 'Select'
    AND current_database = currentDatabase()
    AND endsWith(trimRight(query), 'SELECT * FROM tab WHERE s LIKE ''%01%'' ORDER BY k;')
    AND type = 'QueryFinish'
    AND result_rows = 3
LIMIT 1;

INSERT INTO tab;

-- search text index
SELECT *
FROM tab
WHERE s LIKE '%你好%'
ORDER BY k ASC;

SELECT read_rows = 2
FROM `system`.query_log
WHERE query_kind = 'Select'
    AND current_database = currentDatabase()
    AND endsWith(trimRight(query), 'SELECT * FROM tab WHERE s LIKE ''%你好%'' ORDER BY k;')
    AND type = 'QueryFinish'
    AND result_rows = 1
LIMIT 1;

CREATE TABLE tab
(
    k UInt64,
    s String,
    INDEX af s TYPE text(tokenizer = sparseGrams(3, 100)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY k
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';

-- search text index
SELECT *
FROM tab
WHERE s LIKE '%house你好%'
ORDER BY k ASC;

CREATE TABLE tab
(
    k UInt64,
    s String,
    INDEX af s TYPE text(tokenizer = sparseGrams(3, 100, 4)) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY k
SETTINGS index_granularity = '2', index_granularity_bytes = '10Mi';