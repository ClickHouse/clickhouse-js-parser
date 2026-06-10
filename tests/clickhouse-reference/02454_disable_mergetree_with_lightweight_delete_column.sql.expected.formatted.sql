-- Tags: memory-engine
DROP TABLE IF EXISTS t_row_exists;

CREATE TABLE t_row_exists
(
    a int,
    _row_exists int
)
ENGINE = MergeTree()
ORDER BY a; --{serverError ILLEGAL_COLUMN}

CREATE TABLE t_row_exists
(
    a int,
    b int
)
ENGINE = MergeTree()
ORDER BY a;

ALTER TABLE t_row_exists ADD COLUMN _row_exists int; --{serverError ILLEGAL_COLUMN}

ALTER TABLE t_row_exists RENAME COLUMN b TO _row_exists; --{serverError ILLEGAL_COLUMN}

ALTER TABLE t_row_exists RENAME COLUMN _row_exists TO c; --{serverError NOT_FOUND_COLUMN_IN_BLOCK}

ALTER TABLE t_row_exists DROP COLUMN _row_exists; --{serverError NOT_FOUND_COLUMN_IN_BLOCK}

ALTER TABLE t_row_exists DROP COLUMN unknown_column; --{serverError NOT_FOUND_COLUMN_IN_BLOCK}

DROP TABLE t_row_exists;

CREATE TABLE t_row_exists
(
    a int,
    _row_exists int
)
ENGINE = Memory();

INSERT INTO t_row_exists;

SELECT *
FROM t_row_exists;

CREATE TABLE t_row_exists
(
    a int,
    b int
)
ENGINE = Memory();