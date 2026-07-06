-- Test for https://github.com/ClickHouse/ClickHouse/issues/78360
-- A HASHED dictionary that references itself through a Merge table should not deadlock.
-- Previously this would hang forever; now it should produce an error about circular dependency.
CREATE TABLE t0
(
    c0 Int
)
ENGINE = Merge(currentDatabase(), 'd1');

CREATE DICTIONARY d1
(
    c0 Int DEFAULT 1
)
PRIMARY KEY c0
SOURCE(clickhouse(DB currentDatabase() TABLE 't0'))
LIFETIME(MIN 0 MAX 1)
LAYOUT(HASHED());

SELECT 1
FROM d1; -- { serverError DEADLOCK_AVOIDED }

SYSTEM RELOAD DICTIONARY d1; -- { serverError DEADLOCK_AVOIDED }

DROP DICTIONARY d1;

DROP TABLE t0;