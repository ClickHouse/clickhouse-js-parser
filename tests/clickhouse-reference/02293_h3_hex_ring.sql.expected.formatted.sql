-- Tags: no-fasttest
SELECT h3HexRing(581276613233082367, toUInt16(0));

SELECT h3HexRing(579205132326352334, toUInt16(1)) AS hexRing; -- { serverError INCORRECT_DATA }

SELECT h3HexRing(581276613233082367, -1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT h3HexRing(581276613233082367, toUInt16(-1)); -- { serverError PARAMETER_OUT_OF_BOUND }

DROP TABLE IF EXISTS h3_indexes;

-- Test h3 indices and k selected from original test fixture: https://github.com/uber/h3/blob/master/src/apps/testapps
CREATE TABLE h3_indexes
(
    h3_index UInt64,
    k UInt16
)
ENGINE = Memory();

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

SELECT arraySort(h3HexRing(h3_index, k))
FROM h3_indexes
ORDER BY h3_index ASC;

DROP TABLE h3_indexes;