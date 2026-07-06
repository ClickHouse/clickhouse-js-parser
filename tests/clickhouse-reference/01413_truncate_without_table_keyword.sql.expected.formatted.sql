DROP TABLE IF EXISTS truncate_test;

CREATE TABLE truncate_test
(
    uint8 UInt8
)
ENGINE = Log();

INSERT INTO truncate_test;

SELECT *
FROM truncate_test
ORDER BY uint8 ASC;

TRUNCATE TABLE truncate_test;

DROP TABLE truncate_test;