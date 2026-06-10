-- Tags: no-parallel, no-fasttest
INSERT INTO FUNCTION file(data_02723.csv) SELECT number
FROM numbers(5)
SETTINGS engine_file_truncate_on_insert = '1';

SET max_threads = '2';

-- { echoOn }
SET parallelize_output_from_storages = '1';

SELECT startsWith(trimLeft(`explain`), 'Resize') AS resize
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT *
                FROM file(data_02723.csv)
            ))
    )
WHERE resize;

-- no Resize in pipeline
SET parallelize_output_from_storages = '0';

SELECT match(arrayStringConcat(groupArray(`explain`), ''), '.*Resize 1 → 2 *URL 0 → 1 *$')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT
                    x,
                    count()
                FROM url('https://example.com', Parquet, 'x Int64')
                GROUP BY x
                ORDER BY count() ASC
                LIMIT 10
            ))
    );