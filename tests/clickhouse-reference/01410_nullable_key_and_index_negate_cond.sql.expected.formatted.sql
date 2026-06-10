DROP TABLE IF EXISTS test_23634;

SET force_primary_key = '1';

CREATE TABLE test_23634
(
    id Nullable(String),
    s Nullable(String),
    s1 Nullable(String)
)
ENGINE = MergeTree()
ORDER BY (id, s)
SETTINGS allow_nullable_key = '1';

INSERT INTO test_23634;

SELECT '---Q1---';

SELECT *
FROM test_23634
WHERE id != '';

SELECT *
FROM test_23634
WHERE id != ''
    AND s != '';

SELECT *
FROM test_23634
WHERE id != ''
    AND s != ''
    AND s1 != '';

SET force_primary_key = '0';

SELECT *
FROM test_23634
WHERE (id, s, s1) != ('', '', '')
ORDER BY
    id ASC,
    s1 ASC,
    s1 ASC;

SELECT *
FROM test_23634
WHERE (id, s, s1) = ('', '', '')
ORDER BY
    id ASC,
    s1 ASC,
    s1 ASC;

SELECT *
FROM test_23634
WHERE (id, s, s1) = ('', '', 's2')
ORDER BY
    id ASC,
    s1 ASC,
    s1 ASC;

SELECT *
FROM test_23634
WHERE (id, s, s1) = ('', 's1', 's1')
ORDER BY
    id ASC,
    s1 ASC,
    s1 ASC;

SELECT *
FROM test_23634
WHERE (id, s, s1) = ('s', 's', 's')
ORDER BY
    id ASC,
    s1 ASC,
    s1 ASC;

SELECT *
FROM test_23634
WHERE (id, s, s1) = (NULL::Nullable(String), NULL::Nullable(String), NULL::Nullable(String))
ORDER BY
    id ASC,
    s1 ASC,
    s1 ASC;

DROP TABLE test_23634;