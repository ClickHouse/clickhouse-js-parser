DROP TABLE IF EXISTS A;

DROP TABLE IF EXISTS B;

CREATE TABLE A
(
    k UInt32,
    t DateTime,
    a Float64
)
ENGINE = MergeTree()
ORDER BY (k, t);

INSERT INTO A (k, t, a); -- multiple joined values

INSERT INTO A (k, t, a); -- one joined value

INSERT INTO A (k, t, a); -- no joined values

CREATE TABLE B
(
    k UInt32,
    t DateTime,
    b Float64
)
ENGINE = MergeTree()
ORDER BY (k, t);

INSERT INTO B (k, t, b);

INSERT INTO B (k, t, b);

SELECT
    A.k,
    toString(A.t, 'UTC'),
    A.a,
    B.b,
    toString(B.t, 'UTC'),
    B.k
FROM
    A
ASOF LEFT JOIN B
    USING (k, t)
ORDER BY (A.k, A.t) ASC;

SELECT
    A.k,
    toString(A.t, 'UTC'),
    A.a,
    B.b,
    toString(B.t, 'UTC'),
    B.k
FROM
    A
ASOF INNER JOIN B
    ON A.k = B.k
    AND A.t >= B.t
ORDER BY (A.k, A.t) ASC;

SELECT
    A.k,
    toString(A.t, 'UTC'),
    A.a,
    B.b,
    toString(B.t, 'UTC'),
    B.k
FROM
    A
ASOF INNER JOIN B
    USING (k, t)
ORDER BY (A.k, A.t) ASC;

SET join_algorithm = 'full_sorting_merge';

DROP TABLE A;

DROP TABLE B;