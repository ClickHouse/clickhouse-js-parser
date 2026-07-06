DROP TABLE IF EXISTS const_in_const;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE const_in_const
(
    id UInt64,
    date Date,
    uid UInt32,
    name String,
    Sign Int8
)
ENGINE = CollapsingMergeTree(date, intHash32(uid), (id, date, intHash32(uid)), 8192, Sign);

INSERT INTO const_in_const;

INSERT INTO const_in_const;

INSERT INTO const_in_const;

INSERT INTO const_in_const;

INSERT INTO const_in_const;

SELECT 1
FROM const_in_const
WHERE 42 IN (225);

SELECT name
FROM const_in_const
WHERE 1 IN (125, 1, 2)
ORDER BY name ASC
LIMIT 1;