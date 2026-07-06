-- Tags: no-shared-merge-tree
SET alter_sync = '2';

-- {echoOn}
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a Int
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test;

OPTIMIZE TABLE test FINAL;

SELECT part_name
FROM `system`.parts
WHERE table = 'test'
    AND active
    AND database = currentDatabase();

ALTER TABLE test DETACH PART 'all_1_1_1';

ALTER TABLE test ATTACH PART 'all_1_1_1';

ALTER TABLE test ATTACH PARTITION tuple();