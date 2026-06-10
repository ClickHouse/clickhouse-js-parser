-- Tags: no-parallel-replicas, no-object-storage
SET min_bytes_to_use_direct_io = '0';

DROP TABLE IF EXISTS `03595_data`;

CREATE TABLE `03595_data`
(
    key UInt32,
    val String
)
ENGINE = MergeTree()
ORDER BY key AS
SELECT
    number,
    'val-' || number
FROM numbers(100000);

SELECT *
FROM `03595_data`
FORMAT Null
SETTINGS local_filesystem_read_method = 'pread_threadpool', min_bytes_to_use_direct_io = '1', log_query_threads = '1', use_uncompressed_cache = '0';

SYSTEM FLUSH LOGS query_log, query_thread_log;

WITH queries AS (
    SELECT
        query_id,
        row_number() OVER (ORDER BY event_time_microseconds ASC) AS ordinal
    FROM `system`.query_log
    WHERE type = 'QueryFinish'
        AND current_database = currentDatabase()
        AND query_kind = 'Select'
        AND `Settings`['min_bytes_to_use_direct_io'] = '1'
)

SELECT
    queries.ordinal,
    thread_name,
    sum(ProfileEvents['OSReadBytes']) > 0 AS disk_reading
FROM
    `system`.query_thread_log AS qtl
INNER JOIN queries
    ON queries.query_id = qtl.query_id
WHERE current_database = currentDatabase()
    AND query_id IN (
        SELECT query_id
        FROM queries
    )
    AND ProfileEvents['OSReadBytes'] > 0
GROUP BY
    1,
    2
ORDER BY
    1 ASC,
    2 ASC;

DROP TABLE `03595_data`;