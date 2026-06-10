SELECT
    (toDate('2017-01-01') AS base) + toIntervalMonth(number) AS d,
    toDateTime(d, 'UTC') AS t,
    toQuarter(d) AS qd,
    toQuarter(t) AS qt,
    toStartOfQuarter(d) AS sqd,
    toStartOfQuarter(t) AS sqt,
    toRelativeQuarterNum(d) - toRelativeQuarterNum(base) AS qdiff_d,
    toRelativeQuarterNum(t) - toRelativeQuarterNum(base) AS qdiff_t
FROM `system`.numbers
LIMIT 24;