DROP TABLE IF EXISTS proj;

CREATE TABLE proj
(
    bool_value UInt8,
    zero_integer_value Int32,
    integer_value Int32,
    float_value Float32,
    datetime_value DateTime,
    string_value String,
    PROJECTION test_projection (SELECT toStartOfDay(toDateTime(datetime_value)) AS Day, datetime_value, float_value, countDistinct(if(zero_integer_value = 1, string_value, NULL)) GROUP BY Day, datetime_value, float_value)
)
ENGINE = MergeTree()
ORDER BY bool_value
PARTITION BY toDate(datetime_value);

INSERT INTO proj;

DROP TABLE proj;