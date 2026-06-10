DROP TABLE IF EXISTS alter_test;

CREATE TEMPORARY TABLE alter_test
(
    CounterID UInt32,
    StartDate Date,
    UserID UInt32,
    VisitID UInt32,
    NestedColumn Nested(A UInt8, S String),
    ToDrop UInt32
);

INSERT INTO alter_test;

ALTER TABLE alter_test ADD COLUMN Added0 UInt32;

ALTER TABLE alter_test ADD COLUMN Added2 UInt32;

ALTER TABLE alter_test ADD COLUMN Added1 UInt32 AFTER Added0;

ALTER TABLE alter_test ADD COLUMN AddedNested1 Nested(A UInt32, B UInt64) AFTER Added2;

ALTER TABLE alter_test ADD COLUMN `AddedNested1.C` Array(String) AFTER AddedNested1.B;

ALTER TABLE alter_test ADD COLUMN AddedNested2 Nested(A UInt32, B UInt64) AFTER AddedNested1;

DESCRIBE TABLE alter_test;

ALTER TABLE alter_test DROP COLUMN ToDrop;

ALTER TABLE alter_test MODIFY COLUMN Added0 String;

ALTER TABLE alter_test DROP COLUMN NestedColumn.A;

ALTER TABLE alter_test DROP COLUMN NestedColumn.S;

ALTER TABLE alter_test DROP COLUMN AddedNested1.B;

ALTER TABLE alter_test ADD COLUMN IF NOT EXISTS Added0 UInt32;

ALTER TABLE alter_test ADD COLUMN IF NOT EXISTS AddedNested1 Nested(A UInt32, B UInt64);

ALTER TABLE alter_test ADD COLUMN IF NOT EXISTS `AddedNested1.C` Array(String);

ALTER TABLE alter_test MODIFY COLUMN IF EXISTS ToDrop UInt64;

ALTER TABLE alter_test DROP COLUMN IF EXISTS ToDrop;

ALTER TABLE alter_test COMMENT COLUMN IF EXISTS ToDrop 'new comment';

ALTER TABLE alter_test RENAME COLUMN Added0 TO RenamedColumn;

SELECT *
FROM alter_test;

DROP TABLE alter_test;