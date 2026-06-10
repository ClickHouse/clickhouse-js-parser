-- Tags: no-fasttest
SET send_logs_level = 'fatal';

CREATE TABLE CLICKHOUSE_DATABASE.date_table
(
    CountryID UInt64,
    StartDate Date,
    EndDate Date,
    Tax Float64
)
ENGINE = MergeTree()
ORDER BY CountryID;

INSERT INTO CLICKHOUSE_DATABASE.date_table;

INSERT INTO CLICKHOUSE_DATABASE.date_table;

INSERT INTO CLICKHOUSE_DATABASE.date_table;

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict1
(
    CountryID UInt64,
    StartDate Date,
    EndDate Date,
    Tax Float64
)
PRIMARY KEY CountryID
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'date_table' DB currentDatabase()))
LIFETIME(MIN 1 MAX 1000)
RANGE(MIN StartDate MAX EndDate)
LAYOUT(RANGE_HASHED());

SELECT dictGetFloat64('placeholder' || '.dict1', 'Tax', toUInt64(1), toDate('2019-05-15'));

SELECT dictGetFloat64('placeholder' || '.dict1', 'Tax', toUInt64(1), toDate('2019-05-29'));

SELECT dictGetFloat64('placeholder' || '.dict1', 'Tax', toUInt64(2), toDate('2019-05-29'));

SELECT dictGetFloat64('placeholder' || '.dict1', 'Tax', toUInt64(2), toDate('2019-05-31'));

CREATE TABLE CLICKHOUSE_DATABASE.datetime_table
(
    CountryID UInt64,
    StartDate DateTime,
    EndDate DateTime,
    Tax Float64
)
ENGINE = MergeTree()
ORDER BY CountryID;

INSERT INTO CLICKHOUSE_DATABASE.datetime_table;

INSERT INTO CLICKHOUSE_DATABASE.datetime_table;

INSERT INTO CLICKHOUSE_DATABASE.datetime_table;

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict2
(
    CountryID UInt64,
    StartDate DateTime,
    EndDate DateTime,
    Tax Float64
)
PRIMARY KEY CountryID
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'datetime_table' DB currentDatabase()))
LIFETIME(MIN 1 MAX 1000)
RANGE(MIN StartDate MAX EndDate)
LAYOUT(RANGE_HASHED());

SELECT dictGetFloat64('placeholder' || '.dict2', 'Tax', toUInt64(1), toDateTime('2019-05-15 00:00:00'));

SELECT dictGetFloat64('placeholder' || '.dict2', 'Tax', toUInt64(1), toDateTime('2019-05-29 00:00:00'));

SELECT dictGetFloat64('placeholder' || '.dict2', 'Tax', toUInt64(2), toDateTime('2019-05-29 00:00:00'));

SELECT dictGetFloat64('placeholder' || '.dict2', 'Tax', toUInt64(2), toDateTime('2019-05-31 00:00:00'));

CREATE TABLE CLICKHOUSE_DATABASE.table_with_hierarchy
(
    RegionID UInt64,
    ParentRegionID UInt64,
    RegionName String
)
ENGINE = MergeTree()
ORDER BY RegionID;

INSERT INTO CLICKHOUSE_DATABASE.table_with_hierarchy;

CREATE DICTIONARY CLICKHOUSE_DATABASE.dictionary_with_hierarchy
(
    RegionID UInt64,
    ParentRegionID UInt64 HIERARCHICAL,
    RegionName String
)
PRIMARY KEY RegionID
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB currentDatabase() TABLE 'table_with_hierarchy'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(HASHED());

SELECT dictGetString('placeholder' || '.dictionary_with_hierarchy', 'RegionName', toUInt64(2));

SELECT dictGetHierarchy('placeholder' || '.dictionary_with_hierarchy', toUInt64(3));

SELECT dictIsIn('placeholder' || '.dictionary_with_hierarchy', toUInt64(3), toUInt64(2));

SELECT dictIsIn('placeholder' || '.dictionary_with_hierarchy', toUInt64(7), toUInt64(10000));

SELECT dictIsIn('placeholder' || '.dictionary_with_hierarchy', toUInt64(1), toUInt64(5));

DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE;