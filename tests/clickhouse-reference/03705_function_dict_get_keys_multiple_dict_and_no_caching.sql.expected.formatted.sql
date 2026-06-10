DROP DICTIONARY IF EXISTS dict_products;

DROP DICTIONARY IF EXISTS dict_geo;

DROP TABLE IF EXISTS src_products;

DROP TABLE IF EXISTS src_geo;

DROP TABLE IF EXISTS inputs;

CREATE TABLE src_products
(
    id UInt64,
    category String,
    brand String
)
ENGINE = Memory();

INSERT INTO src_products;

CREATE TABLE src_geo
(
    country String,
    city String,
    timezone String,
    code UInt32
)
ENGINE = Memory();

INSERT INTO src_geo;

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

CREATE DICTIONARY dict_geo
(
    country String,
    city String,
    timezone String,
    code UInt32
)
PRIMARY KEY country, city
SOURCE(clickhouse(TABLE 'src_geo'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_HASHED());

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
    target_brand,
    target_timezone,
    dictGetKeys('dict_products', 'category', target_category) AS product_ids_by_category,
    dictGetKeys('dict_products', 'brand', target_brand) AS product_ids_by_brand,
    dictGetKeys('dict_geo', 'timezone', target_timezone) AS country_city_by_tz
FROM inputs
ORDER BY
    target_category ASC,
    target_brand ASC,
    target_timezone ASC;

SELECT dictGetKeys('dict_products', 'category', 'catA');

SELECT dictGetKeys('dict_products', 'category', concat('cat', 'A'));

SELECT
    target_category,
    dictGetKeys('dict_geo', 'timezone', concat('UTC', substring(target_timezone, 4))) AS country_city_by_tz_expr
FROM inputs
ORDER BY
    target_category ASC,
    target_brand ASC,
    target_timezone ASC;

SET max_reverse_dictionary_lookup_cache_size_bytes = '0';