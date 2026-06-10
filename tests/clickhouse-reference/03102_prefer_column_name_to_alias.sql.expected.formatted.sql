-- https://github.com/ClickHouse/ClickHouse/issues/54954
DROP TABLE IF EXISTS loans;

CREATE TABLE loans
(
    loan_number int,
    security_id text
)
ENGINE = Memory();

SET enable_analyzer = '1';

INSERT INTO loans;

INSERT INTO loans;

WITH block_0 AS (
    SELECT *
    FROM loans
),

block_1 AS (
    SELECT sum(loan_number) AS loan_number
    FROM block_0
    GROUP BY security_id
)

SELECT loan_number
FROM block_1
WHERE loan_number > 3
ORDER BY loan_number ASC
SETTINGS prefer_column_name_to_alias = '1';