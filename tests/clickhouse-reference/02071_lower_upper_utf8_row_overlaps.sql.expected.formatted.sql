-- Tags: no-fasttest
-- no-fasttest: upper/lowerUTF8 use ICU
DROP TABLE IF EXISTS utf8_overlap;

CREATE TABLE utf8_overlap
(
    str String
)
ENGINE = Memory();

-- { echoOn }
-- NOTE: total string size should be > 16 (sizeof(__m128i))
INSERT INTO utf8_overlap;

--                                             ^
--                                             MONOGRAM FOR YANG
WITH lowerUTF8(str) AS l_,

upperUTF8(str) AS u_,

'0x' || hex(str) AS h_

SELECT
    length(str),
    if(l_ = '�', h_, l_),
    if(u_ = '�', h_, u_)
FROM utf8_overlap
FORMAT CSV;

-- NOTE: regression test for introduced bug
-- https://github.com/ClickHouse/ClickHouse/issues/42756
SELECT lowerUTF8('КВ АМ И СЖ');

SELECT upperUTF8('кв ам и сж');

SELECT lowerUTF8('КВ АМ И СЖ КВ АМ И СЖ');

SELECT upperUTF8('кв ам и сж кв ам и сж');

-- Test at 32 and 64 byte boundaries
SELECT lowerUTF8(repeat('0', 16) || 'КВ АМ И СЖ');

SELECT upperUTF8(repeat('0', 16) || 'кв ам и сж');

SELECT lowerUTF8(repeat('0', 48) || 'КВ АМ И СЖ');

SELECT upperUTF8(repeat('0', 48) || 'кв ам и сж');