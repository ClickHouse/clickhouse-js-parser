SELECT arrayFilter((a -> (a, arrayJoin([])) IN (NULL, [NULL])), []);

SELECT arrayFilter((a -> (a, arrayJoin([[]])) IN (NULL, [NULL])), []);

SELECT *
FROM
    `system`.one
ARRAY JOIN arrayFilter((a -> (a, arrayJoin([])) IN (NULL)), []) AS arr_x;

SELECT *
FROM
    numbers(1)
LEFT ARRAY JOIN arrayFilter(((x_0, x_1) -> arrayJoin([]) IN (NULL)), [], []) AS arr_x;