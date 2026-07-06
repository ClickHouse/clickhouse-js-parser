SET optimize_on_insert = '0';

DROP TABLE IF EXISTS summing_composite_key;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE summing_composite_key
(
    d Date,
    k UInt64,
    FirstMap Nested(k1 UInt32, k2ID Int8, s Float64),
    SecondMap Nested(k1ID UInt64, k2Key String, k3Type Int32, s Int64)
)
ENGINE = SummingMergeTree(d, k, 1);

INSERT INTO summing_composite_key;

SELECT *
FROM summing_composite_key
ORDER BY
    d ASC,
    k ASC,
    FirstMap.k1 ASC,
    FirstMap.k2ID ASC,
    FirstMap.s ASC,
    SecondMap.k1ID ASC,
    SecondMap.k2Key ASC,
    SecondMap.k3Type ASC,
    SecondMap.s ASC;

SELECT
    d,
    k,
    m.k1,
    m.k2ID,
    m.s
FROM
    summing_composite_key
ARRAY JOIN FirstMap AS m
ORDER BY
    d ASC,
    k ASC,
    m.k1 ASC,
    m.k2ID ASC,
    m.s ASC,
    SecondMap.k1ID ASC,
    SecondMap.k2Key ASC,
    SecondMap.k3Type ASC,
    SecondMap.s ASC;

SELECT
    d,
    k,
    m.k1,
    m.k2ID,
    sum(m.s)
FROM
    summing_composite_key
ARRAY JOIN FirstMap AS m
GROUP BY
    d,
    k,
    m.k1,
    m.k2ID
ORDER BY
    d ASC,
    k ASC,
    m.k1 ASC,
    m.k2ID ASC;

SELECT
    d,
    k,
    m.k1,
    m.k2ID,
    m.s
FROM
    summing_composite_key FINAL
ARRAY JOIN FirstMap AS m
ORDER BY
    d ASC,
    k ASC,
    m.k1 ASC,
    m.k2ID ASC,
    m.s ASC;

SELECT
    d,
    k,
    m.k1ID,
    m.k2Key,
    m.k3Type,
    m.s
FROM
    summing_composite_key
ARRAY JOIN SecondMap AS m
ORDER BY
    d ASC,
    k ASC,
    m.k1ID ASC,
    m.k2Key ASC,
    m.k3Type ASC,
    m.s ASC;

SELECT
    d,
    k,
    m.k1ID,
    m.k2Key,
    m.k3Type,
    sum(m.s)
FROM
    summing_composite_key
ARRAY JOIN SecondMap AS m
GROUP BY
    d,
    k,
    m.k1ID,
    m.k2Key,
    m.k3Type
ORDER BY
    d ASC,
    k ASC,
    m.k1ID ASC,
    m.k2Key ASC,
    m.k3Type ASC;

SELECT
    d,
    k,
    m.k1ID,
    m.k2Key,
    m.k3Type,
    m.s
FROM
    summing_composite_key FINAL
ARRAY JOIN SecondMap AS m
ORDER BY
    d ASC,
    k ASC,
    m.k1ID ASC,
    m.k2Key ASC,
    m.k3Type ASC,
    m.s ASC;

OPTIMIZE TABLE summing_composite_key PARTITION 200001 FINAL;

;

SELECT
    d,
    k,
    m.k1,
    m.k2ID,
    m.s
FROM
    summing_composite_key
ARRAY JOIN FirstMap AS m
ORDER BY
    d ASC,
    k ASC,
    m.k1 ASC,
    m.k2ID ASC,
    m.s ASC;

DROP TABLE summing_composite_key;