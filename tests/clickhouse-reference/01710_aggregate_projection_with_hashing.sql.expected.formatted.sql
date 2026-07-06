SET optimize_use_projections = '1', force_optimize_projection = '1';

DROP TABLE IF EXISTS tp;

CREATE TABLE tp
(
    type Int32,
    device UUID,
    cnt UInt64
)
ENGINE = MergeTree()
ORDER BY (type, device);

INSERT INTO tp SELECT
    number % 3,
    generateUUIDv4(),
    1
FROM numbers(300);

ALTER TABLE tp ADD PROJECTION uniq_city_proj (SELECT type, uniq(cityHash64(device)), sum(cnt) GROUP BY type);

ALTER TABLE tp MATERIALIZE PROJECTION uniq_city_proj SETTINGS mutations_sync = '1';

DROP TABLE tp;