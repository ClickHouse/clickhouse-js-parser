CREATE VIEW test_param_view
AS
WITH 0 AS param_test_val

SELECT
    param_test_val,
    arrayCount((a -> a < param_test_val), t.arr) AS cnt1
FROM (
        SELECT [1, 2, 3, 4, 5] AS arr
    ) AS t;

SELECT *
FROM test_param_view(param_test_val = 3);

CREATE VIEW test_param_view2
AS
WITH 0 AS param_test_val

SELECT
    param_test_val,
    arrayCount((a -> a < param_test_val), t.arr) AS cnt1,
    arrayCount((a -> a < param_test_val + 1), t.arr) AS cnt2
FROM (
        SELECT [1, 2, 3, 4, 5] AS arr
    ) AS t;

SELECT *
FROM test_param_view2(param_test_val = 3);