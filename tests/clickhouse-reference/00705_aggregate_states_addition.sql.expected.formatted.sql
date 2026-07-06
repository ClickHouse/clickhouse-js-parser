SET send_logs_level = 'fatal';

DROP TABLE IF EXISTS add_aggregate;

CREATE TABLE add_aggregate
(
    a UInt32,
    b UInt32
)
ENGINE = Memory();

INSERT INTO add_aggregate;

INSERT INTO add_aggregate;

SELECT countMerge(x + y)
FROM (
        SELECT
            countState(a) AS x,
            countState(b) AS y
        FROM add_aggregate
    );

SELECT
    sumMerge(x + y),
    sumMerge(x),
    sumMerge(y)
FROM (
        SELECT
            sumState(a) AS x,
            sumState(b) AS y
        FROM add_aggregate
    );

SELECT sumMerge(x)
FROM (
        SELECT sumState(a) + countState(b) AS x
        FROM add_aggregate
    ); -- { serverError CANNOT_ADD_DIFFERENT_AGGREGATE_STATES }

SELECT sumMerge(x)
FROM (
        SELECT sumState(a) + sumState(toInt32(b)) AS x
        FROM add_aggregate
    ); -- { serverError CANNOT_ADD_DIFFERENT_AGGREGATE_STATES }

SELECT minMerge(x)
FROM (
        SELECT minState(a) + minState(b) AS x
        FROM add_aggregate
    );

SELECT uniqMerge(x + y)
FROM (
        SELECT
            uniqState(a) AS x,
            uniqState(b) AS y
        FROM add_aggregate
    );

SELECT arraySort(groupArrayMerge(x + y))
FROM (
        SELECT
            groupArrayState(a) AS x,
            groupArrayState(b) AS y
        FROM add_aggregate
    );

SELECT arraySort(groupUniqArrayMerge(x + y))
FROM (
        SELECT
            groupUniqArrayState(a) AS x,
            groupUniqArrayState(b) AS y
        FROM add_aggregate
    );

SELECT uniqMerge(x + y)
FROM (
        SELECT
            uniqState(65536, a) AS x,
            uniqState(b) AS y
        FROM add_aggregate
    ); -- { serverError CANNOT_ADD_DIFFERENT_AGGREGATE_STATES }