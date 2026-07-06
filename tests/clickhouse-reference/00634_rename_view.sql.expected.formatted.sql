-- Tags: no-replicated-database
-- Tag no-replicated-database: Does not support renaming of multiple tables in single query
DROP TABLE IF EXISTS test1_00634;

DROP TABLE IF EXISTS test2_00634;

DROP TABLE IF EXISTS v_test1;

DROP TABLE IF EXISTS v_test2;

DROP TABLE IF EXISTS v_test11;

DROP TABLE IF EXISTS v_test22;

CREATE TABLE test1_00634
(
    id UInt8
)
ENGINE = TinyLog();

CREATE TABLE test2_00634
(
    id UInt8
)
ENGINE = TinyLog();

CREATE VIEW v_test1
AS
SELECT id
FROM test1_00634;

CREATE VIEW v_test2
AS
SELECT id
FROM test2_00634;

RENAME TABLE v_test1 TO v_test11, v_test2 TO v_test22;

SELECT
    name,
    engine
FROM `system`.tables
WHERE name IN ('v_test1', 'v_test2', 'v_test11', 'v_test22')
    AND database = currentDatabase()
ORDER BY name ASC;

DROP TABLE test1_00634;

DROP TABLE test2_00634;

DROP TABLE v_test11;

DROP TABLE v_test22;