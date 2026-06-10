DROP TABLE IF EXISTS per_table_ttl_02265;

CREATE TABLE per_table_ttl_02265
(
    key Int,
    date Date,
    value String
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO per_table_ttl_02265;

-- { echoOn }
ALTER TABLE per_table_ttl_02265 MODIFY TTL date + toIntervalMonth(1);

SELECT count()
FROM `system`.mutations
WHERE database = currentDatabase()
    AND table = 'per_table_ttl_02265';

ALTER TABLE per_table_ttl_02265 MODIFY TTL date + toIntervalMonth(2);

ALTER TABLE per_table_ttl_02265 MODIFY TTL date + toIntervalMonth(2) GROUP BY key SET value = argMax(value, date);

ALTER TABLE per_table_ttl_02265 MODIFY TTL date + toIntervalMonth(2) RECOMPRESS CODEC(ZSTD(17));

-- { echoOff }
DROP TABLE per_table_ttl_02265;