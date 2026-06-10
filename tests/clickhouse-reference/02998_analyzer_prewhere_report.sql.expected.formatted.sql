--https://github.com/ClickHouse/ClickHouse/issues/60232
CREATE TABLE hits
(
    date Date,
    data Array(UInt32)
)
ENGINE = MergeTree()
ORDER BY date
PARTITION BY toYYYYMM(date);

INSERT INTO hits;

SELECT
    hits.date,
    arrayFilter((x -> x IN (2, 3)), data) AS filtered
FROM hits
WHERE arrayExists((x -> x IN (2, 3)), data)
SETTINGS enable_analyzer = '1';