SET date_time_output_format = 'iso';

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    a DateTime('UTC'),
    b String,
    c String,
    d String,
    e Int32
)
ENGINE = Memory();

INSERT INTO t (a, b, c, d, e);

INSERT INTO t (a, b, c, d, e);

INSERT INTO t (a, b, c, d, e);

INSERT INTO t (a, b, c, d, e);

INSERT INTO t (a, b, c, d, e);

SELECT
    a,
    e
FROM t
ORDER BY e ASC;