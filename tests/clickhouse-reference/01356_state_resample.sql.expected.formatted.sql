SELECT sumResample(0, 20, 1)(number, number % 20)
FROM numbers(200);

SELECT arrayMap((x -> finalizeAggregation(x)), state)
FROM (
        SELECT sumStateResample(0, 20, 1)(number, number % 20) AS state
        FROM numbers(200)
    );

SELECT arrayMap((x -> finalizeAggregation(x)), state)
FROM (
        SELECT sumStateResample(0, 20, 1)(number, number % 20) AS state
        FROM numbers(200)
        GROUP BY number % 3
        ORDER BY number % 3 ASC
    );

SELECT groupArrayResample(0, 20, 1)(number, number % 20)
FROM numbers(50);

SELECT arrayMap((x -> finalizeAggregation(x)), state)
FROM (
        SELECT groupArrayStateResample(0, 20, 1)(number, number % 20) AS state
        FROM numbers(50)
    );

SELECT arrayMap((x -> finalizeAggregation(x)), state)
FROM (
        SELECT sumStateResample(0, 20, 1)(number, number % 20) AS state
        FROM remote('127.0.0.{1,2}', numbers(200))
    );