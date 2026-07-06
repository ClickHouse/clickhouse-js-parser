-- Tags: no-parallel-replicas
SET enable_full_text_index = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    col LowCardinality(String),
    INDEX idx col TYPE text(tokenizer = 'array') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab;

SELECT count()
FROM tab
WHERE col = 'config';

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT count()
                FROM tab
                WHERE col = 'config'
                SETTINGS
                    use_skip_indexes_on_data_read = '1',
                    query_plan_text_index_add_hint = '1'
            ))
    )
WHERE `explain` LIKE '%Filter column:%';

SELECT count()
FROM tab
WHERE hasToken(col, 'config');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT count()
                FROM tab
                WHERE hasToken(col, 'config')
                SETTINGS
                    use_skip_indexes_on_data_read = '1',
                    query_plan_text_index_add_hint = '1'
            ))
    )
WHERE `explain` LIKE '%Filter column:%';

DROP TABLE tab;