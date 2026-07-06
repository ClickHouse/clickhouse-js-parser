-- Tags: replica
DROP TABLE IF EXISTS bad_arrays;

CREATE TABLE bad_arrays
(
    a Array(String),
    b Array(UInt8)
)
ENGINE = Memory();

INSERT INTO bad_arrays;

SELECT a
FROM
    bad_arrays
ARRAY JOIN b;

DROP TABLE bad_arrays;

CREATE TABLE bad_arrays
(
    a Array(String),
    b Array(String)
)
ENGINE = Memory();

INSERT INTO bad_arrays;

INSERT INTO bad_arrays;

SELECT
    a,
    b
FROM
    bad_arrays
ARRAY JOIN b;