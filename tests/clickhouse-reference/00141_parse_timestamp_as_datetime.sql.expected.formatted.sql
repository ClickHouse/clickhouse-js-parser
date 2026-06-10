DROP TABLE IF EXISTS default;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE default
(
    d Date DEFAULT toDate(t),
    t DateTime
)
ENGINE = MergeTree(d, t, 8192);

INSERT INTO default (t);

SELECT
    toStartOfMonth(d),
    toUInt32(t)
FROM default;

DROP TABLE default;