DROP TABLE IF EXISTS nullable_set_index;

CREATE TABLE nullable_set_index
(
    a UInt64,
    b Nullable(String),
    INDEX b_index b TYPE set(0) GRANULARITY 8192
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO nullable_set_index;

INSERT INTO nullable_set_index;

SELECT *
FROM nullable_set_index
WHERE b = 'a';

SELECT *
FROM nullable_set_index
WHERE b = 'b';

SELECT *
FROM nullable_set_index
WHERE b = 'c';

SELECT '--';

CREATE TABLE nullable_set_index
(
    a UInt64,
    b Nullable(String),
    INDEX b_index b TYPE set(1) GRANULARITY 8192
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO nullable_set_index;

CREATE TABLE nullable_set_index
(
    a UInt64,
    b LowCardinality(Nullable(String)),
    INDEX b_index b TYPE set(0) GRANULARITY 8192
)
ENGINE = MergeTree()
ORDER BY a;

CREATE TABLE nullable_set_index
(
    a UInt64,
    b LowCardinality(Nullable(String)),
    INDEX b_index b TYPE set(1) GRANULARITY 8192
)
ENGINE = MergeTree()
ORDER BY a;