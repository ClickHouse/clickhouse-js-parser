DROP TABLE IF EXISTS where_qualified;

CREATE TABLE where_qualified
(
    a UInt32,
    b UInt8
)
ENGINE = Memory();

INSERT INTO where_qualified;

INSERT INTO where_qualified;

SELECT a
FROM where_qualified
WHERE where_qualified.b;

DROP TABLE where_qualified;