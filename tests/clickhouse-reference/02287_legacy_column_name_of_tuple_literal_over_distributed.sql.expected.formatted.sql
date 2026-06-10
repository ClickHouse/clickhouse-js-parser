SET legacy_column_name_of_tuple_literal = '1';

SET prefer_localhost_replica = '0';

SELECT if(in(dummy, tuple(0, 1)), 'ok', 'ok')
FROM remote('localhost', `system`.one);