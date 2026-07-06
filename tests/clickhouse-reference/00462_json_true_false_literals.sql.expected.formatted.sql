-- Tags: no-fasttest
DROP TABLE IF EXISTS json;

CREATE TABLE json
(
    x UInt8,
    title String
)
ENGINE = Memory();

INSERT INTO json FORMAT JSONEachRow;

SELECT *
FROM json
ORDER BY title ASC;