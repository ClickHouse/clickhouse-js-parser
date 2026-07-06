-- Tags: no-parallel
-- Check that Buffer will be flushed before shutdown
-- (via DETACH DATABASE)
DROP DATABASE IF EXISTS db_01870;

CREATE DATABASE db_01870;

-- Right now the order for shutdown is defined and it is:
-- (prefixes are important, to define the order)
-- - a_data_01870
-- - z_buffer_01870
-- so on DETACH DATABASE the following error will be printed:
--
--     Destination table default.a_data_01870 doesn't exist. Block of data is discarded.
CREATE TABLE db_01870.a_data_01870 AS `system`.numbers
ENGINE = TinyLog();

CREATE TABLE db_01870.z_buffer_01870 AS `system`.numbers
ENGINE = Buffer(db_01870, a_data_01870, 1, 100, 100, 100, 100, 100, 1000000.);

INSERT INTO db_01870.z_buffer_01870 SELECT *
FROM `system`.numbers
LIMIT 5;

SELECT count()
FROM db_01870.a_data_01870;

DETACH DATABASE db_01870;

ATTACH DATABASE db_01870;

DROP DATABASE db_01870;