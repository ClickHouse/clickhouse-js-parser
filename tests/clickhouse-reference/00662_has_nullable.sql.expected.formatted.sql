DROP TABLE IF EXISTS `00662_has_nullable`;

CREATE TABLE `00662_has_nullable`
(
    a Nullable(UInt64)
)
ENGINE = Memory();

INSERT INTO `00662_has_nullable`;

SELECT
    a,
    has([0, 1], a)
FROM `00662_has_nullable`;

DROP TABLE `00662_has_nullable`;

CREATE TABLE `00662_has_nullable`
(
    a UInt64
)
ENGINE = Memory();

INSERT INTO `00662_has_nullable`;

SELECT
    a,
    has([NULL, 1, 2], a)
FROM `00662_has_nullable`;

INSERT INTO `00662_has_nullable`;

INSERT INTO `00662_has_nullable`;

SELECT
    a,
    has([NULL, NULL], a)
FROM `00662_has_nullable`;