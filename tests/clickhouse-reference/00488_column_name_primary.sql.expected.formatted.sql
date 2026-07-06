DROP TABLE IF EXISTS primary;

CREATE TABLE primary
(
    primary String
)
ENGINE = MergeTree()
ORDER BY primary
SETTINGS min_bytes_for_wide_part = '0' AS
SELECT *
FROM numbers(1000);

SELECT max(primary)
FROM primary;

DROP TABLE primary;