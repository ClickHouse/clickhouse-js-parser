-- Tags: no-parallel
DROP DATABASE IF EXISTS db_1 SYNC;

DROP DATABASE IF EXISTS db_2 SYNC;

DROP DATABASE IF EXISTS db_3 SYNC;

DROP DATABASE IF EXISTS db_4 SYNC;

DROP DATABASE IF EXISTS db_5 SYNC;

DROP DATABASE IF EXISTS db_6 SYNC;

SELECT '-----------------------';

CREATE DATABASE db_1
ENGINE = Replicated('/test/db_1', '{shard}', '{replica}');

CREATE DATABASE db_2
ENGINE = Replicated('/test/db_2', '{shard}', '{replica}');

CREATE DATABASE db_3
ENGINE = Replicated('/test/db_3', '{shard}', '{replica}');

CREATE DATABASE db_4
ENGINE = Replicated('/test/db_4', '{shard}', '{replica}');

CREATE DATABASE db_5
ENGINE = Replicated('/test/db_5', '{shard}', '{replica}');

CREATE DATABASE db_6
ENGINE = Replicated('/test/db_6', '{shard}', '{replica}');

SELECT sleep(1)
FORMAT Null;

SELECT *
FROM `system`.database_replicas
WHERE database LIKE 'db_%'
ORDER BY database ASC;

SELECT database
FROM `system`.database_replicas
WHERE database LIKE 'db_%'
ORDER BY database ASC;

SELECT DISTINCT is_readonly
FROM `system`.database_replicas
WHERE database LIKE 'db_%';

SELECT count(*)
FROM `system`.database_replicas
WHERE database LIKE 'db_%';

SELECT *
FROM `system`.database_replicas
WHERE database LIKE 'db_%'
ORDER BY database ASC
LIMIT 1;

SELECT *
FROM `system`.database_replicas
WHERE database LIKE 'db_%'
ORDER BY database ASC
LIMIT 6;

SELECT *
FROM `system`.database_replicas
WHERE database LIKE 'db_%'
ORDER BY database ASC
LIMIT 7;

SET max_block_size = '2';

SET max_block_size = '6';

SELECT *
FROM `system`.database_replicas
WHERE database LIKE 'db_%'
    AND is_readonly = 0
ORDER BY database ASC;

SELECT *
FROM `system`.database_replicas
WHERE database LIKE 'db_%'
    AND is_readonly = 1
ORDER BY database ASC;

SELECT is_readonly
FROM `system`.database_replicas
WHERE database = 'db_2'
ORDER BY database ASC;

SELECT *
FROM `system`.database_replicas
WHERE database = 'db_11'
ORDER BY database ASC;

DROP DATABASE db_1;

SET distributed_ddl_output_mode = 'throw';

CREATE TABLE db_2.test_table
(
    n Int64
)
ENGINE = MergeTree()
ORDER BY n;

SELECT
    database,
    max_log_ptr
FROM `system`.database_replicas
WHERE database LIKE 'db_%'
    AND max_log_ptr > 1;