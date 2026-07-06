DROP TABLE IF EXISTS table_pv;

CREATE TABLE table_pv
(
    id Int32,
    timestamp_field DateTime
)
ENGINE = Memory();

INSERT INTO table_pv;

INSERT INTO table_pv;

CREATE VIEW pv
AS
SELECT *
FROM table_pv
WHERE timestamp_field > '2020-01-01 00:00:00';

SELECT *
FROM pv(timestamp_param = toDateTime('2024-04-01 00:00:01'));

SELECT *
FROM pv(timestamp_param = toDateTime('2024-040')); -- { serverError CANNOT_PARSE_DATETIME }

DROP TABLE table_pv;