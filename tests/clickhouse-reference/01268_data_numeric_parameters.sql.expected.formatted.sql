DROP TABLE IF EXISTS ints;

DROP TABLE IF EXISTS floats;

DROP TABLE IF EXISTS strings;

CREATE TABLE ints
(
    a TINYINT,
    b TINYINT,
    c SMALLINT,
    d SMALLINT,
    e INT,
    f INT,
    g BIGINT,
    h BIGINT
)
ENGINE = Memory();

INSERT INTO ints;

SELECT
    toTypeName(a),
    toTypeName(b),
    toTypeName(c),
    toTypeName(d),
    toTypeName(e),
    toTypeName(f),
    toTypeName(g),
    toTypeName(h)
FROM ints;

CREATE TABLE floats
(
    a FLOAT,
    b FLOAT(12),
    c FLOAT(15, 22),
    d DOUBLE,
    e DOUBLE(12),
    f DOUBLE(4, 18)
)
ENGINE = Memory();

INSERT INTO floats;

SELECT
    toTypeName(a),
    toTypeName(b),
    toTypeName(c),
    toTypeName(d),
    toTypeName(e),
    toTypeName(f)
FROM floats;

CREATE TABLE strings
(
    a VARCHAR,
    b VARCHAR(11)
)
ENGINE = Memory();

INSERT INTO strings;

SELECT
    toTypeName(a),
    toTypeName(b)
FROM strings;

DROP TABLE floats;

DROP TABLE ints;

DROP TABLE strings;