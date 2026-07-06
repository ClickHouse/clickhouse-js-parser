DROP TABLE IF EXISTS ES;

CREATE TABLE ES
(
    A String
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO ES SELECT toString(number)
FROM numbers(10000000);

SET max_execution_time = '100', timeout_before_checking_execution_speed = '100', max_execution_speed = '1000000', max_threads = '1', max_block_size = '1000000';

-- Exception about execution speed is not thrown from these queries.
SELECT *
FROM ES
LIMIT 1
FORMAT Null;

SELECT *
FROM ES
LIMIT 10
FORMAT Null;

SELECT *
FROM ES
LIMIT 100
FORMAT Null;

SELECT *
FROM ES
LIMIT 1000
FORMAT Null;

SELECT *
FROM ES
LIMIT 10000
FORMAT Null;

SELECT *
FROM ES
LIMIT 100000
FORMAT Null;

SELECT *
FROM ES
LIMIT 1000000
FORMAT Null;

DROP TABLE ES;