SELECT '----- START -----';

DROP TABLE IF EXISTS morton_numbers_02457;

CREATE TABLE morton_numbers_02457
(
    n1 UInt32,
    n2 UInt32,
    n3 UInt16,
    n4 UInt16,
    n5 UInt8,
    n6 UInt8,
    n7 UInt8,
    n8 UInt8
)
ENGINE = MergeTree()
ORDER BY n1
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SELECT mortonEncode(1, 2, 3, 4);

SELECT mortonDecode(4, 2149);

SELECT mortonEncode(65534, 65533);

SELECT mortonDecode(2, 4294967286);

SELECT mortonEncode(4294967286);

SELECT mortonDecode(1, 4294967286);

INSERT INTO morton_numbers_02457 SELECT
    n1.number,
    n2.number,
    n3.number,
    n4.number,
    n5.number,
    n6.number,
    n7.number,
    n8.number
FROM
    numbers(256 - 4, 4) AS n1
CROSS JOIN numbers(256 - 4, 4) AS n2
CROSS JOIN numbers(256 - 4, 4) AS n3
CROSS JOIN numbers(256 - 4, 4) AS n4
CROSS JOIN numbers(256 - 4, 4) AS n5
CROSS JOIN numbers(256 - 4, 4) AS n6
CROSS JOIN numbers(256 - 4, 4) AS n7
CROSS JOIN numbers(256 - 4, 4) AS n8;

DROP TABLE IF EXISTS morton_numbers_1_02457;

CREATE TABLE morton_numbers_1_02457
(
    n1 UInt64,
    n2 UInt64,
    n3 UInt64,
    n4 UInt64,
    n5 UInt64,
    n6 UInt64,
    n7 UInt64,
    n8 UInt64
)
ENGINE = MergeTree()
ORDER BY n1
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO morton_numbers_1_02457 SELECT untuple(mortonDecode(8, mortonEncode(n1, n2, n3, n4, n5, n6, n7, n8)))
FROM morton_numbers_02457;

(SELECT *
FROM morton_numbers_02457
UNION DISTINCT
SELECT *
FROM morton_numbers_1_02457)
EXCEPT
(SELECT *
FROM morton_numbers_02457
INTERSECT
SELECT *
FROM morton_numbers_1_02457);

INSERT INTO morton_numbers_02457 SELECT
    n1.number,
    n2.number,
    n3.number,
    n4.number,
    0,
    0,
    0,
    0
FROM
    numbers(pow(2, 16) - 8, 8) AS n1
CROSS JOIN numbers(pow(2, 16) - 8, 8) AS n2
CROSS JOIN numbers(pow(2, 16) - 8, 8) AS n3
CROSS JOIN numbers(pow(2, 16) - 8, 8) AS n4;

CREATE TABLE morton_numbers_2_02457
(
    n1 UInt64,
    n2 UInt64,
    n3 UInt64,
    n4 UInt64
)
ENGINE = MergeTree()
ORDER BY n1
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO morton_numbers_2_02457 SELECT untuple(mortonDecode(4, mortonEncode(n1, n2, n3, n4)))
FROM morton_numbers_02457;

(SELECT
    n1,
    n2,
    n3,
    n4
FROM morton_numbers_02457
UNION DISTINCT
SELECT
    n1,
    n2,
    n3,
    n4
FROM morton_numbers_2_02457)
EXCEPT
(SELECT
    n1,
    n2,
    n3,
    n4
FROM morton_numbers_02457
INTERSECT
SELECT
    n1,
    n2,
    n3,
    n4
FROM morton_numbers_2_02457);

DROP TABLE IF EXISTS morton_numbers_2_02457;

INSERT INTO morton_numbers_02457 SELECT
    n1.number,
    n2.number,
    0,
    0,
    0,
    0,
    0,
    0
FROM
    numbers(pow(2, 32) - 8, 8) AS n1
CROSS JOIN numbers(pow(2, 32) - 8, 8) AS n2
CROSS JOIN numbers(pow(2, 32) - 8, 8) AS n3
CROSS JOIN numbers(pow(2, 32) - 8, 8) AS n4;

DROP TABLE IF EXISTS morton_numbers_3_02457;

CREATE TABLE morton_numbers_3_02457
(
    n1 UInt64,
    n2 UInt64
)
ENGINE = MergeTree()
ORDER BY n1
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO morton_numbers_3_02457 SELECT untuple(mortonDecode(2, mortonEncode(n1, n2)))
FROM morton_numbers_02457;

(SELECT
    n1,
    n2
FROM morton_numbers_3_02457
UNION DISTINCT
SELECT
    n1,
    n2
FROM morton_numbers_3_02457)
EXCEPT
(SELECT
    n1,
    n2
FROM morton_numbers_3_02457
INTERSECT
SELECT
    n1,
    n2
FROM morton_numbers_3_02457);