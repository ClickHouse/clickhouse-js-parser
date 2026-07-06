SET input_format_values_interpret_expressions = '0';

CREATE TEMPORARY TABLE t
(
    x DateTime('UTC')
);

INSERT INTO t;

SELECT x
FROM t
ORDER BY x ASC;