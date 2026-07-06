DROP TABLE IF EXISTS m3;

DROP TABLE IF EXISTS m1;

DROP TABLE IF EXISTS x;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE x
(
    d Date,
    t DateTime
)
ENGINE = MergeTree(d, (d, t), 1);

CREATE MATERIALIZED VIEW m1
(
    d Date,
    t DateTime,
    c UInt64
)
ENGINE = SummingMergeTree(d, (d, t), 1)
AS
SELECT
    d,
    toStartOfMinute(x.t) AS t,
    count() AS c
FROM x
GROUP BY
    d,
    t;

CREATE MATERIALIZED VIEW m3
ENGINE = SummingMergeTree(d, (d, t), 1)
AS
SELECT
    d,
    toStartOfHour(m1.t) AS t,
    c
FROM m1;

INSERT INTO x;

OPTIMIZE TABLE m3;

DROP TABLE m3;

DROP TABLE m1;

DROP TABLE x;