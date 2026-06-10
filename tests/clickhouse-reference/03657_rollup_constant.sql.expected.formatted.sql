DROP TABLE IF EXISTS my_first_table;

CREATE TABLE my_first_table
(
    user_id UInt32,
    job_id UInt32,
    message String,
    timestamp DateTime,
    metric Float32
)
ENGINE = MergeTree()
PRIMARY KEY (user_id, timestamp);

INSERT INTO my_first_table (user_id, job_id, message, timestamp, metric);

SET enable_analyzer = '1';

SELECT
    1 AS constant,
    user_id,
    job_id,
    sum(metric)
FROM my_first_table
GROUP BY
    constant,
    user_id,
    job_id
WITH ROLLUP
ORDER BY
    constant = 0 ASC,
    user_id = 0 ASC,
    job_id = 0 ASC,
    constant ASC,
    user_id ASC,
    job_id ASC;

DROP TABLE my_first_table;