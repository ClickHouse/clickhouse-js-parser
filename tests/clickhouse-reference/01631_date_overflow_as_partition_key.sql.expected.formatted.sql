DROP TABLE IF EXISTS dt_overflow;

CREATE TABLE dt_overflow
(
    d Date,
    i int
)
ENGINE = MergeTree()
ORDER BY i
PARTITION BY d;

INSERT INTO dt_overflow;

INSERT INTO dt_overflow;

SELECT *
FROM dt_overflow
ORDER BY d ASC;