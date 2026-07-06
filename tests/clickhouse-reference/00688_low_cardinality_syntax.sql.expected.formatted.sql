SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS lc_str_0;

DROP TABLE IF EXISTS lc_str_1;

DROP TABLE IF EXISTS lc_null_str_0;

DROP TABLE IF EXISTS lc_null_str_1;

DROP TABLE IF EXISTS lc_int8_0;

DROP TABLE IF EXISTS lc_int8_1;

DROP TABLE IF EXISTS lc_null_int8_0;

DROP TABLE IF EXISTS lc_null_int8_1;

DROP TABLE IF EXISTS lc_fix_str_0;

DROP TABLE IF EXISTS lc_fix_str_1;

DROP TABLE IF EXISTS lc_null_fix_str_0;

DROP TABLE IF EXISTS lc_null_fix_str_1;

CREATE TABLE lc_str_0
(
    str LowCardinality(String)
)
ENGINE = Memory();

CREATE TABLE lc_null_str_0
(
    str LowCardinality(Nullable(String))
)
ENGINE = Memory();

CREATE TABLE lc_int8_0
(
    val LowCardinality(Int8)
)
ENGINE = Memory();

CREATE TABLE lc_null_int8_0
(
    val LowCardinality(Nullable(Int8))
)
ENGINE = Memory();

CREATE TABLE lc_fix_str_0
(
    str LowCardinality(FixedString(2))
)
ENGINE = Memory();

CREATE TABLE lc_null_fix_str_0
(
    str LowCardinality(Nullable(FixedString(2)))
)
ENGINE = Memory();

INSERT INTO lc_str_0 SELECT 'a';

INSERT INTO lc_null_str_0 SELECT 'a';

INSERT INTO lc_int8_0 SELECT 1;

INSERT INTO lc_null_int8_0 SELECT 1;

INSERT INTO lc_fix_str_0 SELECT 'ab';

INSERT INTO lc_null_fix_str_0 SELECT 'ab';

SELECT str
FROM lc_str_0;

SELECT str
FROM lc_null_str_0;

SELECT val
FROM lc_int8_0;

SELECT val
FROM lc_null_int8_0;

SELECT str
FROM lc_fix_str_0;

SELECT str
FROM lc_null_fix_str_0;

SELECT
    toLowCardinality('a') AS s,
    toTypeName(s),
    toTypeName(length(s))
FROM `system`.one;

SELECT toLowCardinality('a') AS val
GROUP BY val
ORDER BY val ASC;

SELECT (toLowCardinality('a') AS val) || 'b'
GROUP BY val
ORDER BY val ASC;

SELECT toLowCardinality(z) AS val
FROM (
        SELECT arrayJoin(['c', 'd']) AS z
    )
GROUP BY val
ORDER BY val ASC;

SELECT (toLowCardinality(z) AS val) || 'b'
FROM (
        SELECT arrayJoin(['c', 'd']) AS z
    )
GROUP BY val
ORDER BY val ASC;

DROP TABLE IF EXISTS lc_str_uuid;

CREATE TABLE lc_str_uuid
(
    str1 String,
    str2 LowCardinality(String),
    str3 LowCardinality(String)
)
ENGINE = Memory();

SELECT
    toUUID(str1),
    toUUID(str2),
    toUUID(str3)
FROM lc_str_uuid;

SELECT
    toUUID(str1, '', NULL),
    toUUID(str2, '', NULL),
    toUUID(str3, '', NULL)
FROM lc_str_uuid;

INSERT INTO lc_str_uuid;