-- add_minmax_index_for_numeric_columns=0: Disable minmax index for numeric columns to avoid interference with SET index, otherwise indexHint can filter further rows.
SET optimize_trivial_insert_select = '1';

CREATE TABLE a
(
    k UInt64,
    v UInt64,
    INDEX i v TYPE set(100) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY k
SETTINGS index_granularity = '8192', index_granularity_bytes = '1000000000', min_index_granularity_bytes = '0', add_minmax_index_for_numeric_columns = '0';

INSERT INTO a SELECT
    number,
    intDiv(number, 4096)
FROM numbers(1000000);

-- { echoOn }
SELECT sum(1 + ignore(*))
FROM a
WHERE indexHint(v IN (20, 40));

SELECT sum(1 + ignore(*))
FROM a
WHERE indexHint(v IN (
        SELECT 20
        UNION ALL
        SELECT 40
        UNION ALL
        SELECT 60
    ));

SELECT 1
FROM a
PREWHERE v IN (
        SELECT 1
    )
WHERE v IN (
        SELECT 2
    );

SELECT 1
FROM a
WHERE indexHint(indexHint(materialize(0)));

SELECT sum(1 + ignore(*))
FROM a
WHERE indexHint(indexHint(v IN (20, 40)));