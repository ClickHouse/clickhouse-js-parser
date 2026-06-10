SET allow_experimental_dynamic_type = '1';

SET allow_suspicious_types_in_order_by = '1';

SET output_format_pretty_named_tuples_as_json = '0';

CREATE TABLE t
(
    d Dynamic
)
ENGINE = Memory();

INSERT INTO t;

INSERT INTO t;

SELECT
    dynamicType(d),
    d,
    d.`Nested(x UInt32, y Dynamic)`.x,
    d.`Nested(x UInt32, y Dynamic)`.y,
    dynamicType(d.`Nested(x UInt32, y Dynamic)`.y[1]),
    d.`Nested(x UInt32, y Dynamic)`.y.String,
    d.`Nested(x UInt32, y Dynamic)`.y.`Tuple(Int64, Array(String))`
FROM t
ORDER BY d ASC
FORMAT PrettyCompactMonoBlock;