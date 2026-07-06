DROP TABLE IF EXISTS nullable_alter;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE nullable_alter
(
    d Date DEFAULT '2000-01-01',
    x String
)
ENGINE = MergeTree(d, d, 1);

INSERT INTO nullable_alter (x);

SELECT x
FROM nullable_alter
ORDER BY x ASC;

ALTER TABLE nullable_alter MODIFY COLUMN x Nullable(String);

INSERT INTO nullable_alter (x);

SELECT x
FROM nullable_alter
ORDER BY x ASC NULLS FIRST;

ALTER TABLE nullable_alter MODIFY COLUMN x Nullable(FixedString(5));

DROP TABLE nullable_alter;