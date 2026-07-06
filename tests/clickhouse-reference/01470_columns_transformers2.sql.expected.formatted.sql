DROP TABLE IF EXISTS columns_transformers;

CREATE TABLE columns_transformers
(
    i int,
    j int,
    k int,
    a_bytes int,
    b_bytes int,
    c_bytes int
)
ENGINE = TinyLog();

INSERT INTO columns_transformers;

SELECT
    * EXCEPT('bytes'),
    COLUMNS('bytes') APPLY(formatReadableSize)
FROM columns_transformers;

SELECT * APPLY(x -> argMax(x, number))
FROM numbers(1);

EXPLAIN SYNTAX
SELECT * APPLY(x -> argMax(x, number))
FROM numbers(1);