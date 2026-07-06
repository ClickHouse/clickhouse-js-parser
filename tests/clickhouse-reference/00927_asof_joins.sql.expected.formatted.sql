DROP TABLE IF EXISTS md;

DROP TABLE IF EXISTS tv;

CREATE TABLE md
(
    key UInt32,
    t DateTime,
    bid Float64,
    ask Float64
)
ENGINE = MergeTree()
ORDER BY (key, t);

INSERT INTO md (key, t, bid, ask);

INSERT INTO md (key, t, bid, ask);

CREATE TABLE tv
(
    key UInt32,
    t DateTime,
    tv Float64
)
ENGINE = MergeTree()
ORDER BY (key, t);

INSERT INTO tv (key, t, tv);

INSERT INTO tv (key, t, tv);

SELECT
    tv.key,
    toString(tv.t, 'UTC'),
    md.bid,
    tv.tv,
    md.ask
FROM
    tv
ASOF LEFT JOIN md
    USING (key, t)
ORDER BY (tv.key, tv.t) ASC;

SELECT
    tv.key,
    toString(tv.t, 'UTC'),
    md.bid,
    tv.tv,
    md.ask
FROM
    tv
ASOF LEFT JOIN md
    USING (key, t)
ORDER BY (tv.key, tv.t) ASC
SETTINGS join_algorithm = 'full_sorting_merge';

DROP TABLE md;

DROP TABLE tv;