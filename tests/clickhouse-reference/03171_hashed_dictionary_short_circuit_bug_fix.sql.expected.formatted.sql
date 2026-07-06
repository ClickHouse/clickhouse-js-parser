CREATE TABLE x
(
    hash_id UInt64,
    user_result Decimal(3, 2)
)
ENGINE = Memory();

CREATE TABLE y
(
    hash_id UInt64,
    user_result DECIMAL(18, 6)
)
ENGINE = Memory();

INSERT INTO x;

INSERT INTO y;

CREATE DICTIONARY d1
(
    hash_id UInt64,
    user_result Decimal(3, 2)
)
PRIMARY KEY hash_id
SOURCE(clickhouse(TABLE 'x'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT
    hash_id,
    dictGetOrDefault(d1, 'user_result', toUInt64(hash_id), toFloat64(user_result)),
    dictGet(d1, 'user_result', toUInt64(hash_id))
FROM y;

CREATE DICTIONARY d2
(
    hash_id UInt64,
    user_result Decimal(3, 2)
)
PRIMARY KEY hash_id
SOURCE(clickhouse(TABLE 'x'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED_ARRAY());

SELECT
    hash_id,
    dictGetOrDefault(d2, 'user_result', toUInt64(hash_id), toFloat64(user_result)),
    dictGet(d2, 'user_result', toUInt64(hash_id))
FROM y;