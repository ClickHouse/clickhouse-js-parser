CREATE TABLE max_length_alias_14053__fuzz_45
(
    a Date,
    b Nullable(Decimal(76, 45)),
    `c.d` Array(Nullable(DateTime64(3))),
    dcount Int8 ALIAS length(c.d)
)
ENGINE = MergeTree()
ORDER BY (a, b)
PARTITION BY toMonday(a)
SETTINGS allow_nullable_key = '1', index_granularity = '8192';

INSERT INTO max_length_alias_14053__fuzz_45;

SELECT
    count(),
    min(length(c.d)) AS minExpr,
    min(dcount) AS minAlias,
    max(length(c.d)) AS maxExpr,
    max(dcount) AS maxAlias,
    b
FROM max_length_alias_14053__fuzz_45
GROUP BY b;

DROP TABLE max_length_alias_14053__fuzz_45;