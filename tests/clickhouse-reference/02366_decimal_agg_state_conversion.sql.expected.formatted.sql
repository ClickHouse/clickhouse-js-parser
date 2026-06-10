SELECT sumMerge(y)
FROM (
        SELECT CAST(x AS AggregateFunction(sum, Decimal(50, 10))) AS y
        FROM (
                SELECT arrayReduce('sumState', [toDecimal256('0.000001', 10), toDecimal256('1.1', 10)]) AS x
            )
    );

SELECT minMerge(y)
FROM (
        SELECT CAST(x AS AggregateFunction(min, Decimal(18, 10))) AS y
        FROM (
                SELECT arrayReduce('minState', [toDecimal64('0.000001', 10), toDecimal64('1.1', 10)]) AS x
            )
    );

DROP TABLE IF EXISTS consumer_02366;

DROP TABLE IF EXISTS producer_02366;

DROP TABLE IF EXISTS mv_02366;

CREATE TABLE consumer_02366
(
    id UInt16,
    dec AggregateFunction(argMin, Decimal(24, 10), UInt16)
)
ENGINE = AggregatingMergeTree()
PRIMARY KEY id
ORDER BY id;

CREATE TABLE producer_02366
(
    id UInt16,
    dec String
)
ENGINE = MergeTree()
PRIMARY KEY id
ORDER BY id;

CREATE MATERIALIZED VIEW mv_02366
TO consumer_02366
AS
SELECT
    id,
    argMinState(dec, id) AS dec
FROM (
        SELECT
            id,
            toDecimal128(dec, 10) AS dec
        FROM producer_02366
    )
GROUP BY id;

INSERT INTO producer_02366 (*);

SELECT
    id,
    finalizeAggregation(dec)
FROM consumer_02366;

DROP TABLE consumer_02366;

DROP TABLE producer_02366;

DROP TABLE mv_02366;