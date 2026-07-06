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
            percent_rank() OVER (PARTITION BY group_name ORDER BY price ASC) AS percent
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

SELECT
    number,
    row_number,
    CAST(percent_rank * 10000 AS Int32) AS percent_rank
FROM (
        SELECT
            number,
            row_number() OVER () AS row_number,
            percent_rank() OVER (ORDER BY number ASC) AS percent_rank
        FROM numbers(10000)
        ORDER BY number ASC
        LIMIT 10
    )
SETTINGS max_block_size = '100';