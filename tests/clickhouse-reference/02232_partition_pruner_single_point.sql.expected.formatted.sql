DROP TABLE IF EXISTS lower_test;

CREATE TABLE lower_test
(
    a Int32,
    b String
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY b;

INSERT INTO lower_test (a, b);

SELECT a
FROM lower_test
WHERE lower(b) IN ('a', 'b')
ORDER BY a ASC;

DROP TABLE lower_test;