DROP TABLE IF EXISTS test_low_cardinality_string;

DROP TABLE IF EXISTS test_low_cardinality_uuid;

DROP TABLE IF EXISTS test_low_cardinality_int;

CREATE TABLE test_low_cardinality_string
(
    data String
)
ENGINE = MergeTree()
ORDER BY data;

CREATE TABLE test_low_cardinality_uuid
(
    data String
)
ENGINE = MergeTree()
ORDER BY data;

CREATE TABLE test_low_cardinality_int
(
    data String
)
ENGINE = MergeTree()
ORDER BY data;

INSERT INTO test_low_cardinality_string (data);

INSERT INTO test_low_cardinality_int (data);

INSERT INTO test_low_cardinality_uuid (data);

SELECT JSONExtract(data, 'Tuple(\n                            a LowCardinality(String),\n                            b LowCardinality(String),\n                            c LowCardinality(String),\n                            d LowCardinality(String)\n                            )') AS json
FROM test_low_cardinality_string;

SELECT JSONExtract(data, 'Tuple(\n                            a LowCardinality(FixedString(20)),\n                            b LowCardinality(FixedString(20)),\n                            c LowCardinality(FixedString(20)),\n                            d LowCardinality(FixedString(20))\n                            )') AS json
FROM test_low_cardinality_string;

SELECT JSONExtract(data, 'Tuple(\n                            a LowCardinality(Int8),\n                            b LowCardinality(Int8),\n                            c LowCardinality(Int8),\n                            d LowCardinality(Int8)\n                            )') AS json
FROM test_low_cardinality_int;

SELECT JSONExtract(data, 'Tuple(\n                            a LowCardinality(Int16),\n                            b LowCardinality(Int16),\n                            c LowCardinality(Int16),\n                            d LowCardinality(Int16)\n                            )') AS json
FROM test_low_cardinality_int;

SELECT JSONExtract(data, 'Tuple(\n                            a LowCardinality(Int32),\n                            b LowCardinality(Int32),\n                            c LowCardinality(Int32),\n                            d LowCardinality(Int32)\n                            )') AS json
FROM test_low_cardinality_int;

SELECT JSONExtract(data, 'Tuple(\n                            a LowCardinality(Int64),\n                            b LowCardinality(Int64),\n                            c LowCardinality(Int64),\n                            d LowCardinality(Int64)\n                            )') AS json
FROM test_low_cardinality_int;

SELECT JSONExtract(data, 'Tuple(\n                            a LowCardinality(UUID),\n                            b LowCardinality(UUID),\n                            c LowCardinality(UUID),\n                            d LowCardinality(UUID)\n                            )') AS json
FROM test_low_cardinality_uuid;

DROP TABLE test_low_cardinality_string;

DROP TABLE test_low_cardinality_uuid;

DROP TABLE test_low_cardinality_int;