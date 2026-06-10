DROP TABLE IF EXISTS dst_00753;

DROP TABLE IF EXISTS buffer_00753;

SET send_logs_level = 'error';

CREATE TABLE dst_00753
(
    x UInt64,
    y UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE buffer_00753
(
    x UInt64,
    y UInt64
)
ENGINE = Buffer(currentDatabase(), dst_00753, 1, 99999, 99999, 1, 1, 99999, 99999);

INSERT INTO buffer_00753;

INSERT INTO buffer_00753;

INSERT INTO buffer_00753;

SELECT *
FROM dst_00753
ORDER BY x ASC;

SELECT *
FROM buffer_00753
ORDER BY x ASC;

ALTER TABLE dst_00753 DROP COLUMN x, MODIFY COLUMN y String, ADD COLUMN z String DEFAULT 'DEFZ';

INSERT INTO buffer_00753;

SELECT *
FROM dst_00753
ORDER BY y ASC;

SELECT *
FROM buffer_00753
ORDER BY y ASC;

OPTIMIZE TABLE buffer_00753;

SET send_logs_level = 'warning';