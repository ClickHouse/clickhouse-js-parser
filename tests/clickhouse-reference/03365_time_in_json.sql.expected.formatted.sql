-- Test Time and Time64 types in JSON
SET enable_time_time64_type = '1';

-- Clean up
DROP TABLE IF EXISTS json_time_test;

DROP TABLE IF EXISTS json_time64_test;

DROP TABLE IF EXISTS json_splits;

-- Time type in JSON
CREATE TABLE json_time_test
(
    json JSON(time_value Time, id String)
)
ENGINE = Memory();

INSERT INTO json_time_test;

INSERT INTO json_time_test;

INSERT INTO json_time_test;

SELECT
    json.time_value,
    json.id
FROM json_time_test
ORDER BY json.id ASC;

-- Time64 type in JSON
CREATE TABLE json_time64_test
(
    json JSON(time_value Time64(3), id String)
)
ENGINE = Memory();

INSERT INTO json_time64_test;

INSERT INTO json_time64_test;

INSERT INTO json_time64_test;

SELECT
    json.time_value,
    json.id
FROM json_time64_test
ORDER BY json.id ASC;

-- #82267
CREATE TABLE json_splits
(
    json JSON(`metric.moving_time` Time, id String)
)
ORDER BY json.id;

INSERT INTO json_splits;

INSERT INTO json_splits;

SELECT
    json.`metric.moving_time`,
    json.id
FROM json_splits
ORDER BY json.id ASC;