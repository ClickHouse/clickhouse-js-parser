DROP TABLE IF EXISTS max_length_alias_14053;

CREATE TABLE max_length_alias_14053
(
    a Date,
    b UInt16,
    `c.d` Array(Date),
    dcount UInt16 ALIAS length(c.d)
)
ENGINE = MergeTree()
ORDER BY (a, b)
PARTITION BY toMonday(a)
SETTINGS index_granularity = '8192';

INSERT INTO max_length_alias_14053;

SELECT
    count(),
    min(length(c.d)) AS minExpr,
    min(dcount) AS minAlias,
    max(length(c.d)) AS maxExpr,
    max(dcount) AS maxAlias,
    b
FROM max_length_alias_14053
GROUP BY b;

DROP TABLE max_length_alias_14053;