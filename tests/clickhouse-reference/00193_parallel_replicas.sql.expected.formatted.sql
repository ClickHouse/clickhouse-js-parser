-- Tags: replica
DROP TABLE IF EXISTS parallel_replicas;

DROP TABLE IF EXISTS parallel_replicas_backup;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE parallel_replicas
(
    d Date DEFAULT today(),
    x UInt32,
    u UInt64,
    s String
)
ENGINE = MergeTree(d, cityHash64(u, s), (x, d, cityHash64(u, s)), 8192);

INSERT INTO parallel_replicas (x, u, s);

INSERT INTO parallel_replicas (x, u, s);

INSERT INTO parallel_replicas (x, u, s);

INSERT INTO parallel_replicas (x, u, s);

INSERT INTO parallel_replicas (x, u, s);

INSERT INTO parallel_replicas (x, u, s);

/*
* Check that:
* - the table is not empty on each replica;
* - combining the data of all replicas coincides with the contents of the parallel_replicas table.
*/
/* Two replicas */
SET enable_parallel_replicas = '1', parallel_replicas_mode = 'sampling_key', max_parallel_replicas = '3', parallel_replicas_for_non_replicated_merge_tree = '1';

CREATE TABLE parallel_replicas_backup
(
    d Date DEFAULT today(),
    x UInt32,
    u UInt64,
    s String
)
ENGINE = Memory();

SET parallel_replicas_count = '2';

SET parallel_replica_offset = '0';

INSERT INTO parallel_replicas_backup (d, x, u, s) SELECT
    d,
    x,
    u,
    s
FROM parallel_replicas;

SELECT count() > 0
FROM parallel_replicas;

SET parallel_replica_offset = '1';

SET parallel_replicas_count = '0';

SELECT
    x,
    u,
    s
FROM parallel_replicas_backup
ORDER BY
    x ASC,
    u ASC,
    s ASC;

DROP TABLE parallel_replicas_backup;

/* Three replicas */
SET parallel_replicas_count = '3';

SET parallel_replica_offset = '2';

DROP TABLE parallel_replicas;