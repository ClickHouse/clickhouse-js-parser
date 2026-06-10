SET enable_analyzer = '1';

CREATE TABLE testdata
(
    `1` String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO testdata;

SELECT *
FROM (
        SELECT
            if(isValidUTF8(`1`), NULL, 'error!') AS error_message,
            if(error_message IS NULL, 1, 0) AS valid
        FROM testdata
    )
WHERE valid;

SELECT *
FROM (
        SELECT 'str' AS `1`
    )
WHERE 1;