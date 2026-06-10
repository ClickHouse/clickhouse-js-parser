DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers
(
    FirstName Nullable(String),
    LastName String,
    Occupation String,
    Education String,
    Age Nullable(UInt8)
)
ENGINE = Memory();

INSERT INTO Customers;

SELECT '-- test create table --';

;

DROP TABLE IF EXISTS kql_table1;

SELECT LastName
FROM kql_table1
LIMIT 1;

DROP TABLE IF EXISTS kql_table2;

CREATE TABLE kql_table2
(
    FirstName Nullable(String),
    LastName String,
    Age Nullable(UInt8)
)
ENGINE = Memory();

SELECT *
FROM kql_table2
LIMIT 1;