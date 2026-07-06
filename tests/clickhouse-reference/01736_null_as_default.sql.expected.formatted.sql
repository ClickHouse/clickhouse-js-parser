DROP TABLE IF EXISTS test_enum;

CREATE TABLE test_enum
(
    c Nullable(Enum16('A' = 1, 'B' = 2))
)
ENGINE = Log();

INSERT INTO test_enum;

SELECT *
FROM test_enum;

SELECT toString(c)
FROM test_enum;

SELECT toString('aaaa', NULL);

DROP TABLE test_enum;