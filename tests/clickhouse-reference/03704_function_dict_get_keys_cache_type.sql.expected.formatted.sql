DROP DICTIONARY IF EXISTS colors;

DROP TABLE IF EXISTS dict_src;

CREATE TABLE dict_src
(
    id UInt64,
    grp String
)
ENGINE = Memory();

INSERT INTO dict_src;

CREATE DICTIONARY colors
(
    id UInt64,
    grp String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dict_src'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictGetKeys('colors', 'grp', 'blue') AS keys
FROM numbers(1);

TRUNCATE TABLE dict_src;

INSERT INTO dict_src;

SYSTEM RELOAD DICTIONARY colors;

DROP DICTIONARY IF EXISTS dict_products;

DROP TABLE IF EXISTS src_products;

DROP TABLE IF EXISTS inputs;

CREATE TABLE src_products
(
    id UInt64,
    category String,
    brand String
)
ENGINE = Memory();

INSERT INTO src_products;

CREATE DICTIONARY dict_products
(
    id UInt64,
    category String,
    brand String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'src_products'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

CREATE TABLE inputs
(
    target_category String,
    target_brand String,
    target_timezone String
)
ENGINE = Memory();

INSERT INTO inputs;

SELECT
    target_category,
    dictGetKeys('dict_products', 'category', target_category) AS product_ids_by_category_before
FROM inputs
ORDER BY
    target_category ASC,
    target_brand ASC,
    target_timezone ASC;

ALTER TABLE src_products DELETE WHERE category = 'catA' SETTINGS mutations_sync = '1';

SYSTEM RELOAD DICTIONARY dict_products;

SELECT
    target_category,
    dictGetKeys('dict_products', 'category', target_category) AS product_ids_by_category_after
FROM inputs
ORDER BY
    target_category ASC,
    target_brand ASC,
    target_timezone ASC;