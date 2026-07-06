SET allow_suspicious_low_cardinality_types = '1', max_rows_to_read = '31M';

DROP TABLE IF EXISTS perf_lc_num;

CREATE TABLE perf_lc_num
(
    num UInt8,
    arr Array(LowCardinality(Int64)) DEFAULT [num]
)
ENGINE = StripeLog();

INSERT INTO perf_lc_num (num) SELECT toUInt8(number)
FROM numbers(10000000);

SELECT sum(length(arr))
FROM perf_lc_num;

SELECT
    sum(length(arr)),
    sum(num)
FROM perf_lc_num;

INSERT INTO perf_lc_num (num) SELECT toUInt8(number)
FROM numbers(10000000, 20000000);