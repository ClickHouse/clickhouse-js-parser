DROP TABLE IF EXISTS null_lc_set_index;

CREATE TABLE null_lc_set_index
(
    timestamp DateTime,
    action LowCardinality(Nullable(String)),
    user LowCardinality(Nullable(String)),
    INDEX test_user_idx user TYPE set(0) GRANULARITY 8192
)
ENGINE = MergeTree()
ORDER BY (timestamp, action, cityHash64(user))
PARTITION BY toYYYYMMDD(timestamp)
SETTINGS allow_nullable_key = '1';

INSERT INTO null_lc_set_index;

INSERT INTO null_lc_set_index;

SELECT
    action,
    user
FROM null_lc_set_index
WHERE user = 'alice';