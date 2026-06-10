DROP TABLE IF EXISTS `02500_nested`;

SET flatten_nested = '1';

CREATE TABLE `02500_nested`
(
    nes Nested(a Int32, b Int32)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO `02500_nested` (nes.a, nes.b);

ALTER TABLE `02500_nested` ADD COLUMN z Int32;

ALTER TABLE `02500_nested` DROP COLUMN nes; -- { serverError BAD_ARGUMENTS }

DROP TABLE `02500_nested`;

CREATE TABLE `02500_nested`
(
    nes Nested(a Int32, b Int32),
    z Int32
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO `02500_nested` (nes.a, nes.b, z);

SET flatten_nested = '0';

INSERT INTO `02500_nested` (nes);

CREATE TABLE `02500_nested`
(
    nes Array(Tuple(a Int32, b Int32)),
    z Int32
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO `02500_nested` (nes, z);