DROP TABLE IF EXISTS raw_data;

DROP TABLE IF EXISTS raw_temporary_data;

DROP TABLE IF EXISTS parameterized_view_one_param;

DROP TABLE IF EXISTS parameterized_view_multiple_params;

DROP TABLE IF EXISTS parameterized_view_one_param_temporary;

DROP TABLE IF EXISTS parameterized_view_multiple_params_temporary;

SELECT '-----------------------------------------';

CREATE TABLE raw_data
(
    id UInt32,
    data String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE VIEW parameterized_view_one_param
AS
SELECT *
FROM raw_data
WHERE id = 0;

SELECT
    name,
    engine,
    parameterized_view_parameters
FROM `system`.tables
WHERE database = currentDatabase()
    AND name = 'parameterized_view_one_param';

CREATE VIEW parameterized_view_multiple_params
AS
SELECT *
FROM raw_data
WHERE id >= 0
    AND id <= 0;

SELECT
    name,
    engine,
    parameterized_view_parameters
FROM `system`.tables
WHERE database = currentDatabase()
    AND name = 'parameterized_view_multiple_params';

CREATE TEMPORARY TABLE raw_temporary_data
(
    id UInt32,
    data String
);

CREATE TEMPORARY TABLE alter_test
(
    CounterID UInt32,
    StartDate Date,
    UserID UInt32,
    VisitID UInt32
);

CREATE VIEW parameterized_view_one_param_temporary
AS
SELECT *
FROM raw_data
WHERE id = 0;

SELECT
    name,
    engine,
    parameterized_view_parameters
FROM `system`.tables
WHERE database = currentDatabase()
    AND name = 'parameterized_view_one_param_temporary';

CREATE VIEW parameterized_view_multiple_params_temporary
AS
SELECT *
FROM raw_data
WHERE (CounterID >= 0
    AND CounterID <= 0)
    AND (StartDate >= '2020-01-01'
    AND StartDate <= 0)
    AND UserId = 0;

SELECT
    name,
    engine,
    parameterized_view_parameters
FROM `system`.tables
WHERE database = currentDatabase()
    AND name = 'parameterized_view_multiple_params_temporary';

DROP TABLE parameterized_view_one_param;

DROP TABLE parameterized_view_multiple_params;

DROP TABLE parameterized_view_one_param_temporary;

DROP TABLE parameterized_view_multiple_params_temporary;

DROP TABLE raw_temporary_data;

DROP TABLE raw_data;