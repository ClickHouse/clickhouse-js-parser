DROP TABLE IF EXISTS prewhere_alias;

CREATE TABLE prewhere_alias
(
    a UInt8,
    b Int32,
    c UInt8 ALIAS a,
    d Int64 ALIAS b + 1,
    e Int32 ALIAS a + b
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO prewhere_alias;

SELECT a
FROM prewhere_alias
PREWHERE a = 1;

SELECT b
FROM prewhere_alias
PREWHERE a = 1;

SELECT c
FROM prewhere_alias
PREWHERE a = 1;

SELECT d
FROM prewhere_alias
PREWHERE a = 1;

SELECT a
FROM prewhere_alias
PREWHERE b = 1;

SELECT b
FROM prewhere_alias
PREWHERE b = 1;

SELECT c
FROM prewhere_alias
PREWHERE b = 1;

SELECT d
FROM prewhere_alias
PREWHERE b = 1;

SELECT a
FROM prewhere_alias
PREWHERE c = 1;

SELECT b
FROM prewhere_alias
PREWHERE c = 1;

SELECT c
FROM prewhere_alias
PREWHERE c = 1;

SELECT d
FROM prewhere_alias
PREWHERE c = 1;

SELECT a
FROM prewhere_alias
PREWHERE d = 2;

SELECT b
FROM prewhere_alias
PREWHERE d = 2;

SELECT c
FROM prewhere_alias
PREWHERE d = 2;

SELECT d
FROM prewhere_alias
PREWHERE d = 2;

SELECT a
FROM prewhere_alias
PREWHERE a;

SELECT b
FROM prewhere_alias
PREWHERE a;

SELECT c
FROM prewhere_alias
PREWHERE a;

SELECT d
FROM prewhere_alias
PREWHERE a;

SELECT a
FROM prewhere_alias
PREWHERE c;

SELECT b
FROM prewhere_alias
PREWHERE c;

SELECT c
FROM prewhere_alias
PREWHERE c;

SELECT d
FROM prewhere_alias
PREWHERE c;