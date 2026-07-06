DROP TABLE IF EXISTS users;

CREATE TABLE users
(
    name String,
    score UInt8,
    user_level String ALIAS multiIf(score <= 3, 'LOW', score <= 6, 'MEDIUM', 'HIGH')
)
ENGINE = MergeTree()
ORDER BY name;

INSERT INTO users;

SELECT
    user_level AS level_alias,
    uniq(name) AS name_alias,
    grouping(level_alias) AS _totals
FROM remote('127.0.0.{1,2}', currentDatabase(), users)
GROUP BY GROUPING SETS ((level_alias))
ORDER BY name_alias DESC;