DROP TABLE IF EXISTS test_01081;

CREATE TABLE test_01081
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO test_01081 SELECT *
FROM `system`.numbers
LIMIT 10;

SELECT 1
FROM
    remote('127.{1,2}', currentDatabase(), test_01081) AS lhs
INNER JOIN `system`.one AS rhs
    ON rhs.dummy = 1
ORDER BY 1 ASC
SETTINGS enable_analyzer = '0'; -- { serverError INVALID_JOIN_ON_EXPRESSION }

SELECT 1
FROM
    remote('127.{1,2}', currentDatabase(), test_01081) AS lhs
INNER JOIN `system`.one AS rhs
    ON rhs.dummy = 1
ORDER BY 1 ASC
SETTINGS enable_analyzer = '1';