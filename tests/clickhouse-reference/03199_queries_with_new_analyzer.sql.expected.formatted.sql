SET enable_analyzer = '1';

SELECT
    *,
    ngramMinHash(*) AS minhash,
    mortonEncode(untuple(ngramMinHash(*))) AS z
FROM (
        SELECT toString(number)
        FROM numbers(10)
    )
ORDER BY z ASC
LIMIT 100;

CREATE TABLE test
(
    idx UInt64,
    coverage Array(UInt64),
    test_name String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test;

WITH 4096 AS w,

4096 AS h,

w * h AS pixels,

arrayJoin(coverage) AS num,

num DIV (32768 * 32768 DIV pixels) AS idx,

mortonDecode(2, idx) AS coord,

255 AS b,

least(255, uniq(test_name)) AS r,

255 * uniq(test_name) / max(uniq(test_name)) OVER () AS g

SELECT
    r::UInt8,
    g::UInt8,
    b::UInt8
FROM test
GROUP BY coord
ORDER BY (coord).2 * w + (coord).1 ASC WITH FILL FROM 0 TO 10;

CREATE TABLE seq
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO seq;

WITH (
        SELECT
            min(number),
            max(number)
        FROM seq
    ) AS `range`

SELECT *
FROM numbers((`range`).1, (`range`).2);