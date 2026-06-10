-- Tags: memory-engine
DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int
)
ENGINE = Memory();

INSERT INTO t0 (c0) SETTINGS output_format_native_encode_types_in_binary_format = '1', input_format_native_decode_types_in_binary_format = '1';

SET output_format_native_encode_types_in_binary_format = '1';

SET input_format_native_decode_types_in_binary_format = '1';

INSERT INTO t0 (c0);

SELECT *
FROM t0;

DROP TABLE t0;