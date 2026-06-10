CREATE TABLE user
(
    id UInt32,
    name String
)
ENGINE = Join(`ANY`, `LEFT`, id);

INSERT INTO user;

CREATE TABLE product
(
    id UInt32,
    name String,
    cate String
)
ENGINE = Join(`ANY`, `LEFT`, id);

INSERT INTO product;

CREATE TABLE `order`
(
    id UInt32,
    pId UInt32,
    uId UInt32
)
ENGINE = TinyLog();

INSERT INTO `order`;

SELECT ignore(*)
FROM (
        SELECT
            uId,
            user.id AS uuu
        FROM
            `order`
        ANY LEFT JOIN user
            ON uId = uuu
    );

SELECT ignore(*)
FROM
    `order`
ANY LEFT JOIN user
    ON uId = user.id
ANY LEFT JOIN product
    ON pId = product.id;