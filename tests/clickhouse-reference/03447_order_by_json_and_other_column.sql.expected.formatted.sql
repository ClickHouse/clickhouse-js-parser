DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON
)
ENGINE = Memory();

INSERT INTO test;

SELECT
    json,
    materialize('')
FROM test
ORDER BY `all` ASC;

DROP TABLE test;