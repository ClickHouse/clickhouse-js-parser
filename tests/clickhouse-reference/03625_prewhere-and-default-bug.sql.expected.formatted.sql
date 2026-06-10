DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    d DateTime64(3),
    p LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY toDate(d);

INSERT INTO tab SELECT
    toDateTime(toDate('2000-01-01')) + number,
    if(bitAnd(number, 1) = 0, 'a', 'b')
FROM numbers(100);

ALTER TABLE tab ADD COLUMN t String DEFAULT '' SETTINGS alter_sync = '2';

SELECT 1
FROM tab
WHERE d > toDateTime(toDate('2000-01-01'))
    AND p IN ('a')
    AND 1 = 1
GROUP BY
    d,
    t,
    p;