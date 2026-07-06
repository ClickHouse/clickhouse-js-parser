DROP TABLE IF EXISTS null_00117;

CREATE TABLE null_00117
(
    a Array(UInt64),
    b Array(String),
    c Array(Array(Date))
)
ENGINE = Memory();

INSERT INTO null_00117 (a);

INSERT INTO null_00117 (b);

INSERT INTO null_00117 (c);

SELECT
    a,
    b,
    c
FROM null_00117
ORDER BY
    a ASC,
    b ASC,
    c ASC;

DROP TABLE null_00117;