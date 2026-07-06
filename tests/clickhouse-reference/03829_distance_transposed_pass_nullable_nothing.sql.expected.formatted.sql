-- Regression test: DistanceTransposedPartialReadsPass should not throw a logical error
-- when the function result type is Nullable(Nothing) due to NULL arguments.
-- https://s3.amazonaws.com/clickhouse-test-reports/json.html?REF=master&sha=6d880459c77dd2082259ce909163c64f8cce6f22&name_0=MasterCI&name_1=AST%20fuzzer%20%28amd_ubsan%29
DROP TABLE IF EXISTS qbit_test;

CREATE TABLE qbit_test
(
    id UInt64,
    vec QBit(Float32, 18)
)
ENGINE = Memory();

INSERT INTO qbit_test;

SELECT L2DistanceTransposed(vec, NULL, 32)
FROM qbit_test;

DROP TABLE qbit_test;