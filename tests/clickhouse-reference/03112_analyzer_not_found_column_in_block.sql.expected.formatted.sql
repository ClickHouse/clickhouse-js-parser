-- https://github.com/ClickHouse/ClickHouse/issues/54511
DROP TABLE IF EXISTS my_first_table;

CREATE TABLE my_first_table
(
    user_id UInt32,
    message String,
    timestamp DateTime,
    metric Float32
)
ENGINE = MergeTree()
PRIMARY KEY (user_id, timestamp);

INSERT INTO my_first_table (user_id, message, timestamp, metric);

SET enable_analyzer = '1';

SELECT
    user_id,
    count(user_id) OVER (PARTITION BY user_id) AS count
FROM my_first_table
WHERE timestamp > 0
    AND user_id IN (101)
LIMIT 2 BY user_id;