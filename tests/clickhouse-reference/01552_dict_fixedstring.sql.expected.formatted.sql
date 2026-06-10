DROP TABLE IF EXISTS src;

CREATE TABLE src
(
    k UInt64,
    s FixedString(11)
)
ENGINE = Memory();

INSERT INTO src;

DROP DICTIONARY IF EXISTS dict;

CREATE DICTIONARY dict
(
    k UInt64,
    s String
)
PRIMARY KEY k
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER default TABLE 'src'))
LIFETIME(MIN 10 MAX 10)
LAYOUT(FLAT());

SELECT dictGet(currentDatabase() || '.dict', 's', number)
FROM numbers(2);

DROP DICTIONARY dict;

DROP TABLE src;