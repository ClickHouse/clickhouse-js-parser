SET enable_analyzer = '1';

DROP TABLE IF EXISTS segmented_ctr_cache;

DROP TABLE IF EXISTS bookmarks_join;

DROP TABLE IF EXISTS cart_join;

CREATE TABLE IF NOT EXISTS segmented_ctr_cache
(
    product_id Int32,
    segment_id Int32,
    count_in_viewport UInt64,
    count_in_viewed UInt64
)
ENGINE = Memory();

INSERT INTO segmented_ctr_cache;

INSERT INTO segmented_ctr_cache;

INSERT INTO segmented_ctr_cache;

INSERT INTO segmented_ctr_cache;

INSERT INTO segmented_ctr_cache;

INSERT INTO segmented_ctr_cache;

CREATE TABLE bookmarks_join
(
    product_id Int32,
    segment_id Int32,
    count_in_bookmark Int32
)
ENGINE = Join(`ALL`, `LEFT`, product_id, segment_id);

INSERT INTO bookmarks_join;

INSERT INTO bookmarks_join;

INSERT INTO bookmarks_join;

INSERT INTO bookmarks_join;

CREATE TABLE cart_join
(
    product_id Int32,
    segment_id Int32,
    count_in_cart Int32
)
ENGINE = Join(`ALL`, `LEFT`, product_id, segment_id);

INSERT INTO cart_join;

INSERT INTO cart_join;

INSERT INTO cart_join;

INSERT INTO cart_join;

SELECT
    segmented_ctr_cache.product_id,
    segmented_ctr_cache.segment_id,
    count_in_bookmark,
    count_in_cart
FROM
    segmented_ctr_cache
LEFT JOIN cart_join
    ON cart_join.product_id = segmented_ctr_cache.product_id
    AND cart_join.segment_id = segmented_ctr_cache.segment_id
LEFT JOIN bookmarks_join
    ON bookmarks_join.product_id = segmented_ctr_cache.product_id
    AND bookmarks_join.segment_id = segmented_ctr_cache.segment_id
ORDER BY `ALL` ASC;

DROP TABLE segmented_ctr_cache;

DROP TABLE bookmarks_join;

DROP TABLE cart_join;