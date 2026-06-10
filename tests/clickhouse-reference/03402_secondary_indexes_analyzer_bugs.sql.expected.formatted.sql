DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    tenant String,
    recordTimestamp Int64,
    responseBody String,
    colAlias String ALIAS responseBody || 'something else',
    INDEX ngrams colAlias TYPE ngrambf_v1(3, 2097152, 3, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY recordTimestamp
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t SELECT
    toString(number),
    number,
    toString(number)
FROM numbers(65536);

EXPLAIN indexes = '1'
SELECT
    tenant,
    recordTimestamp
FROM t
WHERE colAlias LIKE '%abcd%'
SETTINGS enable_analyzer = '0';

EXPLAIN indexes = '1'
SELECT
    tenant,
    recordTimestamp
FROM t
WHERE colAlias LIKE '%abcd%'
SETTINGS enable_analyzer = '1';

DROP TABLE IF EXISTS tab_v1;

CREATE TABLE tab_v1
(
    content String,
    INDEX idx_content_bloom content TYPE bloom_filter(0.01) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY content;

DROP TABLE IF EXISTS tab_v3;

CREATE VIEW tab_v3
AS
SELECT *
FROM tab_v1;

INSERT INTO tab_v1 (content);

SELECT count()
FROM tab_v3
WHERE content = 'iii'
SETTINGS
    force_data_skipping_indices = 'idx_content_bloom',
    enable_analyzer = '0';

SELECT count()
FROM tab_v3
WHERE content = 'iii'
SETTINGS
    force_data_skipping_indices = 'idx_content_bloom',
    enable_analyzer = '1';