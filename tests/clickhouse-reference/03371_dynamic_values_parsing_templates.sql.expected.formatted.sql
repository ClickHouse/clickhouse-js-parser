SET enable_dynamic_type = '1', enable_json_type = '1', type_json_skip_duplicated_paths = '1', allow_suspicious_low_cardinality_types = '1', cast_string_to_dynamic_use_inference = '1', session_timezone = 'UTC', allow_suspicious_types_in_order_by = '1';

DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Dynamic
)
ENGINE = Memory();

INSERT INTO t0 (c0);

SELECT c0
FROM t0
ORDER BY c0 ASC;

DROP TABLE t0;