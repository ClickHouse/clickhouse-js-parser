CREATE TABLE users
(
    uid Int16,
    name String,
    age Int16,
    v Array(Int16) ALIAS arrayMap((x -> age), array(name))
)
ENGINE = Memory();

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

SELECT *
FROM users
FORMAT Null;

CREATE TABLE out1
(
    id UInt64,
    j JSON,
    name Array(UInt32) ALIAS arrayMap((x -> toUInt32(x)), JSONAllPaths(j)),
    value Array(Array(UInt32)) ALIAS arrayMap((x -> JSONExtract(CAST(j AS String), indexOf(name, x), 'Array(UInt32)')), name)
)
ORDER BY id;

INSERT INTO out1 SELECT
    42,
    '{"a" : 42}';

SELECT *
FROM out1
FORMAT Null;