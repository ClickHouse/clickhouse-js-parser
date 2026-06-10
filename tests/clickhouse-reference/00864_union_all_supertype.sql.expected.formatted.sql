SET joined_subquery_requires_alias = '0';

SELECT
    toTypeName(key),
    toTypeName(value)
FROM (
        SELECT
            1 AS key,
            '' AS value
        UNION ALL
        SELECT
            toUInt64(2) AS key,
            toNullable('') AS value
    );

SELECT
    toTypeName(key),
    toTypeName(value)
FROM (
        SELECT
            toDecimal64(2, 8) AS key,
            toNullable('') AS value
        UNION ALL
        SELECT
            toDecimal32(2, 4) AS key,
            toFixedString('', 1) AS value
    );

SELECT *
FROM
    (
        SELECT
            'v1' AS c1,
            NULL AS c2
        UNION ALL
        SELECT
            'v2' AS c1,
            '' AS c2
    )
ALL FULL JOIN (
        SELECT
            'v1' AS c1,
            'w1' AS c2
    )
    USING (c1, c2)
ORDER BY
    c1 ASC,
    c2 ASC;

SELECT
    key,
    s1.value,
    s2.value
FROM
    (
        SELECT
            'key1' AS key,
            'value1' AS value
    ) AS s1
ALL LEFT JOIN (
        SELECT
            'key1' AS key,
            '' AS value
        UNION ALL
        SELECT
            'key2' AS key,
            toNullable('') AS value
    ) AS s2
    USING (key);