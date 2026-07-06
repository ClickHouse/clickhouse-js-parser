SET allow_suspicious_low_cardinality_types = '1';

CREATE TABLE table_f32
(
    c0 LowCardinality(Float32),
    c1 Int
)
ENGINE = MergeTree()
ORDER BY (c0, c1);

INSERT INTO table_f32;

SELECT *
FROM table_f32
ORDER BY `all` ASC;

CREATE TABLE table_f64
(
    c0 LowCardinality(Float64),
    c1 Int
)
ENGINE = MergeTree()
ORDER BY (c0, c1);

INSERT INTO table_f64;

SELECT *
FROM table_f64
ORDER BY `all` ASC;

CREATE TABLE table_f16
(
    c0 LowCardinality(BFloat16),
    c1 Int
)
ENGINE = MergeTree()
ORDER BY (c0, c1);

INSERT INTO table_f16;

SELECT *
FROM table_f16
ORDER BY `all` ASC;