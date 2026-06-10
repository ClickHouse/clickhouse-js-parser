-- https://github.com/ClickHouse/ClickHouse/issues/67042
-- Reference generated using percent_rank() and dense_rank()
-- From ClickHouse/tests/queries/0_stateless/01591_window_functions.sql  (for deterministic query)
SELECT '---- denseRank() ----';

SELECT
    number,
    p,
    o,
    count(*) OVER w,
    rank() OVER w,
    denseRank() OVER w,
    row_number() OVER w
FROM (
        SELECT
            number,
            intDiv(number, 5) AS p,
            mod(number, 3) AS o
        FROM numbers(31)
        ORDER BY
            o ASC,
            number ASC
    ) AS t
WINDOW w AS (PARTITION BY p ORDER BY o ASC, number ASC)
ORDER BY
    p ASC,
    o ASC,
    number ASC
SETTINGS max_block_size = '2';

DROP TABLE IF EXISTS product_groups;

DROP TABLE IF EXISTS products;

CREATE TABLE product_groups
(
    group_id Int64,
    group_name String
)
ENGINE = Memory();

CREATE TABLE products
(
    product_id Int64,
    product_name String,
    price DECIMAL(11, 2),
    group_id Int64
)
ENGINE = Memory();

INSERT INTO product_groups;

INSERT INTO products (product_id, product_name, group_id, price);

INSERT INTO product_groups;

INSERT INTO products (product_id, product_name, group_id, price);

SELECT *
FROM (
        SELECT
            product_name,
            group_name,
            price,
            rank() OVER (PARTITION BY group_name ORDER BY price ASC) AS rank,
            percentRank() OVER (PARTITION BY group_name ORDER BY price ASC) AS percent
        FROM
            products
        INNER JOIN product_groups
            USING (group_id)
    ) AS t
ORDER BY
    group_name ASC,
    price ASC,
    product_name ASC;

DROP TABLE product_groups;

DROP TABLE products;