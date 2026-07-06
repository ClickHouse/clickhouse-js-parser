DROP TABLE IF EXISTS alter_test;

CREATE TEMPORARY TABLE alter_test
(
    a UInt32,
    b UInt8
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO alter_test;

ALTER TABLE alter_test MODIFY COLUMN b UInt8 FIRST;

DESCRIBE TABLE alter_test;

CREATE TEMPORARY TABLE alter_test
(
    a UInt32,
    b UInt8
)
ENGINE = Log();

ALTER TABLE alter_test COMMENT COLUMN b 'this is comment for log engine';

CREATE TEMPORARY TABLE alter_test
(
    a UInt32,
    b UInt8
)
ENGINE = Null();