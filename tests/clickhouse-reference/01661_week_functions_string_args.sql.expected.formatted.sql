-- Tests that functions `toDayOfWeek()`, 'toWeek()' and 'toYearWeek()' accepts a date given as string (for compatibility with MySQL)
SELECT '-- Constant argument';

SELECT
    toDayOfWeek(toDateTime('2016-06-15 23:00:00')),
    toDayOfWeek('2016-06-15'),
    toDayOfWeek('2016-06-15 23:00:00'),
    toDayOfWeek('2016-06-15 23:00:00.123456');

SELECT
    toWeek(toDateTime('2016-06-15 23:00:00')),
    toWeek('2016-06-15'),
    toWeek('2016-06-15 23:00:00'),
    toWeek('2016-06-15 23:00:00.123456');

SELECT
    toYearWeek(toDateTime('2016-06-15 23:00:00')),
    toYearWeek('2016-06-15'),
    toYearWeek('2016-06-15 23:00:00'),
    toYearWeek('2016-06-15 23:00:00.123456');

SELECT toDayOfWeek('invalid'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT toWeek('invalid'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT toYearWeek('invalid'); -- { serverError CANNOT_PARSE_DATETIME }

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    d Date,
    dt DateTime('UTC'),
    dt64 DateTime64(6, 'UTC'),
    str_d String,
    str_dt String,
    str_dt64 String,
    invalid String
)
ENGINE = MergeTree()
ORDER BY dt;

INSERT INTO tab;

INSERT INTO tab;

INSERT INTO tab;

INSERT INTO tab;

SELECT
    toDayOfWeek(d),
    toDayOfWeek(dt),
    toDayOfWeek(dt64),
    toDayOfWeek(str_d),
    toDayOfWeek(str_dt),
    toDayOfWeek(str_dt64)
FROM tab
ORDER BY d ASC;

SELECT
    toWeek(d),
    toWeek(dt),
    toWeek(dt64),
    toWeek(str_d),
    toWeek(str_dt),
    toWeek(str_dt64)
FROM tab
ORDER BY d ASC;

SELECT
    toYearWeek(d),
    toYearWeek(dt),
    toYearWeek(dt64),
    toYearWeek(str_d),
    toYearWeek(str_dt),
    toYearWeek(str_dt64)
FROM tab
ORDER BY d ASC;

SELECT toDayOfWeek(invalid)
FROM tab; -- { serverError CANNOT_PARSE_DATETIME }

SELECT toWeek(invalid)
FROM tab; -- { serverError CANNOT_PARSE_DATETIME }

SELECT toYearWeek(invalid)
FROM tab; -- { serverError CANNOT_PARSE_DATETIME }

DROP TABLE tab;