-- Tags: no-fasttest
-- We want to test `isContentCached(offset, size)` method implementation in ReadBufferFromRemoteFSGather and CachedOnDiskReadBufferFromFile
-- Specifically, how they handle `offset` parameter when we have multiple S3 objects representing a single ClickHouse file
-- Log englie table files will be represented by multiple objects on S3
CREATE TABLE t
(
    a UInt64
)
ENGINE = Log()
SETTINGS disk = 's3_cache';

INSERT INTO t SELECT number
FROM numbers_mt(1000000.);

-- First of all the cache should be warmed up
SELECT *
FROM t
FORMAT Null;