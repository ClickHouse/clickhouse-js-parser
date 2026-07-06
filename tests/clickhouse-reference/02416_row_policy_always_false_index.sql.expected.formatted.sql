DROP TABLE IF EXISTS tbl;

CREATE TABLE tbl
(
    s String,
    i int
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO tbl;

DROP ROW POLICY IF EXISTS filter ON tbl;

CREATE ROW POLICY filter ON tbl USING 0 TO ALL;

SET max_rows_to_read = '0';

SELECT *
FROM tbl;

DROP ROW POLICY filter ON tbl;

DROP TABLE tbl;