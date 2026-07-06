-- Tags: shard
SET optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '2';

CREATE TEMPORARY TABLE data
(
    id UInt64
)
ENGINE = Memory() AS
WITH [0, 1, 127, 128, 255, 32767, 32768, 65535, 2147483647, 2147483648, 4294967295, 9223372036854775807, 9223372036854775808, 18446744073709551615] AS values

SELECT arrayJoin(values) AS id;

-- { echoOn }
-- Int8, Int8
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt8(id) AS id
    FROM data), toInt8(id))
WHERE id IN (0, 1, 127)
ORDER BY
    _shard_num ASC,
    id ASC;

-- Int8, UInt8
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt8(id) AS id
    FROM data), toUInt8(id))
WHERE id IN (0, 1, 127)
ORDER BY
    _shard_num ASC,
    id ASC;

-- UInt8, UInt8
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toUInt8(id) AS id
    FROM data), toUInt8(id))
WHERE id IN (0, 1, 127, 128, 255)
ORDER BY
    _shard_num ASC,
    id ASC;

-- UInt8, Int8
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toUInt8(id) AS id
    FROM data), toInt8(id))
WHERE id IN (0, 1, 127, 128, 255)
ORDER BY
    _shard_num ASC,
    id ASC;

-- Int16, Int16
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt16(id) AS id
    FROM data), toInt16(id))
WHERE id IN (0, 1, 32767)
ORDER BY
    _shard_num ASC,
    id ASC;

-- Int16, UInt16
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt16(id) AS id
    FROM data), toUInt16(id))
WHERE id IN (0, 1, 32767)
ORDER BY
    _shard_num ASC,
    id ASC;

-- UInt16, UInt16
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toUInt16(id) AS id
    FROM data), toUInt16(id))
WHERE id IN (0, 1, 32767, 32768, 65535)
ORDER BY
    _shard_num ASC,
    id ASC;

-- UInt16, Int16
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toUInt16(id) AS id
    FROM data), toInt16(id))
WHERE id IN (0, 1, 32767, 32768, 65535)
ORDER BY
    _shard_num ASC,
    id ASC;

-- Int32, Int32
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt32(id) AS id
    FROM data), toInt32(id))
WHERE id IN (0, 1, 2147483647)
ORDER BY
    _shard_num ASC,
    id ASC;

-- Int32, UInt32
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt32(id) AS id
    FROM data), toUInt32(id))
WHERE id IN (0, 1, 2147483647)
ORDER BY
    _shard_num ASC,
    id ASC;

-- UInt32, UInt32
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toUInt32(id) AS id
    FROM data), toUInt32(id))
WHERE id IN (0, 1, 2147483647, 2147483648, 4294967295)
ORDER BY
    _shard_num ASC,
    id ASC;

-- UInt32, Int32
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toUInt32(id) AS id
    FROM data), toInt32(id))
WHERE id IN (0, 1, 2147483647, 2147483648, 4294967295)
ORDER BY
    _shard_num ASC,
    id ASC;

-- Int64, Int64
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt64(id) AS id
    FROM data), toInt64(id))
WHERE id IN (0, 1, 9223372036854775807)
ORDER BY
    _shard_num ASC,
    id ASC;

-- Int64, UInt64
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt64(id) AS id
    FROM data), toUInt64(id))
WHERE id IN (0, 1, 9223372036854775807)
ORDER BY
    _shard_num ASC,
    id ASC;

-- UInt64, UInt64
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toUInt64(id) AS id
    FROM data), toUInt64(id))
WHERE id IN (0, 1, 9223372036854775807, 9223372036854775808, 18446744073709551615)
ORDER BY
    _shard_num ASC,
    id ASC;

-- UInt64, Int64
SELECT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toUInt64(id) AS id
    FROM data), toInt64(id))
WHERE id IN (0, 1, 9223372036854775807, 9223372036854775808, 18446744073709551615)
ORDER BY
    _shard_num ASC,
    id ASC;

-- modulo(Int8)
SELECT DISTINCT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt16(id) AS id
    FROM data), toInt8(id) % 255)
WHERE id IN (-1)
ORDER BY
    _shard_num ASC,
    id ASC;

-- modulo(UInt8)
SELECT DISTINCT
    _shard_num,
    *
FROM remote('127.{1..4}', view(    SELECT toInt16(id) AS id
    FROM data), toUInt8(id) % 255)
WHERE id IN (-1)
ORDER BY
    _shard_num ASC,
    id ASC;

-- { echoOff }
-- those two had been reported initially by amosbird:
-- (the problem is that murmurHash3_32() returns different value to toInt64(1) and toUInt64(1))
---- error for local node
SELECT *
FROM remote('127.{1..4}', view(    SELECT number AS id
    FROM numbers(0)), bitAnd(murmurHash3_32(id), 2147483647))
WHERE id IN (2, 3);

---- error for remote node
SELECT *
FROM remote('127.{1..8}', view(    SELECT number AS id
    FROM numbers(0)), bitAnd(murmurHash3_32(id), 2147483647))
WHERE id IN (2, 3);