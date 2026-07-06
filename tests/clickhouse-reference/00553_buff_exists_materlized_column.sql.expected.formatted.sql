DROP TABLE IF EXISTS nums;

DROP TABLE IF EXISTS nums_buf;

SET insert_allow_materialized_columns = '1';

CREATE TABLE nums
(
    n UInt64,
    m UInt64 MATERIALIZED n + 1
)
ENGINE = Log();

CREATE TABLE nums_buf AS nums
ENGINE = Buffer(currentDatabase(), nums, 1, 10, 100, 1, 3, 10000000, 100000000);

INSERT INTO nums_buf (n);

INSERT INTO nums_buf (n);

INSERT INTO nums_buf (n);

INSERT INTO nums_buf (n);

INSERT INTO nums_buf (n);

SELECT
    n,
    m
FROM nums
ORDER BY n ASC;

SELECT
    n,
    m
FROM nums_buf
ORDER BY n ASC;