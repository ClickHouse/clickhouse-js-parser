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

CREATE ROW POLICY filter ON tbl USING s = 'non_existing_domain' TO ALL;

SELECT *
FROM tbl
PREWHERE s = '123'
WHERE i = 123;

DROP ROW POLICY filter ON tbl;

DROP TABLE tbl;