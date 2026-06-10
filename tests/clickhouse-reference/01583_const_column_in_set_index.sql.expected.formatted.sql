DROP TABLE IF EXISTS insub;

CREATE TABLE insub
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS index_granularity = '1';

INSERT INTO insub SELECT
    number AS a,
    a + 2
FROM numbers(10);

SET max_rows_to_read = '12'; -- 10 from numbers + 2 from table

SELECT *
FROM insub
WHERE i IN (
        SELECT toInt32(3)
        FROM numbers(10)
    );