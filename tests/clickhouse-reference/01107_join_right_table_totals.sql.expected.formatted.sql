DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    item_id UInt64,
    price_sold Float32,
    date Date
)
ENGINE = MergeTree()
ORDER BY item_id;

SELECT item_id
FROM
    (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
    ) AS l
FULL JOIN (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS r
    USING (item_id);

SELECT id
FROM
    (
        SELECT item_id AS id
        FROM t
        GROUP BY id
        WITH TOTALS
    ) AS l
FULL JOIN (
        SELECT item_id AS id
        FROM t
        GROUP BY id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS r
    USING (id);

SELECT item_id
FROM
    (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
    ) AS l
INNER JOIN (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS r
    USING (item_id);

SELECT id
FROM
    (
        SELECT item_id AS id
        FROM t
        GROUP BY id
        WITH TOTALS
    ) AS l
INNER JOIN (
        SELECT item_id AS id
        FROM t
        GROUP BY id
        WITH TOTALS
    ) AS r
    USING (id);

SELECT
    id,
    yago,
    recent
FROM
    (
        SELECT
            item_id AS id,
            SUM(price_sold) AS recent
        FROM t
        WHERE date >= '2019-12-16'
            AND date <= '2020-03-08'
        GROUP BY id
        WITH TOTALS
        ORDER BY id ASC
    ) AS ll
FULL JOIN (
        SELECT
            item_id AS id,
            SUM(price_sold) AS yago
        FROM t
        WHERE date >= '2018-12-17'
            AND date <= '2019-03-10'
        GROUP BY id
        WITH TOTALS
        ORDER BY id ASC
    ) AS rr
    USING (id);

SELECT
    id,
    yago
FROM
    (
        SELECT item_id AS id
        FROM t
        GROUP BY id
    ) AS ll
FULL JOIN (
        SELECT
            item_id AS id,
            arrayJoin([111, 222, 333, 444]),
            SUM(price_sold) AS yago
        FROM t
        GROUP BY id
        WITH TOTALS
        ORDER BY id ASC
    ) AS rr
    USING (id);

SELECT
    id,
    yago
FROM
    (
        SELECT
            item_id AS id,
            arrayJoin([111, 222, 333])
        FROM t
        GROUP BY id
        WITH TOTALS
        ORDER BY id ASC
    ) AS ll
FULL JOIN (
        SELECT
            item_id AS id,
            SUM(price_sold) AS yago
        FROM t
        GROUP BY id
    ) AS rr
    USING (id);

SELECT
    id,
    yago
FROM
    (
        SELECT
            item_id AS id,
            arrayJoin(emptyArrayInt32())
        FROM t
        GROUP BY id
        WITH TOTALS
        ORDER BY id ASC
    ) AS ll
FULL JOIN (
        SELECT
            item_id AS id,
            SUM(price_sold) AS yago
        FROM t
        GROUP BY id
    ) AS rr
    USING (id);

SELECT
    id,
    yago
FROM
    (
        SELECT item_id AS id
        FROM t
        GROUP BY id
    ) AS ll
FULL JOIN (
        SELECT
            item_id AS id,
            arrayJoin(emptyArrayInt32()),
            SUM(price_sold) AS yago
        FROM t
        GROUP BY id
        WITH TOTALS
        ORDER BY id ASC
    ) AS rr
    USING (id);

SELECT
    id,
    yago
FROM
    (
        SELECT
            item_id AS id,
            arrayJoin([111, 222, 333])
        FROM t
        GROUP BY id
        WITH TOTALS
        ORDER BY id ASC
    ) AS ll
FULL JOIN (
        SELECT
            item_id AS id,
            arrayJoin([111, 222, 333, 444]),
            SUM(price_sold) AS yago
        FROM t
        GROUP BY id
        WITH TOTALS
        ORDER BY id ASC
    ) AS rr
    USING (id);

INSERT INTO t;

SELECT *
FROM
    (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS l
LEFT JOIN (
        SELECT item_id
        FROM t
    ) AS r
    ON l.item_id = r.item_id;

SELECT *
FROM
    (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS l
RIGHT JOIN (
        SELECT item_id
        FROM t
    ) AS r
    ON l.item_id = r.item_id;

SELECT *
FROM
    (
        SELECT item_id
        FROM t
    ) AS l
LEFT JOIN (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS r
    ON l.item_id = r.item_id;

SELECT *
FROM
    (
        SELECT item_id
        FROM t
    ) AS l
RIGHT JOIN (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS r
    ON l.item_id = r.item_id;

SELECT *
FROM
    (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS l
LEFT JOIN (
        SELECT item_id
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS r
    ON l.item_id = r.item_id;

SELECT *
FROM
    (
        SELECT
            item_id,
            'foo' AS key,
            1 AS val
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS l
LEFT JOIN (
        SELECT
            item_id,
            sum(price_sold) AS val
        FROM t
        GROUP BY item_id
        WITH TOTALS
        ORDER BY item_id ASC
    ) AS r
    ON l.item_id = r.item_id;

SELECT *
FROM
    (
        SELECT *
        FROM t
        GROUP BY
            item_id,
            price_sold,
            date
        WITH TOTALS
        ORDER BY
            item_id ASC,
            price_sold ASC,
            date ASC
    ) AS l
LEFT JOIN (
        SELECT *
        FROM t
        GROUP BY
            item_id,
            price_sold,
            date
        WITH TOTALS
        ORDER BY
            item_id ASC,
            price_sold ASC,
            date ASC
    ) AS r
    ON l.item_id = r.item_id
ORDER BY `ALL` ASC;

DROP TABLE t;