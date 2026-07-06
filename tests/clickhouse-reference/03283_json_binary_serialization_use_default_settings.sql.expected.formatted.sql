SET enable_json_type = '1';

SET output_format_binary_write_json_as_string = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 0)
)
ENGINE = Memory();

INSERT INTO test FORMAT JSONAsObject;

SELECT *
FROM test;