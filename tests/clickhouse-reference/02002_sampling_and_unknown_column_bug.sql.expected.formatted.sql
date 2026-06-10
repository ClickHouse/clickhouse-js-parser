DROP TABLE IF EXISTS sessions;

CREATE TABLE sessions
(
    user_id UInt64
)
ENGINE = MergeTree()
ORDER BY user_id
SAMPLE BY user_id;

INSERT INTO sessions;

SELECT sum(user_id * _sample_factor)
FROM sessions SAMPLE 10000000;

SELECT
    uniq(user_id) AS a,
    min(_sample_factor) AS x,
    a * x
FROM sessions SAMPLE 10000000;