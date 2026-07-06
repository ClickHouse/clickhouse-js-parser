SET enable_analyzer = '1';

SET allow_experimental_correlated_subqueries = '1';

SELECT (
        SELECT count()
        FROM `system`.one
        WHERE number = 2
    )
FROM numbers(2);

SELECT (
        SELECT count()
        FROM `system`.one
        WHERE number = 2
    )
FROM numbers(2)
GROUP BY number % 2; -- { serverError NOT_IMPLEMENTED }

CREATE TABLE A
(
    id UInt32
)
ENGINE = Memory();

INSERT INTO A SELECT number + 1 AS id
FROM numbers(19);

CREATE TABLE B
(
    id UInt32,
    A_ids Array(UInt32)
)
ENGINE = Memory();

INSERT INTO B (id, A_ids);

-- The Query using Subqueries
SELECT
    A.id AS a_id,
    (
        SELECT groupArraySorted(5)(B.id)
        FROM B
        WHERE has(B.A_ids, A.id)
    ) AS b_ids_containing_a_id
FROM A
ORDER BY a_id ASC
LIMIT 20;