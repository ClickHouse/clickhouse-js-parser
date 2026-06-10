-- add_minmax_index_for_numeric_columns=0: Different plan
DROP TABLE IF EXISTS skip_table;

CREATE TABLE skip_table
(
    k UInt64,
    v UInt64,
    INDEX bf_big v TYPE bloom_filter(1e-10) GRANULARITY 1,
    INDEX bf_small v TYPE bloom_filter(0.1) GRANULARITY 1
)
ENGINE = MergeTree()
PRIMARY KEY k
SETTINGS index_granularity = '8192', add_minmax_index_for_numeric_columns = '0';

INSERT INTO skip_table SELECT
    number,
    intDiv(number, 4096)
FROM numbers(100000);

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM skip_table
                WHERE v = 125
                SETTINGS per_part_index_stats = '1'
            ))
    )
WHERE `explain` LIKE '%Name%';

DROP TABLE skip_table;