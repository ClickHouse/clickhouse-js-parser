DROP TABLE IF EXISTS lc_00752;

DROP TABLE IF EXISTS lc_mv_00752;

CREATE TABLE lc_00752
(
    str LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO lc_00752;

CREATE MATERIALIZED VIEW lc_mv_00752
ENGINE = AggregatingMergeTree()
ORDER BY tuple()
POPULATE
AS
SELECT
    substring(str, 1, 1) AS letter,
    min(length(str)) AS min_len,
    max(length(str)) AS max_len
FROM lc_00752
GROUP BY substring(str, 1, 1);

SELECT *
FROM lc_mv_00752
ORDER BY letter ASC;