CREATE TABLE test
(
    x Array(String),
    INDEX idx1 x TYPE bloom_filter(0.025) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test;

SELECT *
FROM test
WHERE x = ['s1'];