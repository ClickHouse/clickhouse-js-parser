DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    ts DateTime,
    field String,
    num_field Nullable(Float64)
)
ENGINE = MergeTree()
ORDER BY ts
PARTITION BY ts;

INSERT INTO data;

SELECT
    field,
    countIf(num_field > 6.)
FROM data
PREWHERE num_field > 6.
GROUP BY field;