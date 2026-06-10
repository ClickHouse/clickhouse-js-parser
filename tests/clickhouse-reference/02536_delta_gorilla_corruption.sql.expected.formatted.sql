-- Tags: no-asan
-- no-asan: the flaky check complains that the test sometimes runs > 60 sec on asan builds
SET allow_suspicious_codecs = '1';

DROP TABLE IF EXISTS bug_delta_gorilla;

CREATE TABLE bug_delta_gorilla
(
    value_bug UInt64 CODEC(Delta(), Gorilla())
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi' AS
SELECT 0
FROM numbers(20000000);

SELECT count(*)
FROM bug_delta_gorilla
WHERE 0 != value_bug;

CREATE TABLE bug_delta_gorilla
(
    val UInt64 CODEC(Delta(), Gorilla())
)
ENGINE = MergeTree()
ORDER BY val
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO bug_delta_gorilla;

SELECT *
FROM bug_delta_gorilla;