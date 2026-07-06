DROP TABLE IF EXISTS lc_00800_1;

CREATE TABLE lc_00800_1
(
    names Array(LowCardinality(String))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO lc_00800_1;

INSERT INTO lc_00800_1 SELECT emptyArrayString();

SELECT *
FROM lc_00800_1;