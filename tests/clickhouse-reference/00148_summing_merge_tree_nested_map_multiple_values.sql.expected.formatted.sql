DROP TABLE IF EXISTS nested_map_multiple_values;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE nested_map_multiple_values
(
    d MATERIALIZED today(),
    k UInt64,
    payload MATERIALIZED rand(),
    SomeMap Nested(ID UInt32, Num1 Int64, Num2 Float64)
)
ENGINE = SummingMergeTree(d, k, 8192);

INSERT INTO nested_map_multiple_values;

INSERT INTO nested_map_multiple_values;

OPTIMIZE TABLE nested_map_multiple_values;

SELECT *
FROM nested_map_multiple_values;

DROP TABLE nested_map_multiple_values;

DROP TABLE IF EXISTS nested_not_a_map;

CREATE TABLE nested_not_a_map
(
    d MATERIALIZED today(),
    k UInt64,
    payload MATERIALIZED rand(),
    OnlyOneColumnMap Nested(ID UInt32),
    NonArithmeticValueMap Nested(ID UInt32, Date Date),
    Nested_ Nested(ID UInt32, Num Int64)
)
ENGINE = SummingMergeTree(d, k, 8192);

INSERT INTO nested_not_a_map;

INSERT INTO nested_not_a_map;

OPTIMIZE TABLE nested_not_a_map;

SELECT *
FROM nested_not_a_map;

DROP TABLE nested_not_a_map;