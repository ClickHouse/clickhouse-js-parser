-- Tags: no-fasttest
DROP TABLE IF EXISTS json;

CREATE TABLE json
(
    x Enum8('browser' = 1, 'mobile' = 2),
    y String
)
ENGINE = Memory();

INSERT INTO json (y);

SELECT *
FROM json
ORDER BY y ASC;

INSERT INTO json (y) FORMAT JSONEachRow;

INSERT INTO json (x, y) FORMAT JSONEachRow;

DROP TABLE json;