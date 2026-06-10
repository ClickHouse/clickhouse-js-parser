-- Tags: no-ordinary-database
SET database_atomic_wait_for_drop_and_detach_synchronously = '0';

DROP TABLE IF EXISTS `25400_dropped_tables`;

CREATE TABLE `25400_dropped_tables`
(
    id Int32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO `25400_dropped_tables`;

INSERT INTO `25400_dropped_tables`;

DROP TABLE `25400_dropped_tables`;

SELECT
    table,
    engine
FROM `system`.dropped_tables
WHERE database = currentDatabase()
LIMIT 1;

SELECT
    database,
    table,
    name
FROM `system`.dropped_tables_parts
WHERE database = currentDatabase()
    AND table = '25400_dropped_tables';