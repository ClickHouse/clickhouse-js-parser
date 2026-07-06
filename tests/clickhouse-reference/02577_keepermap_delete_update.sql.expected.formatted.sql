-- Tags: no-ordinary-database, no-fasttest
DROP TABLE IF EXISTS `02577_keepermap_delete_update`;

CREATE TABLE `02577_keepermap_delete_update`
(
    key UInt64,
    value String,
    value2 UInt64
)
ENGINE = KeeperMap('/' || currentDatabase() || '/test02577_keepermap_delete_update')
PRIMARY KEY key;

INSERT INTO `02577_keepermap_delete_update`;

SELECT
    *,
    _version
FROM `02577_keepermap_delete_update`
ORDER BY key ASC;

SELECT '-----------';

DELETE FROM `02577_keepermap_delete_update` WHERE value LIKE 'Some%string';

ALTER TABLE `02577_keepermap_delete_update` DELETE WHERE key >= 4;

DELETE FROM `02577_keepermap_delete_update` WHERE 1 = 1;

SELECT count()
FROM `02577_keepermap_delete_update`;

INSERT INTO `02577_keepermap_delete_update`;

ALTER TABLE `02577_keepermap_delete_update` UPDATE value = 'Another' WHERE key > 2;

ALTER TABLE `02577_keepermap_delete_update` UPDATE key = key * 10 WHERE 1 = 1; -- { serverError BAD_ARGUMENTS }

ALTER TABLE `02577_keepermap_delete_update` UPDATE value2 = value2 * 10 + 2 WHERE value2 < 100;

ALTER TABLE `02577_keepermap_delete_update` ON CLUSTER test_shard_localhost UPDATE value2 = value2 * 10 + 2 WHERE value2 < 100; -- { serverError BAD_ARGUMENTS }