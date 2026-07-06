SET enable_json_type = '1', type_json_skip_duplicated_paths = '1', allow_simdjson = '1';

DROP TABLE IF EXISTS t0;

DROP TABLE IF EXISTS t1;

CREATE TABLE t0
(
    c0 JSON,
    c1 Array(Nullable(Decimal))
)
ENGINE = Memory();

CREATE TABLE t1 AS t0;

SET min_compress_block_size = '2654980', cross_join_min_rows_to_compress = '1', insert_null_as_default = '1', check_query_single_value_result = '1', partial_merge_join_optimizations = '1', use_uncompressed_cache = '0';

INSERT INTO t0 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t0 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t0 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t0 (c0, c1);

INSERT INTO t0 (c0, c1);

INSERT INTO t0 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t0 (c0, c1);

INSERT INTO t0 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t0 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t1 (c0, c1);

INSERT INTO t1 (c0, c1);

SELECT 1
FROM
    t1
CROSS JOIN t0
FORMAT Null;

DROP TABLE t1;

DROP TABLE t0;