DROP TABLE IF EXISTS ephemeral;

DROP TABLE IF EXISTS dist_in;

DROP TABLE IF EXISTS data;

DROP TABLE IF EXISTS mv;

DROP TABLE IF EXISTS dist_out;

CREATE TABLE ephemeral
(
    key Int,
    value Int
)
ENGINE = Null();

CREATE TABLE dist_in AS ephemeral
ENGINE = Distributed(test_shard_localhost, currentDatabase(), ephemeral, key)
SETTINGS background_insert_batch = '1';

CREATE TABLE data
(
    key Int,
    uniq_values Int
)
ENGINE = TinyLog();

CREATE MATERIALIZED VIEW mv
TO data
AS
SELECT
    key,
    uniqExact(value::String) AS uniq_values
FROM ephemeral
GROUP BY key;

SYSTEM STOP DISTRIBUTED SENDS dist_in;

CREATE TABLE dist_out AS data
ENGINE = Distributed(test_shard_localhost, currentDatabase(), data);

SET prefer_localhost_replica = '0';

SET optimize_trivial_insert_select = '1';

-- due to pushing to MV with aggregation the query needs ~300MiB
-- but it will be done in background via "system flush distributed"
INSERT INTO dist_in SELECT
    number / 100,
    number
FROM `system`.numbers
LIMIT 3000000.
SETTINGS
    max_block_size = 3000000.,
    max_memory_usage = '100Mi';

SYSTEM FLUSH DISTRIBUTED dist_in; -- { serverError MEMORY_LIMIT_EXCEEDED }

SYSTEM FLUSH DISTRIBUTED dist_in SETTINGS max_memory_usage = '0';

SELECT count()
FROM dist_out;