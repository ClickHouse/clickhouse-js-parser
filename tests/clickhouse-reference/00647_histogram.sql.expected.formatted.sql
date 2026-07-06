SELECT histogram(5)(number - 10)
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 20
    );

SELECT histogram(5)(number)
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 20
    );

WITH arrayJoin(histogram(3)(sin(number))) AS res

SELECT
    round((res).1, 2),
    round((res).2, 2),
    round((res).3, 2)
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 10
    );

WITH arrayJoin(histogram(1)(sin(number - 40))) AS res

SELECT
    round((res).1, 2),
    round((res).2, 2),
    round((res).3, 2)
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 80
    );

SELECT histogram(10)(-2);

SELECT histogramIf(3)(number, number > 11)
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 10
    );