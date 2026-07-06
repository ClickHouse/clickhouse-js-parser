DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    c String
)
ENGINE = Log();

INSERT INTO test SELECT randomString(10)
FROM numbers(1000);

SELECT *
FROM test
ORDER BY
    c ASC,
    c.size ASC
FORMAT Null;

DROP TABLE test;