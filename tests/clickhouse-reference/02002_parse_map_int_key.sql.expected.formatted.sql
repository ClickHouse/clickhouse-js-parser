DROP TABLE IF EXISTS t_map_int_key;

CREATE TABLE t_map_int_key
(
    m1 Map(UInt32, UInt32),
    m2 Map(Date, UInt32)
)
ENGINE = Memory();

INSERT INTO t_map_int_key FORMAT CSV;

DROP TABLE t_map_int_key;