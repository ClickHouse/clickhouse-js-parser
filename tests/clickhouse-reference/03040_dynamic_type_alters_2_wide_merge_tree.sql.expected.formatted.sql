SET allow_experimental_dynamic_type = '1';

SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt64,
    y UInt64
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1';

INSERT INTO test SELECT
    number,
    number
FROM numbers(3);

ALTER TABLE test ADD COLUMN d Dynamic SETTINGS mutations_sync = '1';

SELECT
    count(),
    dynamicType(d)
FROM test
GROUP BY dynamicType(d)
ORDER BY
    count() ASC,
    dynamicType(d) ASC;

SELECT
    x,
    y,
    d,
    d.String,
    d.UInt64,
    d.`Tuple(a UInt64)`.a
FROM test
ORDER BY x ASC;

INSERT INTO test SELECT
    number,
    number,
    number
FROM numbers(3, 3);

INSERT INTO test SELECT
    number,
    number,
    'str_' || toString(number)
FROM numbers(6, 3);

INSERT INTO test SELECT
    number,
    number,
    NULL
FROM numbers(9, 3);

INSERT INTO test SELECT
    number,
    number,
    multiIf(number % 3 = 0, number, number % 3 = 1, 'str_' || toString(number), NULL)
FROM numbers(12, 3);

OPTIMIZE TABLE test FINAL;

SELECT
    x,
    y,
    d,
    d.String,
    d.UInt64,
    d.Date,
    d.`Tuple(a UInt64)`.a
FROM test
ORDER BY x ASC;

ALTER TABLE test RENAME COLUMN d TO d1 SETTINGS mutations_sync = '1';

SELECT
    count(),
    dynamicType(d1)
FROM test
GROUP BY dynamicType(d1)
ORDER BY
    count() ASC,
    dynamicType(d1) ASC;

SELECT
    x,
    y,
    d1,
    d1.String,
    d1.UInt64,
    d1.Date,
    d1.`Tuple(a UInt64)`.a
FROM test
ORDER BY x ASC;

INSERT INTO test SELECT
    number,
    number,
    [number % 2 ? number : 'str_' || toString(number)]::Array(Dynamic)
FROM numbers(15, 3);

SELECT
    x,
    y,
    d1,
    d1.String,
    d1.UInt64,
    d1.Date,
    d1.`Tuple(a UInt64)`.a,
    d1.`Array(Dynamic)`.UInt64,
    d1.`Array(Dynamic)`.String,
    d1.`Array(Dynamic)`.Date
FROM test
ORDER BY x ASC;

ALTER TABLE test RENAME COLUMN d1 TO d2 SETTINGS mutations_sync = '1';

SELECT
    count(),
    dynamicType(d2)
FROM test
GROUP BY dynamicType(d2)
ORDER BY
    count() ASC,
    dynamicType(d2) ASC;

SELECT
    x,
    y,
    d2,
    d2.String,
    d2.UInt64,
    d2.Date,
    d2.`Tuple(a UInt64)`.a,
    d2.`Array(Dynamic)`.UInt64,
    d2.`Array(Dynamic)`.String,
    d2.`Array(Dynamic)`.Date
FROM test
ORDER BY x ASC;

DROP TABLE test;