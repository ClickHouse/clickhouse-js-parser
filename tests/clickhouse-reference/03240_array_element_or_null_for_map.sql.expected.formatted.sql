WITH map(1, 2, 3, 4) AS m

SELECT arrayElementOrNull(m, number)
FROM numbers(5);

WITH map('1', 2, '3', 4) AS m

SELECT arrayElementOrNull(m, toString(number))
FROM numbers(5);

WITH map(1, 2, 3, 4) AS m

SELECT arrayElementOrNull(m, 3);

WITH map('1', 2, '3', 4) AS m

SELECT arrayElementOrNull(m, '3');

DROP TABLE IF EXISTS t_map_03240;

CREATE TABLE t_map_03240
(
    i1 UInt64,
    i2 Int32,
    m1 Map(UInt32, String),
    m2 Map(Int8, String),
    m3 Map(Int128, String)
)
ENGINE = Memory();

INSERT INTO t_map_03240;

SELECT
    arrayElementOrNull(m1, i1),
    arrayElementOrNull(m2, i1),
    arrayElementOrNull(m3, i1)
FROM t_map_03240;

SELECT
    arrayElementOrNull(m1, i2),
    arrayElementOrNull(m2, i2),
    arrayElementOrNull(m3, i2)
FROM t_map_03240;

CREATE TABLE t_map_03240
(
    s String,
    fs FixedString(3),
    m1 Map(String, String),
    m2 Map(FixedString(3), String)
)
ENGINE = Memory();

INSERT INTO t_map_03240;

SELECT
    arrayElementOrNull(m1, 'aaa'),
    arrayElementOrNull(m2, 'aaa')
FROM t_map_03240;

SELECT
    arrayElementOrNull(m1, 'aaa'::FixedString(3)),
    arrayElementOrNull(m2, 'aaa'::FixedString(3))
FROM t_map_03240;

SELECT
    arrayElementOrNull(m1, s),
    arrayElementOrNull(m2, s)
FROM t_map_03240;

SELECT
    arrayElementOrNull(m1, fs),
    arrayElementOrNull(m2, fs)
FROM t_map_03240;

SELECT length(arrayElementOrNull(m2, 'aaa'::FixedString(4)))
FROM t_map_03240;

WITH map('a', (1, 'foo')) AS m

SELECT
    arrayElementOrNull(m, 'a'),
    arrayElementOrNull(m, 'c');

WITH map('a', map(1, 'foo')) AS m

SELECT
    arrayElementOrNull(m, 'a'),
    arrayElementOrNull(m, 'c');