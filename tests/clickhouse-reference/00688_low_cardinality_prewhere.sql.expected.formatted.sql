DROP TABLE IF EXISTS lc_prewhere;

CREATE TABLE lc_prewhere
(
    key UInt64,
    val UInt64,
    str LowCardinality(String),
    s String
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS index_granularity = '8192';

INSERT INTO lc_prewhere SELECT
    number,
    if(number < 10
    OR number > 8192 * 9, 1, 0),
    toString(number) AS s,
    s
FROM `system`.numbers
LIMIT 100000;

SELECT
    sum(toUInt64(str)),
    sum(toUInt64(s))
FROM lc_prewhere
PREWHERE val = 1;