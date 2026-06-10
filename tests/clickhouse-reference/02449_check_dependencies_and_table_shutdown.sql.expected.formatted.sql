DROP TABLE IF EXISTS table;

DROP DICTIONARY IF EXISTS dict;

DROP TABLE IF EXISTS view;

CREATE TABLE view
(
    id UInt32,
    value String
)
ENGINE = ReplicatedMergeTree('/test/2449/{database}', '1')
ORDER BY id;

INSERT INTO view;

CREATE DICTIONARY dict
(
    id UInt32,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB currentDatabase() TABLE 'view'))
LIFETIME(MIN 600 MAX 600)
LAYOUT(HASHED());

SHOW CREATE TABLE dict;

CREATE TABLE table
(
    col MATERIALIZED dictGet(currentDatabase() || '.dict', 'value', toUInt32(1)),
    phys Int
)
ENGINE = MergeTree()
ORDER BY tuple();

SHOW CREATE TABLE table;

SELECT *
FROM dictionary('dict');

DROP TABLE view; -- {serverError HAVE_DEPENDENT_OBJECTS}

-- check that table is not readonly
INSERT INTO view;

DROP DICTIONARY dict; -- {serverError HAVE_DEPENDENT_OBJECTS}

SYSTEM RELOAD DICTIONARY dict;

SELECT *
FROM dictionary('dict')
ORDER BY id ASC;

DROP TABLE table;