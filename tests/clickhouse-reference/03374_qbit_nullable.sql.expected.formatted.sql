DROP TABLE IF EXISTS qbit_nullable_test;

CREATE TABLE qbit_nullable_test
(
    id UInt32,
    data Nullable(QBit(Float64, 4))
)
ENGINE = Memory();

INSERT INTO qbit_nullable_test;

SELECT
    id,
    data
FROM qbit_nullable_test
ORDER BY id ASC;

DROP TABLE qbit_nullable_test;