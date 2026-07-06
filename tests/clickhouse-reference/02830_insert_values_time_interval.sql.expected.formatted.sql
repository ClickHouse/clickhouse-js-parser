DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    c1 DateTime NOT NULL DEFAULT now(),
    c2 DateTime NOT NULL DEFAULT now(),
    c3 DateTime NOT NULL DEFAULT now(),
    PRIMARY KEY(c1, c2, c3)
)
ENGINE = MergeTree()
ORDER BY (c1, c2, c3);

INSERT INTO t1 (c1, c2, c3);

DROP TABLE t1;

CREATE TABLE t1
(
    n int,
    dt DateTime
)
ENGINE = Memory();

SET input_format_values_interpret_expressions = '0';

INSERT INTO t1;

INSERT INTO t1;

SELECT *
FROM t1
ORDER BY n ASC;