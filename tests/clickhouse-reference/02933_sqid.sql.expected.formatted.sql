-- Tags: no-fasttest
SET allow_suspicious_low_cardinality_types = '1';

SELECT '-- negative tests';

SELECT sqidEncode(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT sqidDecode(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT sqidEncode('1'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT sqidDecode(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    sqidEncode(1) AS sqid,
    sqidDecode(sqid);

SELECT
    sqidEncode(1, 2) AS sqid,
    sqidDecode(sqid);

SELECT
    sqidEncode(1, 2, 3) AS sqid,
    sqidDecode(sqid);

SELECT
    sqidEncode(CAST('1' AS UInt8), CAST('2' AS UInt16), CAST('3' AS UInt32), CAST('4' AS UInt64)) AS sqid,
    sqidDecode(sqid);

SELECT sqidEncode(toNullable(1), toLowCardinality(2)) AS sqid;

SELECT sqidDecode('1');

SELECT
    sqidEncode(materialize(1)) AS sqid,
    sqidDecode(sqid);

SELECT
    sqidEncode(materialize(1), materialize(2)) AS sqid,
    sqidDecode(sqid);

SELECT
    sqidEncode(materialize(1), materialize(2), materialize(3)) AS sqid,
    sqidDecode(sqid);

SELECT
    sqidEncode(materialize(CAST('1' AS UInt8)), materialize(CAST('2' AS UInt16)), materialize(CAST('3' AS UInt32)), materialize(CAST('4' AS UInt64))) AS sqid,
    sqidDecode(sqid);

SELECT sqidEncode(toNullable(materialize(1)), toLowCardinality(materialize(2)));

SELECT sqidDecode('invalid sqid');

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab SELECT *
FROM generateRandom()
LIMIT 1000000;

SELECT sqidDecode(id)
FROM tab
FORMAT Null;

DROP TABLE tab;

SELECT sqid(1, 2);