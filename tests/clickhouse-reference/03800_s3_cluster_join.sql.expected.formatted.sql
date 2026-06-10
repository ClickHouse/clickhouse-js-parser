-- Tags: no-fasttest, no-parallel
SET enable_analyzer = '1';

SELECT *
FROM
    s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_a.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t1
LEFT JOIN s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_b.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t2
    ON t1.boolean_col = t2.boolean_col
ORDER BY t1.boolean_col ASC;

SELECT *
FROM
    s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_a.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t1
INNER JOIN s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_b.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t2
    ON t1.boolean_col = t2.boolean_col
ORDER BY t1.boolean_col ASC;

SELECT *
FROM
    s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_a.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t1
RIGHT JOIN s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_b.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t2
    ON t1.boolean_col = t2.boolean_col
ORDER BY t2.boolean_col ASC;

SELECT *
FROM
    s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_a.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t1
LEFT JOIN s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_b.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t2
    ON t1.boolean_col = t2.boolean_col
ORDER BY t1.boolean_col ASC;

SELECT *
FROM
    s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_a.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t1
FULL JOIN s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_b.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64') AS t2
    ON t1.boolean_col = t2.boolean_col
ORDER BY
    t1.boolean_col ASC,
    t2.boolean_col ASC;

SELECT *
FROM s3Cluster(test_shard_localhost, 'http://localhost:11111/test/03800_a.parquet', 'NOSIGN', 'Parquet', 'boolean_col Boolean, long_col Int64')
ORDER BY boolean_col ASC;