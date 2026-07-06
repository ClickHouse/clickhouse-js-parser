-- Tags: no-ordinary-database
CREATE TABLE test_table
ENGINE = MergeTree()
ORDER BY a AS
SELECT
    a_table.a,
    b_table.b_arr
FROM
    (
        SELECT arrayJoin(range(10000)) AS a
    ) AS a_table
CROSS JOIN (
        SELECT range(10000) AS b_arr
    ) AS b_table
SETTINGS max_memory_usage = '1'; -- { serverError MEMORY_LIMIT_EXCEEDED }