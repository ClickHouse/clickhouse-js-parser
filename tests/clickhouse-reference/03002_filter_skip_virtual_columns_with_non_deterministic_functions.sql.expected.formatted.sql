-- Tags: long
SET max_rows_to_read = '0';

CREATE TABLE test
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY number;

INSERT INTO test SELECT *
FROM numbers(50000000);

SELECT ignore(number)
FROM test
WHERE RAND() > 4292390314
LIMIT 10;

SELECT count() > 0
FROM test
WHERE RAND() > 4292390314;

DROP TABLE test;