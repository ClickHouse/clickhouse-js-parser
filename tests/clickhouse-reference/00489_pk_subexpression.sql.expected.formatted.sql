DROP TABLE IF EXISTS pk;

SET allow_deprecated_syntax_for_merge_tree = '1';

-- NOTE: here the timezone is pinned to UTC, to avoid issues with "partial
-- timezones" (timezones that does not starts from 00:00), like
-- Africa/Monrovia, for which toStartOfMinute(0) and toStartOfMinute(59) can
-- give different values:
--
--     SELECT
--         toDateTime(0, 'Africa/Monrovia') AS sec0,
--         toDateTime(59, 'Africa/Monrovia') AS sec59
--
--     ┌────────────────sec0─┬───────────────sec59─┐
--     │ 1969-12-31 23:15:30 │ 1969-12-31 23:16:29 │
--     └─────────────────────┴─────────────────────┘
--
CREATE TABLE pk
(
    d Date DEFAULT '2000-01-01',
    x DateTime,
    y UInt64,
    z UInt64
)
ENGINE = MergeTree(d, (toStartOfMinute(x, 'UTC'), y, z), 1);

INSERT INTO pk (x, y, z);

SET min_insert_block_size_rows = '0', min_insert_block_size_bytes = '0';

SET max_block_size = '1';

-- Test inferred limit
SET max_rows_to_read = '5';

SELECT
    toUInt32(x),
    y,
    z
FROM pk
WHERE x >= toDateTime(0)
    AND x <= toDateTime(59);

SET max_rows_to_read = '9';

SELECT
    toUInt32(x),
    y,
    z
FROM pk
WHERE x >= toDateTime(120)
    AND x <= toDateTime(240);

SELECT
    toUInt32(x),
    y,
    z
FROM pk
WHERE x = toDateTime(1);

-- Index works on interval 00:01:00 - 00:01:59
SET max_rows_to_read = '4';

SELECT
    toUInt32(x),
    y,
    z
FROM pk
WHERE (x >= toDateTime(60)
    AND x <= toDateTime(119))
    AND y = 11;

SELECT
    toUInt32(x),
    y,
    z
FROM pk
WHERE (x >= toDateTime(60)
    AND x <= toDateTime(120))
    AND y = 11;

DROP TABLE pk;