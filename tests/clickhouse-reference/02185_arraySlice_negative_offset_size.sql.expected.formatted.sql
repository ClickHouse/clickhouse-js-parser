SELECT arraySlice([1, 2, 3, 4, 5, 6, 7, 8], -2, -2);

SELECT arraySlice(materialize([1, 2, 3, 4, 5, 6, 7, 8]), -2, -2);

SELECT arraySlice(materialize([1, 2, 3, 4, 5, 6, 7, 8]), materialize(-2), materialize(-2));

SELECT arraySlice([1, 2, 3, 4, 5, 6, 7, 8], -2, -1);

SELECT arraySlice(materialize([1, 2, 3, 4, 5, 6, 7, 8]), -2, -1);

SELECT arraySlice(materialize([1, 2, 3, 4, 5, 6, 7, 8]), materialize(-2), materialize(-1));

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    s Array(Int),
    l Int8,
    r Int8
)
ENGINE = Memory();

INSERT INTO t;

SELECT arraySlice(s, -2, -2)
FROM t;

SELECT arraySlice(s, l, -2)
FROM t;

SELECT arraySlice(s, -2, r)
FROM t;

SELECT arraySlice(s, l, r)
FROM t;

DROP TABLE t;