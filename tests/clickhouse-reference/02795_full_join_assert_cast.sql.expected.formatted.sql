SELECT any(toTypeName(s))
FROM
    (
        SELECT 'a'::String AS s
    ) AS t1
FULL JOIN (
        SELECT 'b'::LowCardinality(String) AS s
    ) AS t2
    USING (s);