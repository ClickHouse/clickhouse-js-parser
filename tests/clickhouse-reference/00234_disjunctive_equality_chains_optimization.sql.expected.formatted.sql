CREATE TABLE IF NOT EXISTS foo_00234
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO foo_00234 (id);

SELECT
    sum(id = 3
    OR id = 1
    OR id = 2) AS x,
    sum(id = 3
    OR id = 1
    OR id = 2) AS x
FROM foo_00234;

DROP TABLE foo_00234;