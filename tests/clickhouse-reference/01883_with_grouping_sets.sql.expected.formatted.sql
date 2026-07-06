-- Specific value doesn't matter, we just need it to be fixed, because it is a part of `EXPLAIN PIPELINE` output.
SET max_threads = '8';

DROP TABLE IF EXISTS grouping_sets;

CREATE TABLE grouping_sets
(
    fact_1_id Int32,
    fact_2_id Int32,
    fact_3_id Int32,
    fact_4_id Int32,
    sales_value Int32
)
ENGINE = Memory();

SELECT
    fact_1_id,
    fact_3_id,
    sum(sales_value),
    count()
FROM grouping_sets
GROUP BY GROUPING SETS ((fact_1_id), (fact_3_id))
ORDER BY
    fact_1_id ASC,
    fact_3_id ASC;

INSERT INTO grouping_sets SELECT
    number % 2 + 1 AS fact_1_id,
    number % 5 + 1 AS fact_2_id,
    number % 10 + 1 AS fact_3_id,
    number % 10 + 1 AS fact_4_id,
    number % 100 AS sales_value
FROM `system`.numbers
LIMIT 1000;

EXPLAIN PIPELINE
SELECT
    fact_1_id,
    fact_2_id,
    fact_3_id,
    SUM(sales_value) AS sales_value
FROM grouping_sets
GROUP BY GROUPING SETS ((fact_1_id, fact_2_id), (fact_1_id, fact_3_id))
ORDER BY
    fact_1_id ASC,
    fact_2_id ASC,
    fact_3_id ASC;

SELECT
    fact_1_id,
    fact_2_id,
    fact_3_id,
    SUM(sales_value) AS sales_value
FROM grouping_sets
GROUP BY GROUPING SETS ((fact_1_id, fact_2_id), (fact_1_id, fact_3_id))
ORDER BY
    fact_1_id ASC,
    fact_2_id ASC,
    fact_3_id ASC;

SELECT
    fact_1_id,
    fact_2_id,
    fact_3_id,
    fact_4_id,
    SUM(sales_value) AS sales_value
FROM grouping_sets
GROUP BY GROUPING SETS ((fact_1_id, fact_2_id), (fact_3_id, fact_4_id))
ORDER BY
    fact_1_id ASC,
    fact_2_id ASC,
    fact_3_id ASC,
    fact_4_id ASC;

SELECT
    fact_1_id,
    fact_2_id,
    fact_3_id,
    SUM(sales_value) AS sales_value
FROM grouping_sets
GROUP BY GROUPING SETS ((fact_1_id, fact_2_id), (fact_3_id), ())
ORDER BY
    fact_1_id ASC,
    fact_2_id ASC,
    fact_3_id ASC;

SELECT
    fact_1_id,
    fact_3_id,
    SUM(sales_value) AS sales_value
FROM grouping_sets
GROUP BY GROUPING SETS ((fact_1_id), (fact_1_id, fact_3_id))
WITH TOTALS
ORDER BY
    fact_1_id ASC,
    fact_3_id ASC; -- { serverError NOT_IMPLEMENTED }

EXPLAIN SYNTAX
SELECT
    fact_1_id,
    fact_3_id,
    SUM(sales_value) AS sales_value
FROM grouping_sets
GROUP BY GROUPING SETS ((fact_1_id), (fact_1_id, fact_3_id))
WITH TOTALS
ORDER BY
    fact_1_id ASC,
    fact_3_id ASC;

SELECT
    fact_1_id,
    fact_3_id,
    SUM(sales_value) AS sales_value
FROM grouping_sets
GROUP BY GROUPING SETS ((fact_1_id), (fact_1_id, fact_3_id))
WITH TOTALS
ORDER BY
    fact_1_id ASC,
    fact_3_id ASC; -- { serverError NOT_IMPLEMENTED }

DROP TABLE grouping_sets;

EXPLAIN PIPELINE
SELECT
    SUM(number) AS sum_value,
    count() AS count_value
FROM numbers_mt(1000000)
GROUP BY GROUPING SETS ((number % 10), (number % 100))
ORDER BY
    sum_value ASC,
    count_value ASC
SETTINGS max_threads = '3';

SELECT
    SUM(number) AS sum_value,
    count() AS count_value
FROM numbers_mt(1000000)
GROUP BY GROUPING SETS ((number % 10), (number % 100))
ORDER BY
    sum_value ASC,
    count_value ASC
SETTINGS max_threads = '3';