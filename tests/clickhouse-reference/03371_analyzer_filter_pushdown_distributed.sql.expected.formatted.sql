SET enable_analyzer = '1';

CREATE TABLE bug_table
(
    date_column Date,
    c1 String,
    c2 String
)
ENGINE = MergeTree()
ORDER BY (c1, c2)
PARTITION BY toYYYYMM(date_column);

INSERT INTO bug_table;

CREATE TABLE distributed_bug_table
(
    date_column Date,
    c1 String,
    c2 String
)
ENGINE = Distributed('test_cluster_two_shards', currentDatabase(), 'bug_table', cityHash64(c1));

SET distributed_product_mode = 'allow';

SET prefer_localhost_replica = '1';

WITH alias_1 AS (
    SELECT
        c1,
        c2
    FROM distributed_bug_table
)

SELECT c1
FROM alias_1
WHERE c2 IN (
        SELECT DISTINCT c2
        FROM alias_1
    )
FORMAT Null;

SET prefer_localhost_replica = '0';