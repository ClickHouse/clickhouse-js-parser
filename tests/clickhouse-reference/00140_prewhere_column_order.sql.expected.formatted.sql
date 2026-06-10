DROP TABLE IF EXISTS `prewhere`;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE `prewhere`
(
    d Date,
    a String,
    b String
)
ENGINE = MergeTree(d, d, 8192);

INSERT INTO `prewhere`;

ALTER TABLE `prewhere` ADD COLUMN a1 String AFTER a;

INSERT INTO `prewhere`;

SELECT
    d,
    a,
    a1,
    b
FROM `prewhere`
PREWHERE a LIKE 'hello%'
ORDER BY a1 ASC;

DROP TABLE `prewhere`;