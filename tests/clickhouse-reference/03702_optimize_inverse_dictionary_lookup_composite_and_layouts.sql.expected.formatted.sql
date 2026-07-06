-- Tags: no-replicated-database, no-parallel-replicas
-- no-parallel, no-parallel-replicas: Dictionary is not created in parallel replicas.
SET enable_analyzer = '1';

SET optimize_inverse_dictionary_lookup = '1';

SET optimize_or_like_chain = '0';

DROP DICTIONARY IF EXISTS dict_prices_ckh;

DROP DICTIONARY IF EXISTS dict_prices_ch_array;

DROP DICTIONARY IF EXISTS dict_prices_ck_sparse_hashed;

DROP DICTIONARY IF EXISTS dict_items_flat;

DROP DICTIONARY IF EXISTS dict_items_hashed;

DROP DICTIONARY IF EXISTS dict_items_hashed_array;

DROP DICTIONARY IF EXISTS dict_items_sparse_hashed;

DROP TABLE IF EXISTS ref_prices_ckh;

DROP TABLE IF EXISTS ref_items_flat;

DROP TABLE IF EXISTS f;

CREATE TABLE ref_prices_ckh
(
    k1 UInt64,
    k2 String,
    price UInt64,
    tag String
)
ENGINE = MergeTree()
ORDER BY (k1, k2);

INSERT INTO ref_prices_ckh;

CREATE TABLE ref_items_flat
(
    id UInt64,
    name String,
    score UInt64
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO ref_items_flat;

CREATE DICTIONARY dict_prices_ckh
(
    k1 UInt64,
    k2 String,
    price UInt64,
    tag String
)
PRIMARY KEY k1, k2
SOURCE(clickhouse(TABLE 'ref_prices_ckh'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_HASHED());

CREATE DICTIONARY dict_prices_ch_array
(
    k1 UInt64,
    k2 String,
    price UInt64,
    tag String
)
PRIMARY KEY k1, k2
SOURCE(clickhouse(TABLE 'ref_prices_ckh'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_HASHED_ARRAY());

CREATE DICTIONARY dict_prices_ck_sparse_hashed
(
    k1 UInt64,
    k2 String,
    price UInt64,
    tag String
)
PRIMARY KEY k1, k2
SOURCE(clickhouse(TABLE 'ref_prices_ckh'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_SPARSE_HASHED());

CREATE DICTIONARY dict_items_flat
(
    id UInt64,
    name String,
    score UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'ref_items_flat'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

CREATE DICTIONARY dict_items_hashed
(
    id UInt64,
    name String,
    score UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'ref_items_flat'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

CREATE DICTIONARY dict_items_hashed_array
(
    id UInt64,
    name String,
    score UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'ref_items_flat'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED_ARRAY());

CREATE DICTIONARY dict_items_sparse_hashed
(
    id UInt64,
    name String,
    score UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'ref_items_flat'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(SPARSE_HASHED());

CREATE TABLE f
(
    k1 UInt64,
    k2 String,
    id UInt64,
    payload String
)
ENGINE = MergeTree()
ORDER BY (k1, k2, id);

INSERT INTO f;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    k1,
    k2,
    payload
FROM f
WHERE dictGet('dict_prices_ckh', 'tag', (k1, k2)) = 'pro'
ORDER BY
    k1 ASC,
    k2 ASC,
    payload ASC;

SELECT
    k1,
    k2,
    payload
FROM f
WHERE dictGet('dict_prices_ckh', 'tag', (k1, k2)) = 'pro'
ORDER BY
    k1 ASC,
    k2 ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    k1,
    k2,
    payload
FROM f
WHERE dictGet('dict_prices_ch_array', 'tag', (k1, k2)) = 'pro'
ORDER BY
    k1 ASC,
    k2 ASC,
    payload ASC;

SELECT
    k1,
    k2,
    payload
FROM f
WHERE dictGet('dict_prices_ch_array', 'tag', (k1, k2)) = 'pro'
ORDER BY
    k1 ASC,
    k2 ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    k1,
    k2,
    payload
FROM f
WHERE dictGet('dict_prices_ck_sparse_hashed', 'tag', (k1, k2)) = 'pro'
ORDER BY
    k1 ASC,
    k2 ASC,
    payload ASC;

SELECT
    k1,
    k2,
    payload
FROM f
WHERE dictGet('dict_prices_ck_sparse_hashed', 'tag', (k1, k2)) = 'pro'
ORDER BY
    k1 ASC,
    k2 ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM f
WHERE dictGet('dict_items_flat', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM f
WHERE dictGet('dict_items_flat', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM f
WHERE dictGet('dict_items_hashed', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM f
WHERE dictGet('dict_items_hashed', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM f
WHERE dictGet('dict_items_hashed_array', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM f
WHERE dictGet('dict_items_hashed_array', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT
    id,
    payload
FROM f
WHERE dictGet('dict_items_sparse_hashed', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;

SELECT
    id,
    payload
FROM f
WHERE dictGet('dict_items_sparse_hashed', 'name', id) = 'alpha'
ORDER BY
    id ASC,
    payload ASC;