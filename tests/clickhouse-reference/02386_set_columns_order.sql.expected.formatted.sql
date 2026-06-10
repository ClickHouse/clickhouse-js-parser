DROP TABLE IF EXISTS userid_set;

DROP TABLE IF EXISTS userid_test;

DROP TABLE IF EXISTS userid_set2;

CREATE TABLE userid_set
(
    userid UInt64,
    name String
)
ENGINE = Set();

INSERT INTO userid_set;

CREATE TABLE userid_test
(
    userid UInt64,
    name String
)
ENGINE = MergeTree()
ORDER BY userid
PARTITION BY intDiv(userid, 500)
SETTINGS index_granularity = '8192';

INSERT INTO userid_test;

SELECT *
FROM userid_test
WHERE (userid, name) IN (userid_set);

CREATE TABLE userid_set2
(
    userid UInt64,
    name String,
    birthdate Date
)
ENGINE = Set();

INSERT INTO userid_set2;

WITH 'John' AS name,

toDate('1990-01-01') AS birthdate

SELECT *
FROM numbers(10)
WHERE (number, name, birthdate) IN (userid_set2);

DROP TABLE userid_set;

DROP TABLE userid_test;

DROP TABLE userid_set2;