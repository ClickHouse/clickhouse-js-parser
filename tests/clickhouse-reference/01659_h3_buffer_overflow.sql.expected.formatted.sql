-- Tags: no-fasttest
-- the behaviour on overflow can be implementation specific
-- and we don't care about the results, but no buffer overflow should be possible.
SELECT length(h3kRing(9223372036854775807, 1000))
FORMAT Null; -- { serverError INCORRECT_DATA }

SELECT h3kRing(toUInt64(4294967295), 1000)
FORMAT Null; -- { serverError INCORRECT_DATA }

SELECT h3kRing(68719476735, 1000)
FORMAT Null; -- { serverError INCORRECT_DATA }

SELECT h3kRing(72057594037927935, 1000)
FORMAT Null; -- { serverError INCORRECT_DATA }

SELECT h3GetBaseCell(72057594037927935)
FORMAT Null;

SELECT h3GetResolution(72057594037927935)
FORMAT Null;

SELECT h3kRing(72057594037927935, toUInt16(10))
FORMAT Null; -- { serverError INCORRECT_DATA }

SELECT h3ToGeo(72057594037927935)
FORMAT Null; -- { serverError INCORRECT_DATA }

SELECT h3HexRing(72057594037927935, toUInt16(10))
FORMAT Null; -- { serverError INCORRECT_DATA }

SELECT h3HexRing(72057594037927935, toUInt16(10000))
FORMAT Null; -- { serverError INCORRECT_DATA }

SELECT length(h3HexRing(581276613233082367, toUInt16(1)))
FORMAT Null;