-- Tags: no-ordinary-database, no-fasttest, no-encrypted-storage, no-async-insert
CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO t;

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 'local_disk';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 'local_disk_2';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 'local_disk_3';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 's3_disk';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 's3_plain_rewritable';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 's3_cache';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 'local_plain_rewritable';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 's3_plain_rewritable_cache';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 's3_plain_rewritable_cache_multi';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 'local_cache';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 'local_cache_multi';

CREATE OR REPLACE TABLE t
(
    x INT
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS disk = 'encrypted_s3_plain_rewritable_cache';