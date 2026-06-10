SELECT arrayExists((x -> (x).1 = 'pattern'), CAST([tuple('a', 1)] AS Array(Tuple(LowCardinality(String), UInt8))));

DROP TABLE IF EXISTS table;

CREATE TABLE table
(
    id Int32,
    values Array(Tuple(LowCardinality(String), Int32)),
    date Date
)
ENGINE = MergeTree()
ORDER BY (id, date)
PARTITION BY toYYYYMM(date);

SELECT count(*)
FROM table
WHERE arrayExists((x -> (x).1 = toLowCardinality('pattern')), values) = 1;