DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a UInt32,
    d Dynamic,
    ad Array(Dynamic),
    td Tuple(Dynamic),
    md Map(String, Dynamic),
    j JSON,
    x UInt32,
    y UInt32,
    z UInt32
)
ENGINE = Memory();

INSERT INTO test SELECT
    1,
    94,
    [94],
    tuple(94),
    map('a', 94),
    '{"a" : 94}',
    1,
    0,
    3;

INSERT INTO test SELECT
    2,
    40000,
    [40000],
    tuple(40000),
    map('a', 40000),
    '{"a" : 40000}',
    1,
    10,
    3;

SELECT
    x,
    y,
    z,
    argMax(d, a),
    argMax(ad, a),
    argMax(td, a),
    argMax(md, a),
    argMax(j, a),
    max(a),
    argMin(d, a),
    argMin(ad, a),
    argMin(td, a),
    argMin(md, a),
    argMin(j, a),
    min(a)
FROM test
GROUP BY
    x,
    y,
    z
ORDER BY
    x ASC,
    y ASC,
    z ASC;

DROP TABLE test;