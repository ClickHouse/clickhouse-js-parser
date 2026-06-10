DROP TABLE IF EXISTS cc SYNC;

CREATE TABLE cc
(
    a UInt64,
    b String
)
ENGINE = MergeTree()
ORDER BY (a, b)
SETTINGS compress_marks = true;

INSERT INTO cc;

ALTER TABLE cc DETACH PART 'all_1_1_0';

ALTER TABLE cc ATTACH PART 'all_1_1_0';

SELECT *
FROM cc;