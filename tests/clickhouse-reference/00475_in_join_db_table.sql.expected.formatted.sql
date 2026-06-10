DROP TABLE IF EXISTS `set`;

CREATE TABLE `set`
(
    x String
)
ENGINE = Memory();

INSERT INTO `set`;

SELECT
    (arrayJoin(['hello', 'world']) AS s) IN (`set`),
    s;

DROP TABLE `set`;

CREATE TABLE `set`
(
    x String
)
ENGINE = Set();

DROP TABLE IF EXISTS `join`;

CREATE TABLE `join`
(
    k UInt8,
    x String
)
ENGINE = Memory();

INSERT INTO `join`;

SELECT
    k,
    x
FROM
    (
        SELECT arrayJoin([1, 2]) AS k
    ) AS js1
ANY LEFT JOIN `join`
    USING (k)
ORDER BY `ALL` ASC;

DROP TABLE `join`;

CREATE TABLE `join`
(
    k UInt8,
    x String
)
ENGINE = Join(`ANY`, `LEFT`, k);