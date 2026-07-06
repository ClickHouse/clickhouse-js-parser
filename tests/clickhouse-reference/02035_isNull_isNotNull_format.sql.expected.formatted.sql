SET enable_analyzer = '1';

-- { echo }
EXPLAIN SYNTAX
SELECT NULL IS NULL;

EXPLAIN SYNTAX
SELECT NULL IS NOT NULL;

EXPLAIN SYNTAX
SELECT isNull(NULL);

EXPLAIN SYNTAX
SELECT isNotNull(NULL);

EXPLAIN SYNTAX
SELECT isNotNull(1) + isNotNull(2)
FROM remote('127.2', `system`.one);

SELECT isNotNull(1) + isNotNull(2)
FROM remote('127.2', `system`.one);