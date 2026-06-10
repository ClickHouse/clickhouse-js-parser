DROP TABLE IF EXISTS array_element_test;

CREATE TABLE array_element_test
(
    arr Array(Int32),
    id Int32
)
ENGINE = Memory();

INSERT INTO array_element_test;

SELECT arr[id]
FROM array_element_test;

CREATE TABLE array_element_test
(
    arr Array(Int32),
    id UInt32
)
ENGINE = Memory();

INSERT INTO array_element_test;

CREATE TABLE array_element_test
(
    arr Array(String),
    id Int32
)
ENGINE = Memory();

INSERT INTO array_element_test;

CREATE TABLE array_element_test
(
    arr Array(String),
    id UInt32
)
ENGINE = Memory();

INSERT INTO array_element_test;

CREATE TABLE array_element_test
(
    id UInt32
)
ENGINE = Memory();

INSERT INTO array_element_test;

SELECT
    [1, 2, 3] AS arr,
    arr[id]
FROM array_element_test;

CREATE TABLE array_element_test
(
    id Int32
)
ENGINE = Memory();

INSERT INTO array_element_test;

DROP TABLE array_element_test;