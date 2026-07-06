DROP TABLE IF EXISTS `02985_test`;

SET async_insert = '1';

SET deduplicate_blocks_in_dependent_materialized_views = '1';

CREATE TABLE `03006_test`
(
    d Date,
    value UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO `03006_test` SETTINGS compatibility = '24.1';

INSERT INTO `03006_test` SETTINGS async_insert = '0';

INSERT INTO `03006_test` SETTINGS deduplicate_blocks_in_dependent_materialized_views = '0';

INSERT INTO `03006_test`;