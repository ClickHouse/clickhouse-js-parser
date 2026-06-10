-- Tags: no-ordinary-database, no-fasttest
DROP TABLE IF EXISTS `02707_keepermap_delete_update`;

SET keeper_map_strict_mode = '1';

CREATE TABLE `02707_keepermap_delete_update`
(
    key UInt64,
    value String,
    value2 UInt64
)
ENGINE = KeeperMap('/' || currentDatabase() || '/test02707_keepermap_delete_update')
PRIMARY KEY key;

INSERT INTO `02707_keepermap_delete_update`;

SELECT
    *,
    _version,
    _version
FROM `02707_keepermap_delete_update`
ORDER BY key ASC;

SELECT '-----------';

DELETE FROM `02707_keepermap_delete_update` WHERE value LIKE 'Some%string';

SELECT
    *,
    _version
FROM `02707_keepermap_delete_update`
ORDER BY key ASC;

ALTER TABLE `02707_keepermap_delete_update` DELETE WHERE key >= 4;

DELETE FROM `02707_keepermap_delete_update` WHERE 1 = 1;

SELECT count()
FROM `02707_keepermap_delete_update`;

INSERT INTO `02707_keepermap_delete_update`;

ALTER TABLE `02707_keepermap_delete_update` UPDATE value = 'Another' WHERE key > 2;

ALTER TABLE `02707_keepermap_delete_update` UPDATE key = key * 10 WHERE 1 = 1; -- { serverError BAD_ARGUMENTS }

ALTER TABLE `02707_keepermap_delete_update` UPDATE value2 = value2 * 10 + 2 WHERE value2 < 100;