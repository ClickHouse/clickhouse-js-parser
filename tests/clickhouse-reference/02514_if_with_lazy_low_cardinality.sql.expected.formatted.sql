-- Tags: no-fasttest
-- no-fasttest: upper/lowerUTF8 use ICU
CREATE TABLE IF NOT EXISTS t
(
    `arr.key` Array(LowCardinality(String)),
    `arr.value` Array(LowCardinality(String))
)
ENGINE = Memory();

INSERT INTO t (`arr.key`, `arr.value`);

SELECT if(true, if(lowerUTF8(arr.key) = 'a', 1, 2), 3) AS x
FROM
    t
LEFT ARRAY JOIN arr;

DROP TABLE t;