DROP TABLE IF EXISTS mv;

DROP TABLE IF EXISTS dst;

DROP TABLE IF EXISTS src;

DROP DICTIONARY IF EXISTS dict;

CREATE TABLE src
(
    key Int
)
ENGINE = MergeTree()
ORDER BY ();

CREATE TABLE dst
(
    key Int
)
ENGINE = MergeTree()
ORDER BY ();

CREATE DICTIONARY dict
(
    key Int,
    value Int
)
PRIMARY KEY key
SOURCE(clickhouse(QUERY 'select 0 key, 0 value'))
LAYOUT(DIRECT());

CREATE MATERIALIZED VIEW mv
TO dst
AS
SELECT *
FROM src;

ALTER TABLE mv MODIFY QUERY WITH 'dict' AS dict_name

SELECT dictGetInt32(dict_name, 'value', key)
FROM src;