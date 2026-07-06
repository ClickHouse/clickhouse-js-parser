DROP TABLE IF EXISTS `distinct`;

CREATE TABLE `distinct`
(
    Num UInt32,
    Name String
)
ENGINE = Memory();

INSERT INTO `distinct` (Num, Name);

INSERT INTO `distinct` (Num, Name);

INSERT INTO `distinct` (Num, Name);

INSERT INTO `distinct` (Num, Name);

INSERT INTO `distinct` (Num, Name);

INSERT INTO `distinct` (Num, Name);

INSERT INTO `distinct` (Num, Name);

-- { echoOn }
-- String field
SELECT Name
FROM (
        SELECT DISTINCT Name
        FROM `distinct`
    )
ORDER BY Name ASC;

-- Num field
SELECT Num
FROM (
        SELECT DISTINCT Num
        FROM `distinct`
    )
ORDER BY Num ASC;

-- all const columns
SELECT DISTINCT
    1 AS a,
    2 AS b
FROM `distinct`;