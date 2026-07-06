SET enable_analyzer = '1';

EXPLAIN SYNTAX
SELECT (-(42))[3];

EXPLAIN SYNTAX
SELECT (-'a').1;