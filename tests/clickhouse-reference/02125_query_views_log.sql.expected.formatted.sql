SET output_format_pretty_single_large_number_tip_threshold = '0';

DROP TABLE IF EXISTS src;

DROP TABLE IF EXISTS dst;

DROP TABLE IF EXISTS mv1;

DROP TABLE IF EXISTS mv2;

CREATE TABLE src
(
    key Int
)
ENGINE = Null();

CREATE TABLE dst
(
    key Int
)
ENGINE = Null();

CREATE MATERIALIZED VIEW mv1
TO dst
AS
SELECT *
FROM src;

CREATE MATERIALIZED VIEW mv2
TO dst
AS
SELECT *
FROM src;

INSERT INTO src SELECT *
FROM numbers(1000000.)
SETTINGS
    log_queries = '1',
    max_untracked_memory = '0',
    parallel_view_processing = '0';

SYSTEM FLUSH LOGS query_views_log, query_log;

-- { echo }
SELECT
    view_name,
    read_rows,
    read_bytes,
    written_rows,
    written_bytes
FROM `system`.query_views_log
WHERE startsWith(view_name, currentDatabase() || '.mv')
ORDER BY view_name ASC
FORMAT Vertical;

SELECT
    read_rows,
    read_bytes,
    written_rows,
    written_bytes
FROM `system`.query_log
WHERE type = 'QueryFinish'
    AND query_kind = 'Insert'
    AND current_database = currentDatabase()
FORMAT Vertical;