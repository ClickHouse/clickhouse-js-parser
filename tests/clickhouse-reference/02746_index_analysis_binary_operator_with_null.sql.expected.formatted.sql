DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    x DateTime
)
ENGINE = MergeTree()
ORDER BY x;

SELECT toDateTime(65537, toDateTime(NULL), NULL)
FROM tab
WHERE x + CAST('1' AS Nullable(UInt8)) <= 2
    AND x + CAST('' AS Nullable(UInt8)) <= 256
ORDER BY
    toDateTime(toDateTime(-2, NULL, NULL) + 100.0001, NULL, -2, NULL) DESC NULLS LAST,
    x ASC NULLS LAST;

DROP TABLE tab;