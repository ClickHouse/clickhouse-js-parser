DROP TABLE IF EXISTS merge;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE IF NOT EXISTS merge
(
    d Date DEFAULT '2000-01-01',
    x UInt64
)
ENGINE = MergeTree(d, x, 5);

INSERT INTO merge (x);

INSERT INTO merge (x);

SELECT *
FROM merge
ORDER BY
    _part_index ASC,
    x ASC;

OPTIMIZE TABLE merge;

DROP TABLE merge;

INSERT INTO merge (x) SELECT number AS x
FROM `system`.numbers
LIMIT 10;

INSERT INTO merge (x) SELECT number + 10 AS x
FROM `system`.numbers
LIMIT 10;

INSERT INTO merge (x) SELECT number + 5 AS x
FROM `system`.numbers
LIMIT 10;

INSERT INTO merge (x) SELECT number + 9 AS x
FROM `system`.numbers
LIMIT 10;

INSERT INTO merge (x) SELECT number + 100 AS x
FROM `system`.numbers
LIMIT 10;

CREATE TABLE IF NOT EXISTS merge
(
    d Date DEFAULT '2000-01-01',
    x UInt64
)
ENGINE = MergeTree(d, x, 8192);

SET min_insert_block_size_rows = '0', min_insert_block_size_bytes = '0';

SET max_block_size = '8200';

INSERT INTO merge (x) SELECT number AS x
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 8200
    )
ORDER BY rand() ASC;

SELECT
    count(),
    uniqExact(x),
    min(x),
    max(x),
    sum(x),
    sum(cityHash64(x))
FROM merge;

SET max_block_size = '10000';

INSERT INTO merge (x) SELECT number AS x
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 10000
    );

INSERT INTO merge (x) SELECT number AS x
FROM (
        SELECT number + 5000 AS number
        FROM `system`.numbers
        LIMIT 10000
    );