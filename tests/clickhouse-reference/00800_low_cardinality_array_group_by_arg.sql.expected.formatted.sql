DROP TABLE IF EXISTS table1;

DROP TABLE IF EXISTS table2;

CREATE TABLE table1
(
    dt Date,
    id Int32,
    arr Array(LowCardinality(String))
)
ENGINE = MergeTree()
ORDER BY (dt, id)
PARTITION BY toMonday(dt)
SETTINGS index_granularity = '8192';

CREATE TABLE table2
(
    dt Date,
    id Int32,
    arr Array(LowCardinality(String))
)
ENGINE = MergeTree()
ORDER BY (dt, id)
PARTITION BY toMonday(dt)
SETTINGS index_granularity = '8192';

INSERT INTO table1 (dt, id, arr);

INSERT INTO table2 (dt, id, arr);

SELECT
    dt,
    id,
    arraySort(groupArrayArray(arr))
FROM (
        SELECT
            dt,
            id,
            arr
        FROM table1
        WHERE dt = '2019-01-14'
            AND id = 1
        UNION ALL
        SELECT
            dt,
            id,
            arr
        FROM table2
        WHERE dt = '2019-01-14'
            AND id = 1
    )
GROUP BY
    dt,
    id;

DROP TABLE table1;

DROP TABLE table2;