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

SELECT '---- Q1 ----';

SELECT
    product_name,
    price,
    group_name,
    AVG(price) OVER (PARTITION BY group_name)
FROM
    products
INNER JOIN product_groups
    USING (group_id)
ORDER BY
    group_name ASC,
    product_name ASC,
    price ASC;

SELECT
    product_name,
    group_name,
    price,
    rank() OVER (PARTITION BY group_name ORDER BY price ASC) AS rank
FROM
    products
INNER JOIN product_groups
    USING (group_id)
ORDER BY
    group_name ASC,
    rank ASC,
    price ASC,
    product_name ASC;

SELECT
    product_name,
    group_name,
    price,
    row_number() OVER (PARTITION BY group_name ORDER BY price DESC, product_name ASC) AS rn
FROM
    products
INNER JOIN product_groups
    USING (group_id)
ORDER BY
    group_name ASC,
    rn ASC;

SELECT *
FROM (
        SELECT
            product_name,
            group_name,
            price,
            min(price) OVER (PARTITION BY group_name) AS min_price,
            dense_rank() OVER (PARTITION BY group_name ORDER BY price ASC) AS r
        FROM
            products
        INNER JOIN product_groups
            USING (group_id)
    ) AS t
WHERE min_price > 160
ORDER BY
    group_name ASC,
    r ASC,
    product_name ASC;

SELECT
    product_name,
    group_name,
    price,
    FIRST_VALUE(price) OVER (PARTITION BY group_name ORDER BY product_name DESC) AS price_per_group_per_alphab
FROM
    products
INNER JOIN product_groups
    USING (group_id)
ORDER BY
    group_name ASC,
    product_name DESC;

SELECT
    product_name,
    group_name,
    price,
    LAST_VALUE(price) OVER (PARTITION BY group_name ORDER BY price ASC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS highest_price_per_group
FROM
    products
INNER JOIN product_groups
    USING (group_id)
ORDER BY
    group_name ASC,
    product_name ASC;

SELECT
    product_name,
    price,
    group_name,
    round(avg0),
    round(avg1)
FROM (
        SELECT
            product_name,
            price,
            group_name,
            avg(price) OVER (PARTITION BY group_name ORDER BY price ASC) AS avg0,
            avg(price) OVER (PARTITION BY group_name ORDER BY price ASC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS avg1
        FROM
            products
        INNER JOIN product_groups
            USING (group_id)
    ) AS t
ORDER BY
    group_name ASC,
    product_name ASC,
    price ASC;

DROP TABLE product_groups;

DROP TABLE products;