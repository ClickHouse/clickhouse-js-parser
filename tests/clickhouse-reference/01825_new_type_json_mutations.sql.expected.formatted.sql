-- Tags: no-fasttest
DROP TABLE IF EXISTS t_json_mutations;

SET enable_json_type = '1';

SET output_format_json_named_tuples_as_objects = '1';

SET mutations_sync = '2';

CREATE TABLE t_json_mutations
(
    id UInt32,
    s String,
    obj JSON
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t_json_mutations;

INSERT INTO t_json_mutations;

INSERT INTO t_json_mutations;

SELECT *
FROM t_json_mutations
ORDER BY id ASC;

ALTER TABLE t_json_mutations DELETE WHERE id = 2;

ALTER TABLE t_json_mutations DROP COLUMN s, DROP COLUMN obj, ADD COLUMN t String DEFAULT 'foo';

DROP TABLE t_json_mutations;