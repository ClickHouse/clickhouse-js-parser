DROP TABLE IF EXISTS orin_test;

CREATE TABLE orin_test
(
    c1 Int32
)
ENGINE = Memory();

INSERT INTO orin_test;

SELECT minus(c1 = 1
    OR c1 = 2
    OR c1 = 3, c1 = 5)
FROM orin_test;

DROP TABLE orin_test;