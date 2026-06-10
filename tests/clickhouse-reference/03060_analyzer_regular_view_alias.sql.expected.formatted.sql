-- https://github.com/ClickHouse/ClickHouse/issues/11068
SET enable_analyzer = '1';

CREATE TABLE vt
(
    datetime_value DateTime,
    value Float64
)
ENGINE = Memory();

CREATE VIEW computed_datum_hours
AS
SELECT
    toStartOfHour(b.datetime_value) AS datetime_desc,
    sum(b.value) AS value
FROM vt AS b
GROUP BY toStartOfHour(b.datetime_value);

SELECT
    toStartOfHour(b.datetime_value) AS datetime_desc,
    sum(b.value) AS value
FROM vt AS b
GROUP BY toStartOfHour(b.datetime_value);