DROP TABLE IF EXISTS CLICKHOUSE_DATABASE.test_table_01080;

CREATE TABLE CLICKHOUSE_DATABASE.test_table_01080
(
    dim_key Int64,
    dim_id String
)
ENGINE = MergeTree()
ORDER BY dim_key;

INSERT INTO CLICKHOUSE_DATABASE.test_table_01080;

DROP DICTIONARY IF EXISTS CLICKHOUSE_DATABASE.test_dict_01080;

CREATE DICTIONARY CLICKHOUSE_DATABASE.test_dict_01080
(
    dim_key Int64,
    dim_id String
)
PRIMARY KEY dim_key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' PASSWORD '' DB currentDatabase() TABLE 'test_table_01080'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_HASHED());

SELECT dictGetString('placeholder' || '.test_dict_01080', 'dim_id', tuple(toInt64(1)));

SELECT dictGetString('placeholder' || '.test_dict_01080', 'dim_id', tuple(toInt64(0)));

SELECT dictGetString('placeholder' || '.test_dict_01080', 'dim_id', x)
FROM (
        SELECT tuple(toInt64(0)) AS x
    );

SELECT dictGetString('placeholder' || '.test_dict_01080', 'dim_id', x)
FROM (
        SELECT tuple(toInt64(1)) AS x
    );

SELECT dictGetString('placeholder' || '.test_dict_01080', 'dim_id', x)
FROM (
        SELECT tuple(toInt64(number)) AS x
        FROM numbers(5)
    );

SELECT dictGetString('placeholder' || '.test_dict_01080', 'dim_id', x)
FROM (
        SELECT tuple(toInt64(rand64() * 0)) AS x
    );

SELECT dictGetString('placeholder' || '.test_dict_01080', 'dim_id', x)
FROM (
        SELECT tuple(toInt64(blockSize() = 0)) AS x
    );

SELECT dictGetString('placeholder' || '.test_dict_01080', 'dim_id', x)
FROM (
        SELECT tuple(toInt64(materialize(0))) AS x
    );

SELECT dictGetString('placeholder' || '.test_dict_01080', 'dim_id', x)
FROM (
        SELECT tuple(toInt64(materialize(1))) AS x
    );

DROP DICTIONARY CLICKHOUSE_DATABASE.test_dict_01080;

DROP TABLE CLICKHOUSE_DATABASE.test_table_01080;