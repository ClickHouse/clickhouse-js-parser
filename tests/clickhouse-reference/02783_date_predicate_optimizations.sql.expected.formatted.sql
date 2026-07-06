CREATE TABLE source
(
    ts DateTime('UTC'),
    n Int32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toYYYYMM(ts);

INSERT INTO source;

SELECT *
FROM source
WHERE toYYYYMM(ts) = 202112;

SELECT *
FROM source
WHERE toYear(ts) = 2021;

SELECT *
FROM source
WHERE toYYYYMM(ts) = 202112
SETTINGS enable_analyzer = '1';

SELECT *
FROM source
WHERE toYear(ts) = 2021
SETTINGS enable_analyzer = '1';

DROP TABLE IF EXISTS source;

CREATE TABLE source
(
    dt Date,
    ts DateTime,
    dt_32 Date32,
    ts_64 DateTime64(3),
    n Int32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toYYYYMM(ts);

INSERT INTO source;

INSERT INTO source;

INSERT INTO source;

INSERT INTO source;

INSERT INTO source;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) = 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) != 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) < 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) <= 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) > 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) >= 202312;

SELECT count(*)
FROM source
WHERE toYear(dt) = 2023;

SELECT count(*)
FROM source
WHERE toYear(dt) != 2023;

SELECT count(*)
FROM source
WHERE toYear(dt) < 2023;

SELECT count(*)
FROM source
WHERE toYear(dt) <= 2023;

SELECT count(*)
FROM source
WHERE toYear(dt) > 2023;

SELECT count(*)
FROM source
WHERE toYear(dt) >= 2023;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) = 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) != 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) < 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) <= 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) > 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt) >= 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt) = 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt) != 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt) < 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt) <= 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt) > 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt) >= 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) = 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) != 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) < 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) <= 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) > 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) >= 202312;

SELECT count(*)
FROM source
WHERE toYear(ts) = 2023;

SELECT count(*)
FROM source
WHERE toYear(ts) != 2023;

SELECT count(*)
FROM source
WHERE toYear(ts) < 2023;

SELECT count(*)
FROM source
WHERE toYear(ts) <= 2023;

SELECT count(*)
FROM source
WHERE toYear(ts) > 2023;

SELECT count(*)
FROM source
WHERE toYear(ts) >= 2023;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) = 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) != 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) < 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) <= 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) > 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts) >= 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts) = 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts) != 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts) < 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts) <= 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts) > 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts) >= 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) = 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) != 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) < 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) <= 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) > 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) >= 202312;

SELECT count(*)
FROM source
WHERE toYear(dt_32) = 2023;

SELECT count(*)
FROM source
WHERE toYear(dt_32) != 2023;

SELECT count(*)
FROM source
WHERE toYear(dt_32) < 2023;

SELECT count(*)
FROM source
WHERE toYear(dt_32) <= 2023;

SELECT count(*)
FROM source
WHERE toYear(dt_32) > 2023;

SELECT count(*)
FROM source
WHERE toYear(dt_32) >= 2023;

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) = 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) != 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) < 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) <= 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) > 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(dt_32) >= 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt_32) = 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt_32) != 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt_32) < 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt_32) <= 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt_32) > 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(dt_32) >= 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) = 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) != 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) < 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) <= 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) > 202312;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) >= 202312;

SELECT count(*)
FROM source
WHERE toYear(ts_64) = 2023;

SELECT count(*)
FROM source
WHERE toYear(ts_64) != 2023;

SELECT count(*)
FROM source
WHERE toYear(ts_64) < 2023;

SELECT count(*)
FROM source
WHERE toYear(ts_64) <= 2023;

SELECT count(*)
FROM source
WHERE toYear(ts_64) > 2023;

SELECT count(*)
FROM source
WHERE toYear(ts_64) >= 2023;

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) = 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) != 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) < 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) <= 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) > 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYYYYMM(ts_64) >= 202312
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts_64) = 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts_64) != 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts_64) < 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts_64) <= 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts_64) > 2023
SETTINGS enable_analyzer = '1';

SELECT count(*)
FROM source
WHERE toYear(ts_64) >= 2023
SETTINGS enable_analyzer = '1';

DROP TABLE source;