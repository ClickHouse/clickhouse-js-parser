-- the test from simPod, https://github.com/ClickHouse/ClickHouse/issues/5608
DROP TABLE IF EXISTS joint; -- the table name from the original issue.

DROP TABLE IF EXISTS t;

CREATE TABLE IF NOT EXISTS joint
(
    id UUID,
    value LowCardinality(String)
)
ENGINE = Join(`ANY`, `LEFT`, id);

CREATE TABLE IF NOT EXISTS t
(
    id UUID,
    d DateTime
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY toDate(d);

INSERT INTO joint;

INSERT INTO t;

SELECT id
FROM
    t
ANY LEFT JOIN joint
    ON t.id = joint.id;

DROP TABLE joint;

DROP TABLE t;