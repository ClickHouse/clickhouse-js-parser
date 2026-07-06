SET allow_suspicious_codecs = '1';

CREATE TABLE t0
(
    c0 Float64 CODEC(ZSTD(), DoubleDelta())
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t0 (c0);

SELECT c0
FROM t0;