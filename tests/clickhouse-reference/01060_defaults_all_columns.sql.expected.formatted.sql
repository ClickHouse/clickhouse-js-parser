DROP TABLE IF EXISTS defaults_all_columns;

CREATE TABLE defaults_all_columns
(
    n UInt8 DEFAULT 42,
    s String DEFAULT concat('test', CAST(n AS String))
)
ENGINE = Memory();

INSERT INTO defaults_all_columns FORMAT JSONEachRow;

INSERT INTO defaults_all_columns FORMAT JSONEachRow;

SELECT *
FROM defaults_all_columns
ORDER BY
    n ASC,
    s ASC;

DROP TABLE defaults_all_columns;