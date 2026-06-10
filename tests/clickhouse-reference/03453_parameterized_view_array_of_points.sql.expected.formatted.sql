DROP TABLE IF EXISTS point_test, point_test_parameterized, point_test_parameterized2;

CREATE TABLE point_test
(
    name String,
    coord Point
)
ENGINE = Memory();

INSERT INTO point_test;

CREATE VIEW point_test_parameterized
AS
SELECT *
FROM point_test
WHERE coord = tuple();

SELECT *
FROM point_test_parameterized(point = (0, 0));

CREATE VIEW point_test_parameterized2
AS
SELECT *
FROM point_test
WHERE coord IN ([]);

SELECT *
FROM point_test_parameterized2(point = [(0, 0)]);

DROP TABLE point_test, point_test_parameterized, point_test_parameterized2;