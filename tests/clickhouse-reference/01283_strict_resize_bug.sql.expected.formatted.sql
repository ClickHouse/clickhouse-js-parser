DROP TABLE IF EXISTS num_10m;

CREATE TABLE num_10m
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO num_10m SELECT *
FROM numbers(10000000);

SELECT *
FROM (
        SELECT sum(number)
        FROM num_10m
        UNION ALL
        SELECT sum(number)
        FROM num_10m
    )
LIMIT 1
SETTINGS max_block_size = '1024';