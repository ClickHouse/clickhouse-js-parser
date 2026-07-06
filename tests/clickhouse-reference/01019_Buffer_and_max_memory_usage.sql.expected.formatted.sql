-- Tags: no-replicated-database
DROP TABLE IF EXISTS null_;

DROP TABLE IF EXISTS buffer_;

DROP TABLE IF EXISTS aggregation_;

-- Each UInt64  is 8    bytes
-- So 10e6 rows is 80e6 bytes
--
-- Use LIMIT max_rows+1 to force flush from the query context, and to avoid
-- flushing from the background thread, since in this case it can steal memory
-- the max_memory_usage may be exceeded during squashing other blocks.
CREATE TABLE null_
(
    key UInt64
)
ENGINE = Null();

CREATE TABLE buffer_
(
    key UInt64
)
ENGINE = Buffer(currentDatabase(), null_, 1, 10000000., 10000000., 0, 10000000., 0, 80000000.);

SET max_memory_usage = 10000000.;

SET max_block_size = 100000.;

SET max_insert_threads = '1';

-- Check that max_memory_usage is ignored only on flush and not on squash
SET min_insert_block_size_bytes = 9000000.;

SET min_insert_block_size_rows = '0';

INSERT INTO buffer_ SELECT toUInt64(number)
FROM `system`.numbers
LIMIT toUInt64(10000000. + 1); -- { serverError MEMORY_LIMIT_EXCEEDED }

OPTIMIZE TABLE buffer_; -- flush just in case

-- create complex aggregation to fail with Memory limit exceede error while writing to Buffer()
-- String over UInt64 is enough to trigger the problem.
CREATE MATERIALIZED VIEW aggregation_
ENGINE = Memory()
AS
SELECT toString(key)
FROM null_;

-- Check that max_memory_usage is ignored during write from StorageBuffer
SET min_insert_block_size_bytes = '0';

SET min_insert_block_size_rows = 100000.;

-- Check that 10e6 rows had been flushed from the query, not from the background worker.
SELECT count()
FROM buffer_;

DROP TABLE null_;

DROP TABLE buffer_;

DROP TABLE aggregation_;