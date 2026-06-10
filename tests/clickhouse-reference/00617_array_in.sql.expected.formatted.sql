DROP TABLE IF EXISTS test_array_ops;

CREATE TABLE test_array_ops
(
    arr Array(Nullable(Int64))
)
ENGINE = Memory();

INSERT INTO test_array_ops (arr);

INSERT INTO test_array_ops (arr);

INSERT INTO test_array_ops (arr);

SELECT count(*)
FROM test_array_ops
WHERE arr < CAST([10, -20] AS Array(Nullable(Int64)));

SELECT count(*)
FROM test_array_ops
WHERE arr > CAST([10, -20] AS Array(Nullable(Int64)));

SELECT count(*)
FROM test_array_ops
WHERE arr >= CAST([10, -20] AS Array(Nullable(Int64)));

SELECT count(*)
FROM test_array_ops
WHERE arr <= CAST([10, -20] AS Array(Nullable(Int64)));

SELECT count(*)
FROM test_array_ops
WHERE arr = CAST([10, -20] AS Array(Nullable(Int64)));

SELECT count(*)
FROM test_array_ops
WHERE arr IN (CAST([10, -20] AS Array(Nullable(Int64))), CAST([NULL, 10, -20] AS Array(Nullable(Int64))));

DROP TABLE test_array_ops;