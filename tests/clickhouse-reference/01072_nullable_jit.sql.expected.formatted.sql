SET compile_expressions = '1';

DROP TABLE IF EXISTS foo;

CREATE TABLE foo
(
    id UInt32,
    a Float64,
    b Float64,
    c Float64,
    d Float64
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY id;

INSERT INTO foo;

SELECT divide(sum(a) + sum(b), nullIf(sum(c) + sum(d), 0))
FROM foo;

DROP TABLE foo;