-- Check for Block::sortColumns(), can be done using Buffer.
DROP TABLE IF EXISTS out_01277;

DROP TABLE IF EXISTS in_01277;

DROP TABLE IF EXISTS buffer_01277;

DROP TABLE IF EXISTS mv_01277_1;

DROP TABLE IF EXISTS mv_01277_2;

CREATE TABLE out_01277
(
    k1 Int,
    k2 Int,
    a1 Int,
    a2 Int,
    b1 Int,
    b2 Int,
    c Int
)
ENGINE = Null();

CREATE TABLE buffer_01277 AS out_01277
ENGINE = Buffer(currentDatabase(), out_01277, 1, 86400, 86400, 100000., 1000000., 10000000., 100000000.);

CREATE TABLE in_01277 AS out_01277
ENGINE = Null();

-- differs in order of fields in SELECT clause
CREATE MATERIALIZED VIEW mv_01277_1
TO buffer_01277
AS
SELECT
    k1,
    k2,
    a1,
    a2,
    b1,
    b2,
    c
FROM in_01277;

CREATE MATERIALIZED VIEW mv_01277_2
TO buffer_01277
AS
SELECT
    a1,
    a2,
    k1,
    k2,
    b1,
    b2,
    c
FROM in_01277;

-- column order is ignored, just for humans
INSERT INTO mv_01277_1 SELECT
    number AS k1,
    number AS k2,
    number AS a1,
    number AS a2,
    number AS b1,
    number AS b2,
    number AS c
FROM numbers(1);

-- with wrong order in Block::sortColumns() triggers:
--
--     Code: 171. DB::Exception: Received from localhost:9000. DB::Exception: Block structure mismatch in Buffer stream: different names of columns:
--     c Int32 Int32(size = 1), b2 Int32 Int32(size = 1), a2 Int32 Int32(size = 1), a1 Int32 Int32(size = 1), k2 Int32 Int32(size = 1), b1 Int32 Int32(size = 1), k1 Int32 Int32(size = 1)
--     c Int32 Int32(size = 1), b2 Int32 Int32(size = 1), k2 Int32 Int32(size = 1), a1 Int32 Int32(size = 1), b1 Int32 Int32(size = 1), k1 Int32 Int32(size = 1), a2 Int32 Int32(size = 1).
INSERT INTO mv_01277_2 SELECT
    number AS a1,
    number AS a2,
    number AS k1,
    number AS k2,
    number AS b1,
    number AS b2,
    number AS c
FROM numbers(1);

DROP TABLE mv_01277_1;

DROP TABLE mv_01277_2;

DROP TABLE buffer_01277;

DROP TABLE out_01277;

DROP TABLE in_01277;