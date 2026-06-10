DROP TABLE IF EXISTS `replace`;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE `replace`
(
    EventDate Date,
    Id UInt64,
    Data String,
    Version UInt32
)
ENGINE = ReplacingMergeTree(EventDate, Id, 8192, Version);

INSERT INTO `replace`;

INSERT INTO `replace`;

INSERT INTO `replace`;

SELECT *
FROM `replace`
ORDER BY
    Id ASC,
    Version ASC;

SELECT *
FROM `replace` FINAL
ORDER BY
    Id ASC,
    Version ASC;

SELECT *
FROM `replace` FINAL
WHERE Version = 0
ORDER BY
    Id ASC,
    Version ASC;

DROP TABLE `replace`;