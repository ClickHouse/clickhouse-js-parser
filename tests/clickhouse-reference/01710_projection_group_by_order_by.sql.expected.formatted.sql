--Tags: no-random-merge-tree-settings
-- Tag no-random-merge-tree-settings: bug in formatting of projections.
-- https://github.com/ClickHouse/ClickHouse/issues/44318
DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS tp;

CREATE TABLE tp
(
    type Int32,
    eventcnt UInt64,
    PROJECTION p (SELECT sum(eventcnt), type GROUP BY type ORDER BY sum(eventcnt))
)
ENGINE = MergeTree()
ORDER BY type; -- { serverError ILLEGAL_PROJECTION }