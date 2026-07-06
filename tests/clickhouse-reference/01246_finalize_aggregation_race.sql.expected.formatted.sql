-- Tags: race
DROP TABLE IF EXISTS test_quantile;

CREATE TABLE test_quantile
(
    x AggregateFunction(quantileTiming(0.2), UInt64)
)
ENGINE = Memory();

INSERT INTO test_quantile SELECT medianTimingState(0.2)(number)
FROM (
        SELECT *
        FROM numbers(1000)
        ORDER BY number DESC
    );

SELECT y
FROM (
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
        UNION ALL
        SELECT finalizeAggregation(x) AS y
        FROM test_quantile
    )
ORDER BY y ASC;

DROP TABLE test_quantile;