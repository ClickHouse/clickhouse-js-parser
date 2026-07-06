CREATE TABLE set_crash
(
    key1 Int32,
    id1 Int64,
    c1 Int64
)
ENGINE = MergeTree()
ORDER BY key1
PARTITION BY id1;

INSERT INTO set_crash;

SELECT 1 IN (-1, 1)
FROM set_crash
WHERE (key1, id1) IN (-1, 1);