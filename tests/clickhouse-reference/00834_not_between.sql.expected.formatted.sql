SELECT 2 < 2 + 1
    OR 2 > 4 - 1;

SELECT number
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 10
    )
WHERE number < 2
    OR number > 4;

SELECT
    number >= 4
    AND number <= 6,
    NOT(number < 4
    OR number > 6)
    AND 1
FROM numbers(10);