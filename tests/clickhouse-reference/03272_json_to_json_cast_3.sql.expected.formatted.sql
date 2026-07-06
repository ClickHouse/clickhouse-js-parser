SET enable_json_type = '1';

SET enable_analyzer = '1';

SET output_format_native_write_json_as_string = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 2)
)
ENGINE = Memory();

INSERT INTO test FORMAT JSONAsObject;

SELECT json::JSON(SKIP a, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP b, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP c, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP c.d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a, SKIP b, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a, SKIP c, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a, SKIP c.d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, SKIP b, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, SKIP c, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, SKIP c.d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP b, SKIP c, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP b, SKIP c.d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP b, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP c, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a, SKIP b, SKIP c, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a, SKIP b, SKIP c.d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a, SKIP b, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a, SKIP c, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a, SKIP c.d, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, SKIP b, SKIP c, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, SKIP b, SKIP c.d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, SKIP b, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, SKIP c, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP a.b, SKIP c.d, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP b, SKIP c, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP b, SKIP c.d, SKIP d, max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP REGEXP '.*a.*', max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP REGEXP '.*b.*', max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP REGEXP '.*d.*', max_dynamic_paths = 2)
FROM test;

SELECT json::JSON(SKIP REGEXP '.*c.*', max_dynamic_paths = 2)
FROM test;

DROP TABLE test;