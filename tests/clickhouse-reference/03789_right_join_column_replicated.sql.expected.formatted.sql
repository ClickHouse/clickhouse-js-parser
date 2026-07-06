DROP TABLE IF EXISTS locations;

DROP TABLE IF EXISTS location_tags;

CREATE TABLE locations
(
    location_id UInt32,
    city_id UInt32,
    name String
)
ENGINE = MergeTree()
ORDER BY location_id;

CREATE TABLE location_tags
(
    location_id UInt32,
    name String,
    value String
)
ENGINE = MergeTree()
ORDER BY name;

INSERT INTO locations;

INSERT INTO location_tags;

SET query_plan_optimize_join_order_limit = '0';

SET query_plan_join_swap_table = '0';

SET join_algorithm = 'hash';

SELECT z1.value
FROM
    location_tags AS z2
RIGHT JOIN (
        SELECT
            l.city_id AS lcity_id,
            z1.value AS value
        FROM
            location_tags AS z1
        RIGHT JOIN locations AS l
            ON z1.location_id = l.location_id
    ) AS z1
    ON z2.location_id = lcity_id
ORDER BY 1 ASC;