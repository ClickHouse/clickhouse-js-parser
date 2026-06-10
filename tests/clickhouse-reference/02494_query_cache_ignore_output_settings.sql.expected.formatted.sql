-- Tags: no-parallel-replicas
-- no-parallel-replicas: the query from query_log errors due to missing columns.
-- Checks that the query cache ignores output format related settings (settings starting with 'output_format_')
SET max_block_size = '100';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    c UInt64
)
ENGINE = Memory() AS
SELECT 1;

SELECT
    '03710',
    c
FROM tab
SETTINGS
    use_query_cache = '1',
    max_block_size = '1';

SELECT
    '03710',
    c
FROM tab
FORMAT CSV
SETTINGS use_query_cache = '1', max_block_size = '1'; -- Same query as before but with different FORMAT, unfortunately that's a miss because the query cache uses the AST structure as key

SELECT
    '03710',
    c
FROM tab
FORMAT TSV
SETTINGS use_query_cache = '1', max_block_size = '1';

SELECT
    '03710',
    c
FROM tab
SETTINGS
    use_query_cache = '1',
    max_block_size = '1'
FORMAT CSV;

SELECT
    '03710',
    c
FROM tab
SETTINGS
    use_query_cache = '1',
    max_block_size = '1'
FORMAT TSV;

SYSTEM FLUSH LOGS query_log;