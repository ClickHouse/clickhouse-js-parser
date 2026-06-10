-- https://github.com/ClickHouse/ClickHouse/issues/28687
SET enable_analyzer = '1';

CREATE VIEW alias (dummy int, n ALIAS dummy)
AS
SELECT *
FROM `system`.one;

SELECT n
FROM alias;

SELECT *
FROM alias
WHERE n = 0;