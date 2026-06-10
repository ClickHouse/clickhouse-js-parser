SELECT count(*)
FROM
    (
        SELECT
            1 AS id,
            [1, 2, 3] AS arr
    ) AS sessions
ASOF LEFT JOIN (
        SELECT
            1 AS session_id,
            4 AS id
    ) AS visitors
    ON visitors.session_id <= sessions.id
    AND arrayFirst((a -> a), arrayMap((a -> a), sessions.arr)) = visitors.id;

SELECT count(*)
FROM
    (
        SELECT
            1 AS id,
            [1, 2, 3] AS arr
    ) AS sessions
ASOF LEFT JOIN (
        SELECT
            1 AS session_id,
            4 AS id
    ) AS visitors
    ON visitors.session_id <= sessions.id
    AND arrayFirst((a -> a), arrayMap((a -> a), sessions.arr)) = visitors.id
SETTINGS join_algorithm = 'full_sorting_merge';