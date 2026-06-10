-- Tests that Merge-engine (not: MergeTree!) tables support the trivial count
-- optimization if all underlying tables support it
DROP TABLE IF EXISTS mt1;

DROP TABLE IF EXISTS mt2;

DROP TABLE IF EXISTS merge;

CREATE TABLE mt1
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE mt2
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE merge
(
    id UInt64
)
ENGINE = Merge(currentDatabase(), '^mt[0-9]+$');

INSERT INTO mt1;

INSERT INTO mt2;

SET apply_mutations_on_fly = '0';

SET apply_patch_parts = '0';

SELECT count()
FROM merge;

-- can use the trivial count optimization
EXPLAIN
SELECT count()
FROM merge
SETTINGS enable_analyzer = '0';

CREATE TABLE mt3
(
    id UInt64
)
ENGINE = TinyLog();

INSERT INTO mt2;

DROP TABLE IF EXISTS mt3;