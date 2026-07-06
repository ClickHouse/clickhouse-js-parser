SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS t_nested_tuple;

CREATE TABLE t_nested_tuple
(
    endUserIDs Tuple(_experience Tuple(aaid Tuple(id Nullable(String), namespace Tuple(code LowCardinality(Nullable(String))), primary LowCardinality(Nullable(UInt8))), mcid Tuple(id Nullable(String), namespace Tuple(code LowCardinality(Nullable(String))), primary LowCardinality(Nullable(UInt8)))))
)
ENGINE = MergeTree()
ORDER BY tuple();

SET output_format_json_named_tuples_as_objects = '1';

INSERT INTO t_nested_tuple FORMAT JSONEachRow;

SELECT *
FROM t_nested_tuple
FORMAT JSONEachRow;

SELECT endUserIDs._experience
FROM t_nested_tuple
FORMAT JSONEachRow;

SELECT endUserIDs._experience.aaid
FROM t_nested_tuple
FORMAT JSONEachRow;

SELECT endUserIDs._experience.aaid.id
FROM t_nested_tuple
FORMAT JSONEachRow;

SELECT endUserIDs._experience.aaid.namespace
FROM t_nested_tuple
FORMAT JSONEachRow;

SELECT endUserIDs._experience.aaid.namespace.code
FROM t_nested_tuple
FORMAT JSONEachRow;

SELECT endUserIDs._experience.aaid.primary
FROM t_nested_tuple
FORMAT JSONEachRow;

DROP TABLE t_nested_tuple;