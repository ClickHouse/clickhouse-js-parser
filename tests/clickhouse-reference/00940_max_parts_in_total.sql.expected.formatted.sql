DROP TABLE IF EXISTS max_parts_in_total;

CREATE TABLE max_parts_in_total
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY x
SETTINGS max_parts_in_total = '10';

SET max_insert_threads = '1';

INSERT INTO max_parts_in_total SELECT number
FROM numbers(10);

SELECT 1;

INSERT INTO max_parts_in_total SELECT 123; -- { serverError TOO_MANY_PARTS }

DROP TABLE max_parts_in_total;