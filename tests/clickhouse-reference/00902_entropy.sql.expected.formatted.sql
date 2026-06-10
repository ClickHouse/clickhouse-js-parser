DROP TABLE IF EXISTS defaults;

CREATE TABLE IF NOT EXISTS defaults
(
    vals String
)
ENGINE = Memory();

INSERT INTO defaults;

SELECT val < 1.5
    AND val > 1.459
FROM (
        SELECT entropy(vals) AS val
        FROM defaults
    );

CREATE TABLE IF NOT EXISTS defaults
(
    vals UInt64
)
ENGINE = Memory();

INSERT INTO defaults;

SELECT val < 2.4
    AND val > 2.3393
FROM (
        SELECT entropy(vals) AS val
        FROM defaults
    );

CREATE TABLE IF NOT EXISTS defaults
(
    vals UInt32
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS defaults
(
    vals Int32
)
ENGINE = Memory();

INSERT INTO defaults;

CREATE TABLE IF NOT EXISTS defaults
(
    vals DateTime
)
ENGINE = Memory();

INSERT INTO defaults;

SELECT val < 2.189
    AND val > 2.1886
FROM (
        SELECT entropy(vals) AS val
        FROM defaults
    );

DROP TABLE defaults;