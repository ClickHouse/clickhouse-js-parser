DROP TABLE IF EXISTS series;

CREATE TABLE series
(
    i UInt32,
    x Float64,
    y Float64
)
ENGINE = Memory();

INSERT INTO series (i, x, y);

SELECT
    std(x),
    std(y)
FROM series;

SELECT
    stddevPop(x),
    stddevPop(y)
FROM series;

DROP TABLE series;