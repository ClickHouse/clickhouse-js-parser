SET enable_json_type = '1';

SET allow_experimental_variant_type = '1';

DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int
)
ENGINE = Memory();

INSERT INTO t0 (c0);

ALTER TABLE t0 ADD COLUMN c1 JSON(c1 Variant(Int, JSON(c1 Int)));

INSERT INTO t0 (c0, c1);

DROP TABLE t0;