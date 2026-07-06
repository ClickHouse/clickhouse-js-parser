DROP TABLE IF EXISTS table_02152;

CREATE TABLE table_02152
(
    a String,
    b LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO table_02152;

SET count_distinct_optimization = true;

SELECT countDistinct(a)
FROM table_02152;

SELECT countDistinct(b)
FROM table_02152;

SELECT uniqExact(m)
FROM (
        SELECT
            number,
            (number / 2)::UInt64 AS m
        FROM numbers(10)
    );

SELECT uniqExact(x)
FROM numbers(10)
GROUP BY number % 2 AS x;

SET count_distinct_optimization = false;