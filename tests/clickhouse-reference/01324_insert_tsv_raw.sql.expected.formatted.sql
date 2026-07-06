DROP TABLE IF EXISTS tsv_raw;

CREATE TABLE tsv_raw
(
    strval String,
    intval Int64,
    b1 String,
    b2 String,
    b3 String,
    b4 String
)
ENGINE = Memory();

INSERT INTO tsv_raw FORMAT TSVRaw;

SELECT *
FROM tsv_raw
FORMAT JSONCompactEachRow;

DROP TABLE tsv_raw;