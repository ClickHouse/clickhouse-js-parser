-- Tags: no-parallel-replicas
-- Tests that match() utilizes the text index
SET enable_full_text_index = true;

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt32,
    str String,
    INDEX inv_idx str TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '1';

INSERT INTO tab;

SELECT *
FROM tab
WHERE match(str, ' Hello (ClickHouse|World) ')
ORDER BY id ASC;

-- Read 2/6 granules
-- Required string: ' Hello '
-- Alternatives: ' Hello ClickHouse ', ' Hello World '
SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM tab
                WHERE match(str, ' Hello (ClickHouse|World) ')
                ORDER BY id ASC
            ))
    )
WHERE `explain` LIKE '%Granules: %'
SETTINGS enable_analyzer = '0';

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM tab
                WHERE match(str, ' Hello (ClickHouse|World) ')
                ORDER BY id ASC
            ))
    )
WHERE `explain` LIKE '%Granules: %'
SETTINGS enable_analyzer = '1';

SELECT '---';

SELECT *
FROM tab
WHERE match(str, '.* (ClickHouse|World) ')
ORDER BY id ASC;

-- Read 3/6 granules
-- Required string: -
-- Alternatives: ' ClickHouse ', ' World '
SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM tab
                WHERE match(str, '.* (ClickHouse|World) ')
                ORDER BY id ASC
            ))
    )
WHERE `explain` LIKE '%Granules: %'
SETTINGS enable_analyzer = '0';

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM tab
                WHERE match(str, '.* (ClickHouse|World) ')
                ORDER BY id ASC
            ))
    )
WHERE `explain` LIKE '%Granules: %'
SETTINGS enable_analyzer = '1';

SELECT *
FROM tab
WHERE match(str, ' OLAP .*')
ORDER BY id ASC;

-- Read 1/6 granules
-- Required string: ' OLAP '
-- Alternatives: -
SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM tab
                WHERE match(str, ' OLAP (.*?)*')
                ORDER BY id ASC
            ))
    )
WHERE `explain` LIKE '%Granules: %'
SETTINGS enable_analyzer = '0';

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM tab
                WHERE match(str, ' OLAP (.*?)*')
                ORDER BY id ASC
            ))
    )
WHERE `explain` LIKE '%Granules: %'
SETTINGS enable_analyzer = '1';

DROP TABLE tab;