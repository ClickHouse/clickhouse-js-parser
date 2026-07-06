-- Tags: no-parallel
SET send_logs_level = 'fatal';

DROP DATABASE IF EXISTS dict_db_01224;

DROP DATABASE IF EXISTS dict_db_01224_dictionary;

SET allow_deprecated_database_ordinary = '1';

-- Creation of a database with Ordinary engine emits a warning.
CREATE DATABASE dict_db_01224
ENGINE = Ordinary(); -- Different internal dictionary name with Atomic

CREATE DATABASE dict_db_01224_dictionary
ENGINE = Dictionary();

CREATE TABLE dict_db_01224.dict_data
(
    key UInt64,
    val UInt64
)
ENGINE = Memory();

CREATE DICTIONARY dict_db_01224.dict
(
    key UInt64 DEFAULT 0,
    val UInt64 DEFAULT 10
)
PRIMARY KEY key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'dict_data' PASSWORD '' DB 'dict_db_01224'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

SELECT status
FROM `system`.dictionaries
WHERE database = 'dict_db_01224'
    AND name = 'dict';

SELECT *
FROM `system`.tables
FORMAT Null;

SHOW CREATE TABLE dict_db_01224.dict FORMAT TSVRaw;

SHOW CREATE TABLE dict_db_01224_dictionary.`dict_db_01224.dict` FORMAT TSVRaw;

SELECT
    engine,
    metadata_path LIKE '%metadata/dict\\_db\\_01224/dict.sql',
    create_table_query
FROM `system`.tables
WHERE database = 'dict_db_01224'
    AND name = 'dict';

SELECT
    name,
    type
FROM `system`.`columns`
WHERE database = 'dict_db_01224'
    AND table = 'dict';

DROP DICTIONARY dict_db_01224.dict;

DROP DATABASE dict_db_01224;

DROP DATABASE dict_db_01224_dictionary;