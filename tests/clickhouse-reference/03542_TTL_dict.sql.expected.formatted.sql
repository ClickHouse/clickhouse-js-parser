DROP TABLE IF EXISTS ttl_dict;

DROP DICTIONARY IF EXISTS always_alive_ids_dict;

DROP TABLE IF EXISTS always_alive_ids;

CREATE TABLE always_alive_ids
(
    id UInt64
)
ENGINE = Memory();

INSERT INTO always_alive_ids;

CREATE DICTIONARY always_alive_ids_dict
(
    id UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'always_alive_ids'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

CREATE TABLE ttl_dict
(
    id UInt64,
    event_date Date
)
ENGINE = MergeTree()
ORDER BY id
TTL event_date + toIntervalMonth(1) WHERE NOT dictHas('placeholder' || '.always_alive_ids_dict', id);

INSERT INTO ttl_dict;

OPTIMIZE TABLE ttl_dict FINAL;

SELECT id
FROM ttl_dict
ORDER BY id ASC;