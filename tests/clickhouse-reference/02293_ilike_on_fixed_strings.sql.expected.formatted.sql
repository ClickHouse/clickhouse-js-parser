DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    col FixedString(2)
)
ENGINE = MergeTree()
ORDER BY col;

INSERT INTO tab;

SELECT
    col,
    col LIKE '%a',
    col ILIKE '%a'
FROM tab
WHERE col = 'AA';