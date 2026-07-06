SET send_logs_level = 'fatal';

DROP TABLE IF EXISTS Issue_2231_Invalid_Nested_Columns_Size;

CREATE TABLE Issue_2231_Invalid_Nested_Columns_Size
(
    Date Date,
    NestedColumn Nested(ID Int32, Count Int64)
)
ENGINE = MergeTree()
ORDER BY Date
PARTITION BY tuple();

INSERT INTO Issue_2231_Invalid_Nested_Columns_Size; -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT *
FROM Issue_2231_Invalid_Nested_Columns_Size;

DROP TABLE Issue_2231_Invalid_Nested_Columns_Size;