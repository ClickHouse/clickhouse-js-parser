-- https://stackoverflow.com/questions/53416531/clickhouse-moving-average
DROP TABLE IF EXISTS bm;

CREATE TABLE bm
(
    amount float,
    business_dttm DateTime
)
ENGINE = Log();

INSERT INTO bm;

WITH (
        SELECT arrayCumSum(groupArray(amount))
        FROM (
                SELECT amount
                FROM bm
                ORDER BY business_dttm ASC
            )
    ) AS arr,

1 + rowNumberInAllBlocks() AS id,

3 AS window_size

SELECT
    amount,
    business_dttm,
    if(id < window_size, NULL, round(arr[id] - arr[id - window_size], 4)) AS moving_sum
FROM (
        SELECT
            amount,
            business_dttm
        FROM bm
        ORDER BY business_dttm ASC
    )
ORDER BY business_dttm ASC;

DROP TABLE bm;