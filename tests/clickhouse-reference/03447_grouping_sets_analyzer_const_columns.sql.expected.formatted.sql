SET enable_analyzer = '1';

SELECT
    grouping(key_a),
    grouping(key_b),
    key_a,
    key_b,
    count()
FROM (
        SELECT
            'value' AS key_a,
            number AS key_b
        FROM numbers(4)
    )
GROUP BY GROUPING SETS ((key_b), (key_a, key_b))
ORDER BY (grouping(key_a), grouping(key_b), key_a, key_b) ASC;

SELECT
    grouping(key_a),
    grouping(key_b),
    key_a,
    key_b,
    count()
FROM (
        SELECT
            materialize('value') AS key_a,
            number AS key_b
        FROM numbers(4)
    )
GROUP BY GROUPING SETS ((key_b), (key_a, key_b))
ORDER BY (grouping(key_a), grouping(key_b), key_a, key_b) ASC;

SELECT
    grouping(key_a),
    grouping(key_b),
    key_a,
    key_b,
    count()
FROM (
        SELECT
            'value' AS key_a,
            number AS key_b
        FROM numbers(4)
    )
GROUP BY GROUPING SETS ((key_b), (key_a, key_b))
ORDER BY (grouping(key_a), grouping(key_b), key_a, key_b) ASC
SETTINGS allow_experimental_analyzer = '0';