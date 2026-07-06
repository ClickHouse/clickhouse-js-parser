DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    Printer LowCardinality(String),
    IntervalStart DateTime
)
ENGINE = MergeTree()
ORDER BY (Printer, IntervalStart)
PARTITION BY (hiveHash(Printer), toYear(IntervalStart));

INSERT INTO test;

SELECT Printer
FROM test
WHERE Printer = 'printer1';

DROP TABLE test;