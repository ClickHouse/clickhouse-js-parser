SET merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 0.;

DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY i
SETTINGS index_granularity = '1';

INSERT INTO x;

SET max_rows_to_read = '3';

SELECT *
FROM x
WHERE _partition_id = partitionID(1);

SET max_rows_to_read = '5'; -- one row for subquery + subquery

SELECT *
FROM x
WHERE _partition_id IN (
        SELECT partitionID(number + 1)
        FROM numbers(1)
    );

-- trivial count optimization test
SET max_rows_to_read = '2'; -- one row for subquery + subquery itself

SELECT count()
FROM x
WHERE _partition_id IN (
        SELECT partitionID(number + 1)
        FROM numbers(1)
    );

DROP TABLE x;

DROP TABLE IF EXISTS mt;

CREATE TABLE mt
(
    n UInt64
)
ENGINE = MergeTree()
ORDER BY n
PARTITION BY n % 10;

SET max_rows_to_read = '200';

INSERT INTO mt SELECT *
FROM numbers(100);

SELECT *
FROM mt
WHERE toUInt64(substr(_part, 1, position(_part, '_') - 1)) = 1;

DROP TABLE mt;