SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS t_summing_lc;

CREATE TABLE t_summing_lc
(
    key UInt32,
    val LowCardinality(UInt32),
    date DateTime
)
ENGINE = SummingMergeTree(val)
ORDER BY key
PARTITION BY date;

INSERT INTO t_summing_lc;

OPTIMIZE TABLE t_summing_lc FINAL;

SELECT *
FROM t_summing_lc
ORDER BY key ASC;

DROP TABLE t_summing_lc;