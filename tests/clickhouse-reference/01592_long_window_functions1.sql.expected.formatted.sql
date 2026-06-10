-- Tags: long
-- test became more than an order of magnitude slower with max_bytes_before_external_sort=1
SET max_bytes_before_external_sort = '0';

SET max_bytes_ratio_before_external_sort = '0';

DROP TABLE IF EXISTS stack;

SET max_insert_threads = '4';

CREATE TABLE stack
(
    item_id Int64,
    brand_id Int64,
    rack_id Int64,
    dt DateTime,
    expiration_dt DateTime,
    quantity UInt64
)
ENGINE = MergeTree()
ORDER BY (brand_id, toStartOfHour(dt))
PARTITION BY toYYYYMM(dt)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO stack SELECT
    number % 99991,
    number % 11,
    number % 1111,
    toDateTime('2020-01-01 00:00:00') + number / 100,
    toDateTime('2020-02-01 00:00:00') + number / 10,
    intDiv(number, 100) + 1
FROM numbers_mt(1000000);

SELECT '---- arrays ----';

SELECT cityHash64(toString(groupArray(tuple(*))))
FROM (
        SELECT
            brand_id,
            rack_id,
            arrayJoin(arraySlice(arraySort(groupArray(quantity)), 1, 2)) AS quantity
        FROM stack
        GROUP BY
            brand_id,
            rack_id
        ORDER BY
            brand_id ASC,
            rack_id ASC,
            quantity ASC
    ) AS t;

SELECT cityHash64(toString(groupArray(tuple(*))))
FROM (
        SELECT
            brand_id,
            rack_id,
            quantity
        FROM (
                SELECT
                    brand_id,
                    rack_id,
                    quantity,
                    row_number() OVER (PARTITION BY brand_id, rack_id ORDER BY quantity ASC) AS rn
                FROM stack
            ) AS t0
        WHERE rn <= 2
        ORDER BY
            brand_id ASC,
            rack_id ASC,
            quantity ASC
    ) AS t;