DROP TABLE IF EXISTS tab_v;

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    x UInt64,
    y UInt64
)
ENGINE = MergeTree()
ORDER BY (x, y);

INSERT INTO tab;

INSERT INTO tab;

INSERT INTO tab;

CREATE VIEW tab_v
AS
SELECT DISTINCT x
FROM tab;

-- { echoOn }
SET query_plan_remove_redundant_distinct = '1';

-- DISTINCT has to be removed since the view already has DISTINCT on the same column
SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT DISTINCT x
                FROM tab_v
            ))
    )
WHERE `explain` ILIKE '%distinct%';

SELECT DISTINCT x
FROM tab_v
ORDER BY x ASC;

-- explicitly checking that materialize() doesn't affect the result, - redundant DISTINCT is still removed
SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT DISTINCT x
                FROM (
                        SELECT materialize(x) AS x
                        FROM (
                                SELECT DISTINCT x
                                FROM tab
                            )
                    )
            ))
    )
WHERE `explain` ILIKE '%distinct%';