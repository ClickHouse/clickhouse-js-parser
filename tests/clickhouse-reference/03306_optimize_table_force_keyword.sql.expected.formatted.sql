CREATE TABLE tab
(
    x UInt32
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO tab;

INSERT INTO tab;

-- To force merge, traditionally keyword 'FINAL' is used.
-- Test that FORCE works as well.
OPTIMIZE TABLE tab FINAL;

SELECT count(*)
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'tab'
    AND active = 1;