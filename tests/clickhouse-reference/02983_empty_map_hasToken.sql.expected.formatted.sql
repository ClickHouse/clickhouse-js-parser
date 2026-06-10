-- https://github.com/ClickHouse/ClickHouse/issues/60223
CREATE TABLE test
(
    t String,
    id String,
    h Map(String, String)
)
ENGINE = MergeTree()
ORDER BY (t, id)
SETTINGS index_granularity = '4096';

INSERT INTO test;

INSERT INTO test;

INSERT INTO test SELECT
    'xxx',
    number,
    map('content-type', 'x')
FROM numbers(100.);

OPTIMIZE TABLE test FINAL;

SELECT count()
FROM test
PREWHERE hasToken(h['user-agent'], 'bulk')
WHERE hasToken(h['user-agent'], 'tests')
    AND t = 'xxx';

SELECT count()
FROM test
PREWHERE hasToken(h['user-agent'], 'tests')
WHERE hasToken(h['user-agent'], 'bulk')
    AND t = 'xxx';

SELECT count()
FROM test
WHERE hasToken(h['user-agent'], 'bulk')
    AND hasToken(h['user-agent'], 'tests')
    AND t = 'xxx';

SELECT count()
FROM test
PREWHERE hasToken(h['user-agent'], 'bulk')
    AND hasToken(h['user-agent'], 'tests')
    AND t = 'xxx';

SELECT count()
FROM test
PREWHERE hasToken(h['user-agent'], 'bulk')
    AND hasToken(h['user-agent'], 'tests')
WHERE t = 'xxx';

SELECT count()
FROM test
PREWHERE hasToken(h['user-agent'], 'tests')
    AND hasToken(h['user-agent'], 'bulk')
WHERE t = 'xxx';

SELECT count()
FROM test
PREWHERE hasToken(h['user-agent'], 'tests')
    AND hasToken(h['user-agent'], 'bulk');

SELECT count()
FROM test
PREWHERE hasToken(h['user-agent'], 'bulk')
    AND hasToken(h['user-agent'], 'tests');

SELECT count()
FROM test
WHERE hasToken(h['user-agent'], 'tests')
    AND hasToken(h['user-agent'], 'bulk');

SELECT count()
FROM test
WHERE hasToken(h['user-agent'], 'bulk')
    AND hasToken(h['user-agent'], 'tests');