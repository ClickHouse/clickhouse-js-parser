SET enable_full_text_index = '1';

SET parallel_replicas_local_plan = '1'; -- this setting may skip index analysis when false

SET use_skip_indexes_on_data_read = '0';

SET mutations_sync = '2'; -- want synchronous materialize

-- In this test we make sure that text search functions hasAny/AllTokens work correctly for
-- tables in which only some parts have a materialized index. The expected behavior is that
-- the search acts the same as if the whole column was indexed, but of course an inefficient
-- brute force search is used for the un-indexed rows. Furthermore we test that the same
-- tokenizer used to create the index is used for the un-indexed parts as is specified in
-- the index.
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt32,
    message String
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '2';

DROP VIEW IF EXISTS explain_indexes;

CREATE VIEW explain_indexes
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT groupArray(id)
                FROM tab
                WHERE hasAnyTokens(message, ['def'])
            ))
    )
WHERE `explain` LIKE '%Name%'
    OR `explain` LIKE '%Description%'
    OR `explain` LIKE '%Parts%'
    OR `explain` LIKE '%Granules%'
    OR `explain` LIKE '%Range%';

SYSTEM STOP MERGES tab;

-- bar# will be parsed differently by different tokenizers, e.g. splitbyString -> 'bar#'; splitByNonAlpha -> 'bar'
-- we want to test that the search functions will use the same tokenizer on un-materialized column parts
INSERT INTO tab (id, message);

ALTER TABLE tab ADD INDEX idx message TYPE text(tokenizer = 'splitByString') GRANULARITY 100000000;

INSERT INTO tab (id, message);

-- { echoOn }
SELECT *
FROM explain_indexes;

--
--hasAnyTokens:
SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAnyTokens(message, ['foo']);

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAnyTokens(message, ['bar']);

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAnyTokens(message, ['foo', 'bar']);

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAnyTokens(message, ['foo', 'ba']);

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAnyTokens(message, ['fo', 'ba']);

--
--hasAllTokens:
SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAllTokens(message, ['foo']);

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAllTokens(message, ['bar']);

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAllTokens(message, ['foo', 'bar']);

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAllTokens(message, ['abc', 'fo']);

-- { echoOff }
DROP TABLE tab;

ALTER TABLE tab ADD INDEX idx message TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000;

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAnyTokens(message, ['bar$']); -- test default tokenizer

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAnyTokens(message, tokens('bar$', 'splitByNonAlpha'));

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAllTokens(message, ['bar$']); -- test default tokenizer

SELECT arraySort(groupArray(id))
FROM tab
WHERE hasAllTokens(message, tokens('bar$', 'splitByNonAlpha'));

DROP VIEW explain_indexes;