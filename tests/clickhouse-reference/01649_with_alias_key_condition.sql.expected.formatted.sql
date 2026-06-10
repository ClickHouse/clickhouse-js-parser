DROP TABLE IF EXISTS alias_key_condition;

CREATE TABLE alias_key_condition
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO alias_key_condition;

SET force_primary_key = '1';

WITH i AS k

SELECT *
FROM alias_key_condition
WHERE k = (
        SELECT i
        FROM alias_key_condition
        WHERE i = 3
    );