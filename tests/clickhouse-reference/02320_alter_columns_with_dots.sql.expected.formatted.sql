DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id String,
    `abc.1` String,
    `abc.2` String,
    abc String
)
ENGINE = MergeTree()
ORDER BY id;

DESCRIBE TABLE test;

ALTER TABLE test MODIFY COLUMN `abc.1` String AFTER abc;

ALTER TABLE test MODIFY COLUMN `abc.2` String AFTER abc;

ALTER TABLE test MODIFY COLUMN abc String AFTER `abc.2`;

ALTER TABLE test MODIFY COLUMN abc String AFTER id;

ALTER TABLE test MODIFY COLUMN abc String AFTER `abc.1`;

ALTER TABLE test DROP COLUMN abc;