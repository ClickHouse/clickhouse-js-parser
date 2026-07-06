SET enable_analyzer = '1';

-- { echo }
SELECT
    multiIf(number = 0, (
        SELECT 0
    ), number = 1, (
        SELECT 1
    ), NULL) AS col,
    toTypeName(col)
FROM numbers(2);

SELECT
    multiIf(number = 0, (
        SELECT
            1,
            2
    ), number = 1, (
        SELECT
            3,
            4
    ), NULL) AS col,
    toTypeName(col)
FROM numbers(2);

SELECT
    multiIf(number = 0, (
        SELECT
            1,
            2
    ), number = 1, (
        SELECT NULL
    ), NULL) AS col,
    toTypeName(col)
FROM numbers(2);

SELECT
    multiIf(number = 0, (
        SELECT NULL
    ), number = 1, (
        SELECT
            1,
            2
    ), NULL) AS col,
    toTypeName(col)
FROM numbers(2);

SELECT
    multiIf(number = 0, (
        SELECT NULL
    ), number = 1, (
        SELECT NULL
    ), NULL) AS col,
    toTypeName(col)
FROM numbers(2);