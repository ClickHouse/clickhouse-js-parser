-- Tags: replica
CREATE TABLE enum_alter_issue
(
    a Enum8('one' = 1, 'two' = 2)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO enum_alter_issue;

ALTER TABLE enum_alter_issue MODIFY COLUMN a Enum8('one' = 1, 'two' = 2, 'three' = 3);

ALTER TABLE enum_alter_issue DETACH PARTITION ID 'all';

ALTER TABLE enum_alter_issue ATTACH PARTITION ID 'all';

SELECT *
FROM enum_alter_issue
ORDER BY a ASC;

DROP TABLE enum_alter_issue;