-- Tags: no-ordinary-database, no-fasttest
DROP TABLE IF EXISTS `03236_keeper_map_engine_parameters`;

CREATE TABLE `03236_keeper_map_engine_parameters`
(
    key UInt64,
    value UInt64
)
ENGINE = KeeperMap('/' || currentDatabase() || '/test2417')
PRIMARY KEY key;

SHOW CREATE TABLE `03236_keeper_map_engine_parameters`;

DROP TABLE `03236_keeper_map_engine_parameters`;