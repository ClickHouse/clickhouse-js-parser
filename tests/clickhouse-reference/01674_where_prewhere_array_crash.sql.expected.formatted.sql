DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    x UInt64,
    `arr.a` Array(UInt64),
    `arr.b` Array(UInt64)
)
ENGINE = MergeTree()
ORDER BY x;

SELECT x
FROM
    tab
ARRAY JOIN arr
PREWHERE x != 0
WHERE arr; -- { serverError UNKNOWN_IDENTIFIER, 59 }

SELECT x
FROM
    tab
ARRAY JOIN arr
PREWHERE arr
WHERE x != 0; -- { serverError UNKNOWN_IDENTIFIER, 59 }