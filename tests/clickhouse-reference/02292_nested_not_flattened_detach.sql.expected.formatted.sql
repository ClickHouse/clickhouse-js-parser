DROP TABLE IF EXISTS t_nested_detach;

SET flatten_nested = '0';

CREATE TABLE t_nested_detach
(
    n Nested(u UInt32, s String)
)
ENGINE = Log();

SHOW CREATE TABLE t_nested_detach;

DESCRIBE TABLE t_nested_detach;

SET flatten_nested = '1';

DETACH TABLE t_nested_detach;

ATTACH TABLE t_nested_detach;