DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    map Map(String, DateTime)
)
ENGINE = Memory();

SET date_time_input_format = 'best_effort';

INSERT INTO test;

SELECT *
FROM test;

DROP TABLE test;