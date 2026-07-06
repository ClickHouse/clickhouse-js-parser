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

/*
Given two H3 indexes, return the line of indexes between them (inclusive).
This function may fail to find the line between two indexes, for example if they are very far apart.
It may also fail when finding distances for indexes on opposite sides of a pentagon.

Notes:
    The specific output of this function should not be considered stable across library versions.
    The only guarantees the library provides are that the line length will be h3Distance(start, end) + 1
    and that every index in the line will be a neighbor of the preceding index.
    Lines are drawn in grid space, and may not correspond exactly to either Cartesian lines or great arcs.

https://h3geo.org/docs/api/traversal
 */
SELECT length(h3Line(stringToH3(start), stringToH3(`end`)))
FROM h3_indexes
ORDER BY id ASC;

SELECT h3Line(72057594037927935, 72057594037927935); -- { serverError INCORRECT_DATA }

DROP TABLE h3_indexes;