DROP TABLE IF EXISTS A;

DROP TABLE IF EXISTS B;

CREATE TABLE A
(
    k UInt32,
    t UInt32,
    a UInt64
)
ENGINE = MergeTree()
ORDER BY (k, t);

INSERT INTO A (k, t, a);

CREATE TABLE B1
(
    k UInt32,
    t UInt32,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY (k, t);

INSERT INTO B1 (k, t, b);

CREATE TABLE B2
(
    t UInt32,
    k UInt32,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY (k, t);

INSERT INTO B2 (k, t, b);

CREATE TABLE B3
(
    k UInt32,
    b UInt64,
    t UInt32
)
ENGINE = MergeTree()
ORDER BY (k, t);

INSERT INTO B3 (k, t, b);

-- { echoOn }
SELECT
    A.k,
    A.t,
    A.a,
    B.b,
    B.t,
    B.k
FROM
    A
ASOF LEFT JOIN B1 AS B
    USING (k, t)
ORDER BY (A.k, A.t) ASC;

SELECT
    A.k,
    A.t,
    A.a,
    B.b,
    B.t,
    B.k
FROM
    A
ASOF LEFT JOIN B2 AS B
    USING (k, t)
ORDER BY (A.k, A.t) ASC;

SELECT
    A.k,
    A.t,
    A.a,
    B.b,
    B.t,
    B.k
FROM
    A
ASOF LEFT JOIN B3 AS B
    USING (k, t)
ORDER BY (A.k, A.t) ASC;

SET join_algorithm = 'full_sorting_merge';

-- { echoOff }
DROP TABLE B1;

DROP TABLE B2;

DROP TABLE B3;

DROP TABLE A;