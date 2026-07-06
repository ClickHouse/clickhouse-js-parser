-- Tags: no-fasttest
DROP TABLE IF EXISTS h3_indexes;

CREATE TABLE h3_indexes
(
    h3_index UInt64
)
ENGINE = Memory();

-- Coordinates from h3ToGeo test.
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

SELECT arrayMap((p -> (round((p).1, 2), round((p).2, 2))), h3ToGeoBoundary(h3_index))
FROM h3_indexes
ORDER BY h3_index ASC;

DROP TABLE h3_indexes;