DROP TABLE IF EXISTS users_03094;

CREATE TABLE users_03094
(
    name String,
    age Int16
)
ENGINE = Memory();

INSERT INTO users_03094;

INSERT INTO users_03094;

INSERT INTO users_03094;

SET enable_analyzer = '1';

SELECT
    multiIf(age > 30
    OR true, '1', '2') AS a,
    max(name)
FROM users_03094
GROUP BY a;