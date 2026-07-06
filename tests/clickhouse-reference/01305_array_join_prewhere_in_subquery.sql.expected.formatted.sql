DROP TABLE IF EXISTS h;

CREATE TABLE h
(
    EventDate Date,
    CounterID UInt64,
    WatchID UInt64
)
ENGINE = MergeTree()
ORDER BY (CounterID, EventDate);

INSERT INTO h;

SELECT count()
FROM
    h
ARRAY JOIN [1] AS a
PREWHERE WatchID IN (
        SELECT toUInt64(1)
    )
WHERE EventDate = '2020-06-10'
    AND CounterID = 16671268;