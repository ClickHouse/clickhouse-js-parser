DROP TABLE IF EXISTS prewhere_defaults;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE prewhere_defaults
(
    d Date DEFAULT '2000-01-01',
    k UInt64 DEFAULT 0,
    x UInt16
)
ENGINE = MergeTree(d, k, 1);

INSERT INTO prewhere_defaults (x);

SET max_block_size = '1';

SELECT *
FROM prewhere_defaults
PREWHERE x != 0
ORDER BY x ASC;

ALTER TABLE prewhere_defaults ADD COLUMN y UInt16 DEFAULT x;

INSERT INTO prewhere_defaults (x);

DROP TABLE prewhere_defaults;