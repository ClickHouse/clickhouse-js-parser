DROP TABLE IF EXISTS test;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE IF NOT EXISTS test
(
    id UInt32,
    track UInt8,
    codec String,
    content String,
    rdate Date DEFAULT '2018-02-03',
    track_id String DEFAULT concat(concat(concat(toString(track), '-'), codec), content)
)
ENGINE = MergeTree(rdate, (id, track_id), 8192);

INSERT INTO test (id, track, codec);

SELECT *
FROM test
ORDER BY id ASC;

INSERT INTO test (id, track, codec, content);