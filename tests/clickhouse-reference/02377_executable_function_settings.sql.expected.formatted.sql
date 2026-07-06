EXPLAIN SYNTAX
SELECT *
FROM executable('', 'JSON', 'data String');

SELECT '--------------------';

EXPLAIN SYNTAX
SELECT *
FROM executable('', 'JSON', 'data String' SETTINGS max_command_execution_time = '100');

EXPLAIN SYNTAX
SELECT *
FROM executable('', 'JSON', 'data String' SETTINGS max_command_execution_time = '100', command_read_timeout = '1');

SELECT *
FROM executable('JSON', 'data String' SETTINGS max_command_execution_time = '100'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT *
FROM executable('JSON', 'data String', 'TEST', 'TEST'); -- { serverError BAD_ARGUMENTS }