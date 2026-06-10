DROP TABLE IF EXISTS table1;

CREATE TABLE table1
(
    str1 String,
    str2 String
)
ENGINE = Memory();

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

SELECT CRC32('string');

SELECT
    CrC32('string'),
    crc32('test'); -- We want to test, that function name is case-insensitive

SELECT CRC32(str1)
FROM table1
ORDER BY CRC32(str1) ASC;

SELECT CRC32(str2)
FROM table1
ORDER BY CRC32(str2) ASC;

SELECT
    CRC32(str1),
    CRC32(str2)
FROM table1
ORDER BY
    CRC32(str1) ASC,
    CRC32(str2) ASC;

SELECT
    str1,
    str2,
    CRC32(str1),
    CRC32(str2)
FROM table1
ORDER BY
    CRC32(str1) ASC,
    CRC32(str2) ASC;

DROP TABLE table1;

SELECT hex(CRC32IEEE('foo'));

SELECT hex(CRC64('foo'));