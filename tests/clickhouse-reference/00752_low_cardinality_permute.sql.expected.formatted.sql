DROP TABLE IF EXISTS lc_perm;

CREATE TABLE lc_perm
(
    val UInt32,
    str LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY val;

INSERT INTO lc_perm;

SELECT *
FROM lc_perm
ORDER BY val ASC;

SELECT str
FROM lc_perm
WHERE val < 12
ORDER BY str ASC;