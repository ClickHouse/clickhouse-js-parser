DROP DICTIONARY IF EXISTS CLICKHOUSE_DATABASE.test_dict_01051_d;

DROP TABLE IF EXISTS CLICKHOUSE_DATABASE.test_01051_d;

DROP TABLE IF EXISTS CLICKHOUSE_DATABASE.test_view_01051_d;

CREATE TABLE CLICKHOUSE_DATABASE.test_01051_d
(
    key UInt64,
    value String
)
ENGINE = MergeTree()
ORDER BY key;

CREATE VIEW CLICKHOUSE_DATABASE.test_view_01051_d (key UInt64, value String)
AS
SELECT
    k2 + 1 AS key,
    v2 || '_x' AS value
FROM (
        SELECT
            key + 2 AS k2,
            value || '_y' AS v2
        FROM test_01051_d
    );

INSERT INTO CLICKHOUSE_DATABASE.test_01051_d;

CREATE DICTIONARY CLICKHOUSE_DATABASE.test_dict_01051_d
(
    key UInt64,
    value String
)
PRIMARY KEY key
SOURCE(clickhouse(HOST 'localhost' PORT '9000' USER 'default' PASSWORD '' DB currentDatabase() TABLE 'test_view_01051_d'))
LIFETIME(MIN 0 MAX 100500)
LAYOUT(FLAT());

SELECT dictGet('placeholder' || '.test_dict_01051_d', 'value', toUInt64(4));