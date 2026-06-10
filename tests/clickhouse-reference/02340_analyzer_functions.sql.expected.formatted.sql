SET enable_analyzer = '1';

DESCRIBE TABLE (SELECT 1 + 1);

SELECT 1 + 1;

SELECT '--';

DESCRIBE TABLE (SELECT dummy + dummy);

SELECT dummy + dummy;

DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    id UInt64,
    value String
)
ENGINE = TinyLog();

INSERT INTO test_table;

DESCRIBE TABLE (SELECT id + length(value)
FROM test_table);

SELECT id + length(value)
FROM test_table;

DESCRIBE TABLE (SELECT concat(concat(toString(id), '_'), value)
FROM test_table);

SELECT concat(concat(toString(id), '_'), value)
FROM test_table;