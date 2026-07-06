DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    id UInt64,
    s1 Nullable(String),
    s2 Nullable(String)
)
ORDER BY id;

CREATE TABLE t2
(
    id UInt64,
    s1 String,
    s2 String
)
ORDER BY id;

INSERT INTO t1;

INSERT INTO t2;

SELECT id
FROM t1
WHERE (s1, s2) = ('a', 'b');

SELECT id
FROM t1
WHERE (s1, s2) = '(''a'',''b'')';

SELECT id
FROM t1
WHERE (s1, s2) = CAST((
        SELECT
            s1,
            s2
        FROM t1
        WHERE s1 = 'a'
    ) AS text);

SELECT id
FROM t1
WHERE (s1, NULL) = ('a', NULL);

SELECT id
FROM t1
WHERE (s1, NULL) = '(''a'',null)';

SELECT id
FROM t1
WHERE (s1, NULL) = CAST((
        SELECT
            s1,
            s2
        FROM t1
        WHERE s1 = 'e'
            AND s2 IS NULL
    ) AS text);

SELECT id
FROM t2
WHERE (s1, NULL) = ('z', NULL);

SELECT id
FROM t2
WHERE (s1, NULL) = '(''z'',null)';

DROP TABLE t1;

DROP TABLE t2;