CREATE TABLE distributor
(
    id String,
    name String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE product
(
    id String,
    name String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE sales
(
    id String,
    distributor String,
    product String,
    amount Float32
)
ENGINE = MergeTree()
ORDER BY id;

SELECT *
FROM
    view(    SELECT *
    FROM
        sales
    LEFT JOIN distributor
        ON distributor.id = sales.distributor) AS newSales
LEFT JOIN product
    ON product.id = newSales.product
SETTINGS enable_analyzer = '1';