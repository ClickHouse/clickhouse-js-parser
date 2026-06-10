-- Tags: no-parallel
-- https://github.com/ClickHouse/ClickHouse/issues/11469
SELECT dictGet('default.countryId', 'country', toUInt64(number)) AS country
FROM numbers(2)
GROUP BY country; -- { serverError BAD_ARGUMENTS }

-- with real dictionary
DROP TABLE IF EXISTS dictdb_01376.table_for_dict;

DROP DICTIONARY IF EXISTS dictdb_01376.dict_exists;

DROP DATABASE IF EXISTS dictdb_01376;

CREATE DATABASE dictdb_01376;

CREATE TABLE dictdb_01376.table_for_dict
(
    key_column UInt64,
    value Float64
)
ENGINE = Memory();

INSERT INTO dictdb_01376.table_for_dict;

CREATE DICTIONARY IF NOT EXISTS dictdb_01376.dict_exists
(
    key_column UInt64,
    value Float64 DEFAULT 77.77 INJECTIVE
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_for_dict' DB 'dictdb_01376'))
LIFETIME(MIN 0 MAX 1)
LAYOUT(FLAT());

SELECT dictGet('dictdb_01376.dict_exists', 'value', toUInt64(1)) AS val
FROM numbers(2)
GROUP BY val;

EXPLAIN SYNTAX
SELECT dictGet('dictdb_01376.dict_exists', 'value', toUInt64(1)) AS val
FROM numbers(2)
GROUP BY val;

EXPLAIN QUERY TREE
SELECT dictGet('dictdb_01376.dict_exists', 'value', number) AS val
FROM numbers(2)
GROUP BY val
SETTINGS enable_analyzer = '1';

DROP DICTIONARY dictdb_01376.dict_exists;

DROP TABLE dictdb_01376.table_for_dict;

DROP DATABASE dictdb_01376;