-- Test runtime IF EXISTS checks for ALTER COLUMN commands
-- This test verifies that IF EXISTS clauses work correctly when column state changes
-- between validate() and apply() phases within the same ALTER statement
DROP TABLE IF EXISTS test_alter_if_exists;

-- Test 1: DROP COLUMN IF EXISTS with column deleted by previous command
CREATE TABLE test_alter_if_exists
(
    c0 Int32,
    c1 String
)
ENGINE = Memory();

-- This should succeed - first DROP removes c0, second DROP with IF EXISTS should be silently ignored
ALTER TABLE test_alter_if_exists DROP COLUMN c0, DROP COLUMN IF EXISTS c0;

DESCRIBE TABLE test_alter_if_exists;

DROP TABLE test_alter_if_exists;

-- This should succeed - DROP removes c0, MODIFY with IF EXISTS should be silently ignored
ALTER TABLE test_alter_if_exists DROP COLUMN c0, MODIFY COLUMN IF EXISTS c0 Int64;

-- Test 3: RENAME COLUMN IF EXISTS with column deleted by previous command
CREATE TABLE test_alter_if_exists
(
    x Int32,
    y String
)
ENGINE = Memory();

-- This should succeed - DROP removes x, RENAME with IF EXISTS should be silently ignored
ALTER TABLE test_alter_if_exists DROP COLUMN x, RENAME COLUMN IF EXISTS x TO z;