-- Tags: no-random-merge-tree-settings
-- Because we insert one million rows, it shouldn't choose too low index granularity.
DROP TABLE IF EXISTS tab2;

CREATE TABLE tab2
(
    id String,
    version Int64,
    l String,
    accountCode String,
    z Int32
)
ENGINE = ReplacingMergeTree(z)
PRIMARY KEY (accountCode, id)
ORDER BY (accountCode, id, version, l);

INSERT INTO tab2 SELECT
    toString(number),
    number,
    toString(number),
    toString(number),
    0
FROM numbers(1000000.);

SET max_threads = '2';

SELECT count()
FROM tab2 FINAL;

DROP TABLE tab2;