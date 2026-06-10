-- Tags: no-fasttest
DROP TABLE IF EXISTS h3_indexes;

CREATE TABLE h3_indexes
(
    h3_index UInt64
)
ENGINE = Memory();

-- test H3 indexes from: https://github.com/uber/h3-java/blob/master/src/test/java/com/uber/h3core/TestInspection.java#L78
INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

INSERT INTO h3_indexes;

SELECT h3IsPentagon(h3_index)
FROM h3_indexes
ORDER BY h3_index ASC;

DROP TABLE h3_indexes;