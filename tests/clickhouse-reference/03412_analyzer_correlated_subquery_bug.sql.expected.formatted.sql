SET enable_analyzer = '1';

SET allow_experimental_correlated_subqueries = '1';

CREATE TABLE mem2
ENGINE = Memory() AS
SELECT number
FROM numbers(2);

SELECT number
FROM mem2 AS tbl
WHERE exists((
        SELECT number
        FROM numbers(1)
        WHERE number >= tbl.number
    ));

SELECT '--';

SELECT number
FROM mem2 AS tbl
WHERE exists((
        SELECT number
        FROM numbers(2)
        WHERE number >= tbl.number
    ));

SELECT number
FROM mem2 AS tbl
WHERE length(arrayFilter((x -> x
    OR exists((
        SELECT number
        FROM numbers(1)
        WHERE number >= tbl.number
    ))), range(number))) > 0;

SELECT number
FROM
    mem2 AS tbl
INNER JOIN (
        SELECT number
        FROM numbers(1)
        WHERE tbl.number >= number
    ) AS alias4
    ON alias4.number = number; -- { serverError NOT_IMPLEMENTED}