-- Tags: no-parallel, no-fasttest, no-random-settings
INSERT INTO FUNCTION s3(s3_conn, filename = '03631', `format` = Parquet, partition_strategy = 'hive', partition_columns_in_data_file = 1) PARTITION BY (year, country) SELECT
    'Brazil' AS country,
    2025 AS year,
    1 AS id;

-- distinct because minio isn't cleaned up
SELECT countDistinct(year)
FROM s3(s3_conn, filename = '03631/**.parquet', `format` = RawBLOB)
SETTINGS use_hive_partitioning = '1';

DESCRIBE TABLE s3(s3_conn, filename = '03631/**.parquet', `format` = RawBLOB) SETTINGS use_hive_partitioning = '1';