DROP TABLE IF EXISTS decimal;

CREATE TABLE IF NOT EXISTS decimal
(
    a DEC(9, 3),
    b DEC(18, 9),
    c DEC(38, 18)
)
ENGINE = Memory();

INSERT INTO decimal (a, b, c);

INSERT INTO decimal (a, b, c) FORMAT JSONEachRow;

INSERT INTO decimal (a, b, c) FORMAT CSV;

SELECT *
FROM decimal
ORDER BY b DESC
FORMAT CSV;

SELECT *
FROM decimal
ORDER BY c ASC
FORMAT TabSeparated;