-- Tags: no-fasttest
DROP TABLE IF EXISTS h3_indexes;

CREATE TABLE h3_indexes
(
    id int,
    start String,
    `end` String
)
ENGINE = Memory();

-- test values taken from h3 library test suite
INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

SELECT h3Distance(stringToH3(start), stringToH3(`end`))
FROM h3_indexes
ORDER BY id ASC;

DROP TABLE h3_indexes;