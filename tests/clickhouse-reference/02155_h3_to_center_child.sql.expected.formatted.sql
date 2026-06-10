-- Tags: no-fasttest
DROP TABLE IF EXISTS h3_indexes;

--Note: id column just exists to keep the test results sorted.
-- Order is not guaranteed with h3_index or res columns as we test the same h3_index at various resolutions.
CREATE TABLE h3_indexes
(
    id UInt8,
    h3_index UInt64,
    res UInt8
)
ENGINE = Memory();

-- Test cases taken from fixture: https://github.com/uber/h3/blob/master/src/apps/testapps/testCellToCenterChild.c
INSERT INTO h3_indexes;

SELECT h3ToCenterChild(h3_index, res)
FROM h3_indexes
ORDER BY id ASC;

DROP TABLE h3_indexes;