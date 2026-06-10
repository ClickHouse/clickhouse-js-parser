DROP TABLE IF EXISTS mutations_and_escaping_1648;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE mutations_and_escaping_1648
(
    d Date,
    e Enum8('foo' = 1, 'bar' = 2)
)
ENGINE = MergeTree(d, d, 8192);

INSERT INTO mutations_and_escaping_1648 (d, e);

INSERT INTO mutations_and_escaping_1648 (d, e);

-- slow mutation
ALTER TABLE mutations_and_escaping_1648 UPDATE e = CAST('foo' AS Enum8('foo' = 1, 'bar' = 2)) WHERE d = '2018-01-02'
AND sleepEachRow(1) = 0;

-- check that we able to read mutation text after serialization
DETACH TABLE mutations_and_escaping_1648;

ATTACH TABLE mutations_and_escaping_1648;

ALTER TABLE mutations_and_escaping_1648 UPDATE e = CAST('foo' AS Enum8('foo' = 1, 'bar' = 2)) WHERE d = '2018-01-02' SETTINGS mutations_sync = '1';

SELECT e
FROM mutations_and_escaping_1648
ORDER BY d ASC;

DROP TABLE mutations_and_escaping_1648;