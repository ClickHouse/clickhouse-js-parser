DROP TABLE IF EXISTS t_async_insert_params;

CREATE TABLE t_async_insert_params
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

SET param_p1 = 'Hello';

SET async_insert = '1';

SET wait_for_async_insert = '1';

INSERT INTO t_async_insert_params; -- { serverError  BAD_QUERY_PARAMETER }

INSERT INTO t_async_insert_params; -- { serverError  TYPE_MISMATCH }

ALTER TABLE t_async_insert_params MODIFY COLUMN id String;

SELECT *
FROM t_async_insert_params
ORDER BY id ASC;

DROP TABLE t_async_insert_params;