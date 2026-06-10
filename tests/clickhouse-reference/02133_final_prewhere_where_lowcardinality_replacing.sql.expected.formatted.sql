DROP TABLE IF EXISTS errors_local;

CREATE TABLE errors_local
(
    level LowCardinality(String)
)
ENGINE = ReplacingMergeTree()
ORDER BY level
SETTINGS min_bytes_for_wide_part = '10000000';

INSERT INTO errors_local SELECT toString(number)
FROM numbers(10000);

SELECT toTypeName(level)
FROM errors_local FINAL
PREWHERE isNotNull(level)
WHERE isNotNull(level)
LIMIT 1;

DROP TABLE errors_local;

CREATE TABLE errors_local
(
    level LowCardinality(String)
)
ENGINE = ReplacingMergeTree()
ORDER BY level;