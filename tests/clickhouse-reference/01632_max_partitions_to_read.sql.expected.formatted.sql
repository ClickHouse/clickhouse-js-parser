DROP TABLE IF EXISTS p;

CREATE TABLE p
(
    d Date,
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY i
PARTITION BY d
SETTINGS max_partitions_to_read = '1';

INSERT INTO p;

SELECT *
FROM p
ORDER BY i ASC; -- { serverError TOO_MANY_PARTITIONS }

SELECT *
FROM p
ORDER BY i ASC
SETTINGS max_partitions_to_read = '2';

SELECT *
FROM p
ORDER BY i ASC
SETTINGS max_partitions_to_read = '0'; -- unlimited

ALTER TABLE p MODIFY SETTING max_partitions_to_read = '2';