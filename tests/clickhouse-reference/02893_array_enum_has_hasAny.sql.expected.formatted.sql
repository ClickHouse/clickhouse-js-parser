DROP TABLE IF EXISTS v;

DROP TABLE IF EXISTS v2;

CREATE TABLE IF NOT EXISTS v
(
    value Array(Enum('foo' = 1, 'bar' = 2))
)
ENGINE = Memory();

INSERT INTO v;

SELECT *
FROM v
WHERE has(value, 'foo')
ORDER BY value ASC;

SELECT *
FROM v
WHERE hasAny(value, ['bar'])
ORDER BY value ASC;

SELECT *
FROM v
WHERE has(value, 'x')
ORDER BY value ASC;

CREATE TABLE IF NOT EXISTS v2
(
    value Array(Array(Nullable(Enum('foo' = 1, 'bar' = 2))))
)
ENGINE = Memory();

INSERT INTO v2;

SELECT *
FROM v2
WHERE has(value, ['foo'])
ORDER BY value ASC;

SELECT *
FROM v2
WHERE has(value, [NULL])
ORDER BY value ASC;

DROP TABLE v;

DROP TABLE v2;