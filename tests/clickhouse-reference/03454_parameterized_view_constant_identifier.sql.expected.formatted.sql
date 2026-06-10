DROP TABLE IF EXISTS c;

CREATE VIEW c
AS
SELECT 3 AS result
WHERE 0 = 0;

SET enable_analyzer = '1';

SELECT
    1,
    result
FROM c(a = 0);

SELECT
    2,
    result
FROM c(a = 3);

DROP TABLE c;