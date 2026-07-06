-- Tags: distributed
DROP TABLE IF EXISTS tab;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE tab
(
    date Date,
    time DateTime,
    data String
)
ENGINE = MergeTree(date, (time, data), 8192);

INSERT INTO tab;

SELECT time
FROM remote('127.0.0.{1,2}', currentDatabase(), tab)
WHERE date = '2018-01-21'
LIMIT 2;

DROP TABLE tab;