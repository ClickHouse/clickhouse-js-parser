CREATE TABLE test
(
    a Tuple(b String, c Tuple(d Nullable(UInt64), e Array(UInt32), f Array(Tuple(g String, h Map(String, Array(Tuple(i String, j UInt64))))), k Date), l Nullable(String))
)
ENGINE = Memory();

INSERT INTO test SELECT *
FROM generateRandom(42)
LIMIT 1;

SET print_pretty_type_names = '1';

DESCRIBE TABLE test FORMAT TSVRaw;

SELECT toTypeName(a)
FROM test
LIMIT 1
FORMAT TSVRaw;