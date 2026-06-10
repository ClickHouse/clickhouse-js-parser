SET max_threads = '1';

SET lock_acquire_timeout = '1';

CREATE TABLE t0
(
    c0 Int
)
ENGINE = Memory();

INSERT INTO t0 (c0) SELECT 1
PARALLEL WITH
TRUNCATE TABLE t0; -- { serverError DEADLOCK_AVOIDED }