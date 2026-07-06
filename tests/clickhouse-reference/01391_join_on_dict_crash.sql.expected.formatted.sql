CREATE TABLE t
(
    click_city_id UInt32,
    click_country_id UInt32
)
ENGINE = Memory();

CREATE TABLE d_src
(
    id UInt64,
    country_id UInt8,
    name String
)
ENGINE = Memory();

INSERT INTO t;

INSERT INTO d_src;

CREATE DICTIONARY d
(
    id UInt32,
    country_id UInt8,
    name String
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB currentDatabase() TABLE 'd_src'))
LIFETIME(MIN 1 MAX 1)
LAYOUT(HASHED());

SELECT click_country_id
FROM
    t AS cc
LEFT JOIN d
    ON toUInt32(d.id) = cc.click_city_id;

SELECT click_country_id
FROM
    t AS cc
LEFT JOIN d
    ON d.country_id < 99
    AND d.id = cc.click_city_id;