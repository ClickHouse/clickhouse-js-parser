DROP TABLE IF EXISTS tesd_dedupl;

CREATE TABLE tesd_dedupl
(
    x UInt32,
    y UInt32
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO tesd_dedupl;

OPTIMIZE TABLE tesd_dedupl DEDUPLICATE;

SELECT *
FROM tesd_dedupl;