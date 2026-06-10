DROP TABLE IF EXISTS tab_00610;

DROP TABLE IF EXISTS mv_00610;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE tab_00610
(
    d Date,
    x UInt32
)
ENGINE = MergeTree(d, x, 8192);

CREATE MATERIALIZED VIEW mv_00610
(
    d Date,
    y UInt64
)
ENGINE = MergeTree(d, y, 8192)
AS
SELECT
    d,
    x + 1 AS y
FROM tab_00610;

INSERT INTO tab_00610;

SELECT '-- Before DROP PARTITION --';

SELECT *
FROM mv_00610
ORDER BY y ASC;

ALTER TABLE mv_00610 DROP PARTITION 201801;

DROP TABLE tab_00610;

DROP TABLE mv_00610;