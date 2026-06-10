-- Tags: log-engine
-- disable timezone randomization since otherwise TTL may fail at particular datetime, i.e.:
--
--     SELECT
--         now(),
--         toDate(toTimeZone(now(), 'America/Mazatlan')),
--         today()
--
--     ┌───────────────now()─┬─toDate(toTimeZone(now(), 'America/Mazatlan'))─┬────today()─┐
--     │ 2023-07-24 06:24:06 │                                    2023-07-23 │ 2023-07-24 │
--     └─────────────────────┴───────────────────────────────────────────────┴────────────┘
SET session_timezone = '';

SET allow_suspicious_ttl_expressions = '1';

DROP TABLE IF EXISTS ttl_00933_1;

-- Column TTL works only with wide parts, because it's very expensive to apply it for compact parts
CREATE TABLE ttl_00933_1
(
    d DateTime,
    a Int TTL d + toIntervalSecond(1),
    b Int TTL d + toIntervalSecond(1)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toMinute(d)
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO ttl_00933_1;

INSERT INTO ttl_00933_1;

SELECT sleep(1.1)
FORMAT Null;

OPTIMIZE TABLE ttl_00933_1 FINAL;

SELECT
    a,
    b
FROM ttl_00933_1;

CREATE TABLE ttl_00933_1
(
    d DateTime,
    a Int,
    b Int
)
ENGINE = MergeTree()
ORDER BY toDate(d)
PARTITION BY tuple()
TTL d + toIntervalSecond(1)
SETTINGS remove_empty_parts = '0';

INSERT INTO ttl_00933_1;

CREATE TABLE ttl_00933_1
(
    d DateTime,
    a Int TTL d + toIntervalDay(1)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toDayOfMonth(d)
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO ttl_00933_1;

INSERT INTO ttl_00933_1;

INSERT INTO ttl_00933_1;

SELECT *
FROM ttl_00933_1
ORDER BY d ASC;

CREATE TABLE ttl_00933_1
(
    d DateTime,
    a Int
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple()
TTL d + toIntervalDay(1)
SETTINGS remove_empty_parts = '0';

INSERT INTO ttl_00933_1;

CREATE TABLE ttl_00933_1
(
    d Date,
    a Int
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY toDayOfMonth(d)
TTL d + toIntervalDay(1)
SETTINGS remove_empty_parts = '0';

INSERT INTO ttl_00933_1;

INSERT INTO ttl_00933_1;

CREATE TABLE ttl_00933_1
(
    b Int,
    a Int TTL '2000-10-10 00:00:00'::DateTime
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple()
SETTINGS min_bytes_for_wide_part = '0';

SHOW CREATE TABLE ttl_00933_1;

INSERT INTO ttl_00933_1;

SELECT *
FROM ttl_00933_1;

CREATE TABLE ttl_00933_1
(
    b Int,
    a Int TTL '2100-10-10 00:00:00'::DateTime
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple()
SETTINGS min_bytes_for_wide_part = '0';

CREATE TABLE ttl_00933_1
(
    b Int,
    a Int TTL '2000-10-10'::Date
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple()
SETTINGS min_bytes_for_wide_part = '0';

CREATE TABLE ttl_00933_1
(
    b Int,
    a Int TTL '2100-10-10'::Date
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple()
SETTINGS min_bytes_for_wide_part = '0';

SET send_logs_level = 'fatal';

CREATE TABLE ttl_00933_1
(
    d DateTime TTL d
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toSecond(d); -- { serverError ILLEGAL_COLUMN}

CREATE TABLE ttl_00933_1
(
    d DateTime,
    a Int TTL d
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY toSecond(d); -- { serverError ILLEGAL_COLUMN}

CREATE TABLE ttl_00933_1
(
    d DateTime,
    a Int TTL 2 + 2
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toSecond(d); -- { serverError BAD_TTL_EXPRESSION }

CREATE TABLE ttl_00933_1
(
    d DateTime,
    a Int TTL d - d
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toSecond(d); -- { serverError BAD_TTL_EXPRESSION }

CREATE TABLE ttl_00933_1
(
    d DateTime,
    a Int TTL d + toIntervalDay(1)
)
ENGINE = Log(); -- { serverError BAD_ARGUMENTS }

CREATE TABLE ttl_00933_1
(
    d DateTime,
    a Int
)
ENGINE = Log()
TTL d + toIntervalDay(1); -- { serverError BAD_ARGUMENTS }