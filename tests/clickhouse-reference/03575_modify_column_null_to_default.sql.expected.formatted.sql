DROP TABLE IF EXISTS nullable_test;

CREATE TABLE nullable_test
(
    my_int_nullable Nullable(UInt32),
    my_int_nullable_with_default Nullable(UInt32) DEFAULT NULL,
    my_int_nullable_with_default2 Nullable(UInt32) DEFAULT 11,
    my_text_lc_nullable LowCardinality(Nullable(String))
)
ORDER BY tuple();

INSERT INTO nullable_test;

-- { echoOn }
SELECT *
FROM nullable_test
ORDER BY `ALL` ASC;

SYSTEM STOP MERGES nullable_test;

ALTER TABLE nullable_test MODIFY COLUMN my_int_nullable UInt64 SETTINGS mutations_sync = '0', alter_sync = '0'; -- { serverError BAD_ARGUMENTS }

ALTER TABLE nullable_test MODIFY COLUMN my_int_nullable UInt64 DEFAULT 42 SETTINGS mutations_sync = '0', alter_sync = '0';

SYSTEM START MERGES nullable_test;

OPTIMIZE TABLE nullable_test FINAL;

ALTER TABLE nullable_test MODIFY COLUMN my_text_lc_nullable String DEFAULT 'empty';

-- Previouly existing DEFAULT NULL does not allow to modify
ALTER TABLE nullable_test MODIFY COLUMN my_int_nullable_with_default UInt64 SETTINGS mutations_sync = '0', alter_sync = '0'; -- { serverError CANNOT_CONVERT_TYPE }

ALTER TABLE nullable_test MODIFY COLUMN my_int_nullable_with_default UInt64 DEFAULT 43 SETTINGS mutations_sync = '0', alter_sync = '0';

-- But when we have DEFAULT which is non NULL we can keep it
ALTER TABLE nullable_test MODIFY COLUMN my_int_nullable_with_default2 UInt64 SETTINGS mutations_sync = '0', alter_sync = '0';