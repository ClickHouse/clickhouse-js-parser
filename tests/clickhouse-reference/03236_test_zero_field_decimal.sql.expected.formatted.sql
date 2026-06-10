-- Tags: no-parallel
DROP TABLE IF EXISTS users_03236_zero;

CREATE TABLE users_03236_zero
(
    uid Int16,
    name String,
    num Int16
)
ENGINE = Memory();

INSERT INTO users_03236_zero;

INSERT INTO users_03236_zero;

INSERT INTO users_03236_zero;

SELECT sum(num / toDecimal256(1000, 18))
FROM users_03236_zero;