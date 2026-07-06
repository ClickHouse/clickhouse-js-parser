DROP TABLE IF EXISTS partition_and_primary_keys_using_same_expression;

CREATE TABLE partition_and_primary_keys_using_same_expression
(
    dt DateTime
)
ENGINE = MergeTree()
ORDER BY toDayOfWeek(toDate(dt))
PARTITION BY toDate(dt);

INSERT INTO partition_and_primary_keys_using_same_expression;

INSERT INTO partition_and_primary_keys_using_same_expression;

SELECT *
FROM partition_and_primary_keys_using_same_expression
ORDER BY dt ASC;

SELECT '---';

ALTER TABLE partition_and_primary_keys_using_same_expression DROP PARTITION '2018-02-20';

DROP TABLE partition_and_primary_keys_using_same_expression;