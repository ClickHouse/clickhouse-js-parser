SET enable_json_type = '1';

SET output_format_native_write_json_as_string = '0';

CREATE TABLE test
(
    json1 JSON(max_dynamic_paths = 2, a UInt32),
    json2 JSON(max_dynamic_paths = 2, a UInt32)
)
ENGINE = Memory();

INSERT INTO test FORMAT JSONEachRow;

SELECT
    json1,
    json2,
    json1 = json2,
    json1 != json2
FROM test;

DROP TABLE test;