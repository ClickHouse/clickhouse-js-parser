DROP TABLE IF EXISTS test_table;

DROP TABLE IF EXISTS test_table_sharded;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE test_table_sharded
(
    date Date,
    text String,
    hash UInt64
)
ENGINE = MergeTree(date, (hash, date), 8192);

CREATE TABLE test_table AS test_table_sharded
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), test_table_sharded, hash);

SET distributed_product_mode = 'local';

SET distributed_foreground_insert = '1';

INSERT INTO test_table;

SELECT
    text,
    uniqExactIf(hash, hash IN (
        SELECT DISTINCT hash
        FROM test_table AS t1
    )) AS counter
FROM test_table AS t2
GROUP BY text
ORDER BY
    counter ASC,
    text ASC;

DROP TABLE test_table;

DROP TABLE test_table_sharded;