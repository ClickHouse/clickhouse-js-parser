DROP TABLE IF EXISTS mt;

DROP TABLE IF EXISTS m;

CREATE TABLE mt
(
    p int,
    n int
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY p;

CREATE TABLE m
(
    n int
)
ENGINE = Memory();

INSERT INTO mt;

INSERT INTO mt;

SELECT
    *,
    _part
FROM mt
ORDER BY _part ASC;

ALTER TABLE mt UPDATE n = n + (n NOT IN (m)) IN PARTITION ID '1' WHERE 1 SETTINGS mutations_sync = '1';

DROP TABLE m;

OPTIMIZE TABLE mt FINAL;

SELECT
    mutation_id,
    command,
    parts_to_do_names,
    parts_to_do,
    is_done
FROM `system`.mutations
WHERE database = currentDatabase();

SELECT *
FROM mt
ORDER BY
    p ASC,
    n ASC;

DROP TABLE mt;