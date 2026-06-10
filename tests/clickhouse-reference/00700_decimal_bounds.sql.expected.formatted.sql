DROP TABLE IF EXISTS decimal;

CREATE TABLE IF NOT EXISTS decimal
(
    x DECIMAL(10, -2)
)
ENGINE = Memory(); -- { serverError ARGUMENT_OUT_OF_BOUND }

CREATE TABLE IF NOT EXISTS decimal
(
    x DECIMAL(10, 15)
)
ENGINE = Memory(); -- { serverError ARGUMENT_OUT_OF_BOUND }

CREATE TABLE IF NOT EXISTS decimal
(
    x DECIMAL(0, 0)
)
ENGINE = Memory(); -- { serverError ARGUMENT_OUT_OF_BOUND }

CREATE TABLE IF NOT EXISTS decimal
(
    a DECIMAL(9, 0),
    b DECIMAL(18, 0),
    c DECIMAL(38, 0),
    d DECIMAL(9, 9),
    e DECIMAL(18, 18),
    f DECIMAL(38, 38),
    g Decimal(9, 5),
    h decimal(18, 9),
    i deciMAL(38, 18),
    j DECIMAL(1, 0)
)
ENGINE = Memory();

INSERT INTO decimal (a); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (a); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (b); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (b); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (c); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (c); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (d); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (d); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (e); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (e); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (f); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (f); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (g); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (g); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (h); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (h); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (i); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (i); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (j); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (j); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (a);

INSERT INTO decimal (a);

INSERT INTO decimal (b);

INSERT INTO decimal (b);

INSERT INTO decimal (c);

INSERT INTO decimal (c);

INSERT INTO decimal (d);

INSERT INTO decimal (d);

INSERT INTO decimal (e);

INSERT INTO decimal (e);

INSERT INTO decimal (f);

INSERT INTO decimal (f);

INSERT INTO decimal (g);

INSERT INTO decimal (g);

INSERT INTO decimal (h);

INSERT INTO decimal (h);

INSERT INTO decimal (i);

INSERT INTO decimal (i);

INSERT INTO decimal (j);

INSERT INTO decimal (j);

INSERT INTO decimal (a, b, d, g);

INSERT INTO decimal (a, b, d, g);

INSERT INTO decimal (c);

INSERT INTO decimal (c);

INSERT INTO decimal (f);

INSERT INTO decimal (f);

INSERT INTO decimal (e, h);

INSERT INTO decimal (e, h);

INSERT INTO decimal (i);

INSERT INTO decimal (i);

INSERT INTO decimal (a, b, c, d, g, j, h);

INSERT INTO decimal (a, b, c, d, g, j, h);

INSERT INTO decimal (e, f);

INSERT INTO decimal (e, f);

INSERT INTO decimal (i);

INSERT INTO decimal (i);

INSERT INTO decimal (a, b, c, d, e, f, g, h, i, j);

INSERT INTO decimal (a, b, c, d, e, f, g, h, i, j);

INSERT INTO decimal (a, b, c, d, e, f, g, h, i, j);

INSERT INTO decimal (a, b, c, d, e, f, g, h, i, j);

INSERT INTO decimal (a, b, g);

INSERT INTO decimal (a); -- { error CANNOT_PARSE_TEXT }

INSERT INTO decimal (a); -- { error CANNOT_PARSE_TEXT }

INSERT INTO decimal (a, b, c, d, e, f);

INSERT INTO decimal (a, b, c, d, e, f);

INSERT INTO decimal (a, b, c, d, e, f); -- { error ARGUMENT_OUT_OF_BOUND }

INSERT INTO decimal (a, b, c, d, e, f); -- { error ARGUMENT_OUT_OF_BOUND }

SELECT *
FROM decimal
ORDER BY
    a ASC,
    b ASC,
    c ASC,
    d ASC,
    e ASC,
    f ASC,
    g ASC,
    h ASC,
    i ASC,
    j ASC;