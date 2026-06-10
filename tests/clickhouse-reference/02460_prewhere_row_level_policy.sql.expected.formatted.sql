-- https://github.com/ClickHouse/ClickHouse/issues/40956#issuecomment-1262096612
DROP TABLE IF EXISTS row_level_policy_prewhere;

DROP ROW POLICY IF EXISTS row_level_policy_prewhere_policy0 ON row_level_policy_prewhere;

CREATE TABLE row_level_policy_prewhere
(
    x Int16,
    y String
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO row_level_policy_prewhere (y, x);

CREATE ROW POLICY row_level_policy_prewhere_policy0 ON row_level_policy_prewhere USING x >= 0 TO default;

SELECT *
FROM row_level_policy_prewhere
PREWHERE y = 'foo';

DROP TABLE row_level_policy_prewhere;