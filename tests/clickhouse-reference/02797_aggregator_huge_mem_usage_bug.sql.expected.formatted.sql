DROP TABLE IF EXISTS v;

CREATE VIEW v (s LowCardinality(String), n UInt8)
AS
SELECT
    'test' AS s,
    toUInt8(number) AS n
FROM numbers(10000000);

-- this is what allows mem usage to go really high
SET max_block_size = '4294967296';

SET max_memory_usage = '420Mi';

SELECT
    s,
    sum(n)
FROM v
GROUP BY s
FORMAT Null;

DROP TABLE v;