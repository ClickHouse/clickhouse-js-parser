-- Tags: no-fasttest
SET input_format_defaults_for_omitted_fields = '1';

DROP TABLE IF EXISTS defaults;

CREATE TABLE defaults
(
    x UInt32,
    y UInt32,
    a DEFAULT x + y,
    b Float32 DEFAULT round(log(1 + x + y), 5),
    c UInt32 DEFAULT 42,
    e MATERIALIZED x + y,
    f ALIAS x + y
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO defaults FORMAT JSONEachRow;

INSERT INTO defaults (x, y) SELECT
    x,
    y
FROM defaults
LIMIT 1;

INSERT INTO defaults FORMAT JSONEachRow;

INSERT INTO defaults FORMAT JSONEachRow;

INSERT INTO defaults FORMAT JSONEachRow;

SELECT *
FROM defaults
ORDER BY (x, y) ASC;

ALTER TABLE defaults ADD COLUMN n Nested(a UInt64, b String);

INSERT INTO defaults FORMAT JSONEachRow;

SELECT *
FROM defaults
WHERE x = 7
FORMAT JSONEachRow;

ALTER TABLE defaults ADD COLUMN `n.c` Array(UInt8) DEFAULT arrayMap((x -> 0), n.a) AFTER n.a;

INSERT INTO defaults FORMAT JSONEachRow;

INSERT INTO defaults FORMAT JSONEachRow;

SELECT *
FROM defaults
WHERE x > 7
ORDER BY x ASC
FORMAT JSONEachRow;

DROP TABLE defaults;