-- Checks that no bad things happen when the table optimizes the row order to improve compressability during insert.
-- Below SELECTs intentionally only ORDER BY the table primary key and rely on read-in-order optimization
SET optimize_read_in_order = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    name String,
    event Int8
)
ENGINE = MergeTree()
ORDER BY name
SETTINGS optimize_row_order = true;

INSERT INTO tab;

SELECT *
FROM tab
ORDER BY name ASC
SETTINGS max_threads = '1';

DROP TABLE tab;

CREATE TABLE tab
(
    name String,
    timestamp Int64,
    money UInt8,
    flag String
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS optimize_row_order = true;

INSERT INTO tab;

SELECT *
FROM tab
SETTINGS max_threads = '1';

CREATE TABLE tab
(
    name FixedString(2),
    timestamp Float32,
    money Float64,
    flag Nullable(Int32)
)
ENGINE = MergeTree()
ORDER BY (flag, money)
SETTINGS optimize_row_order = true, allow_nullable_key = true;

INSERT INTO tab;

SELECT *
FROM tab
ORDER BY (flag, money) ASC
SETTINGS max_threads = '1';

CREATE TABLE tab
(
    fixed_str FixedString(6),
    event_date Date,
    vector_array Array(Float32),
    nullable_int Nullable(Int128),
    low_card_string LowCardinality(String),
    map_column Map(String, String),
    tuple_column Tuple(UInt256)
)
ENGINE = MergeTree()
ORDER BY (fixed_str, event_date)
SETTINGS optimize_row_order = true;

INSERT INTO tab;

SELECT *
FROM tab
ORDER BY (fixed_str, event_date) ASC
SETTINGS max_threads = '1';