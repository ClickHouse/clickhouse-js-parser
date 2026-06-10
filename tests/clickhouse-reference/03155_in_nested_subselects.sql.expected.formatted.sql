-- https://github.com/ClickHouse/ClickHouse/issues/63833
SET enable_analyzer = '1';

SET parallel_replicas_local_plan = '1';

CREATE TABLE Example
(
    id Int32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO Example SELECT number AS id
FROM numbers(2);

CREATE TABLE `Null` AS Example
ENGINE = Null();

--create table Null engine=MergeTree order by id as Example ;
CREATE MATERIALIZED VIEW Transform
TO Example
AS
SELECT *
FROM
    `Null`
INNER JOIN (
        SELECT *
        FROM Example
        WHERE id IN (
                SELECT *
                FROM (
                        SELECT *
                        FROM (
                                SELECT *
                                FROM (
                                        SELECT *
                                        FROM (
                                                SELECT *
                                                FROM `Null`
                                            )
                                    )
                            )
                    )
            )
    ) AS old
    USING (id);

INSERT INTO `Null` SELECT number AS id
FROM numbers(2);

SELECT *
FROM Example
ORDER BY `all` ASC; -- should return 4 rows