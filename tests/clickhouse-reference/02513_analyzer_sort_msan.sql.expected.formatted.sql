DROP TABLE IF EXISTS products;

SET enable_analyzer = '1';

CREATE TABLE products
(
    price UInt32
)
ENGINE = Memory();

INSERT INTO products;

SELECT rank() OVER (ORDER BY price ASC) AS rank
FROM products
ORDER BY rank ASC;