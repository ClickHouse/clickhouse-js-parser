DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    a LowCardinality(String),
    b LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY a
SETTINGS min_bytes_for_wide_part = '0', min_rows_for_wide_part = '0';

INSERT INTO tab;

SELECT a = '1'
FROM tab
WHERE a = '1'
    AND b = 'a';

-- Fuzzed
SELECT *
FROM tab
WHERE a = '1'
    AND 0
    AND b = 'a';