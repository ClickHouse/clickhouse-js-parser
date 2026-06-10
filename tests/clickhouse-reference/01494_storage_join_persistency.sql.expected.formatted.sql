-- Tags: no-parallel
DROP TABLE IF EXISTS `join`;

SELECT '----- Default Settings -----';

CREATE TABLE `join`
(
    k UInt64,
    s String
)
ENGINE = Join(`ANY`, `LEFT`, k);

INSERT INTO `join`;

DETACH TABLE `join`;

ATTACH TABLE `join`;

SELECT *
FROM `join`;

DROP TABLE `join`;

CREATE TABLE `join`
(
    k UInt64,
    s String
)
ENGINE = Join(`ANY`, `LEFT`, k)
SETTINGS persistent = '1';

CREATE TABLE `join`
(
    k UInt64,
    s String
)
ENGINE = Join(`ANY`, `LEFT`, k)
SETTINGS persistent = '0';