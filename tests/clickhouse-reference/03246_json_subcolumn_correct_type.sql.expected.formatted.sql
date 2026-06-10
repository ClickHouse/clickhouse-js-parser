SET enable_json_type = '1';

SET enable_analyzer = '1';

SET allow_dynamic_type_in_join_keys = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_types = 1)
)
ENGINE = Memory();

INSERT INTO test;

SELECT toTypeName(json.c0)
FROM test;

SELECT 1
FROM
    (
        SELECT 1 AS c0
    ) AS tx
FULL JOIN test
    ON test.json.Float32 = tx.c0;

DROP TABLE test;