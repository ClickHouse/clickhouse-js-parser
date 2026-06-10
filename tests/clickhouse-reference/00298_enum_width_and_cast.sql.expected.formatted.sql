DROP TABLE IF EXISTS enum;

SET output_format_pretty_color = '1';

CREATE TABLE enum
(
    x Enum8('Hello' = -100, '\\' = 0, '\t\\t' = 111),
    y UInt8
)
ENGINE = TinyLog();

INSERT INTO enum (y);

SELECT *
FROM enum
ORDER BY
    x ASC,
    y ASC
FORMAT PrettyCompactMonoBlock;

INSERT INTO enum (x);

INSERT INTO enum (x);

SELECT
    x,
    y,
    toInt8(x),
    toString(x) AS s,
    CAST(s AS Enum8('Hello' = -100, '\\' = 0, '\t\\t' = 111)) AS cast
FROM enum
ORDER BY
    x ASC,
    y ASC
FORMAT PrettyCompactMonoBlock;

DROP TABLE enum;