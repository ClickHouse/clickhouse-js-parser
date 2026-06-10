DROP TABLE IF EXISTS testView;

DROP TABLE IF EXISTS testTable;

CREATE TABLE IF NOT EXISTS testTable
(
    A LowCardinality(String),
    B Int64
)
ENGINE = MergeTree()
ORDER BY A;

INSERT INTO testTable;

CREATE VIEW testView
AS
SELECT
    A AS ALow, -- like account
    B
FROM testTable;

SELECT CAST(ALow AS String) AS AStr
FROM testView
GROUP BY AStr
ORDER BY AStr ASC;

DROP TABLE testTable;

CREATE TABLE IF NOT EXISTS testTable
(
    A String,
    B Int64
)
ENGINE = MergeTree()
ORDER BY A;