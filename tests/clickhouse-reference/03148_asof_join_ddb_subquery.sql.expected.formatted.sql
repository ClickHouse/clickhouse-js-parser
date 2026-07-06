DROP TABLE IF EXISTS events;

CREATE TABLE events
(
    begin Float64,
    value Int32
)
ENGINE = MergeTree()
ORDER BY begin;

INSERT INTO events;

SET enable_analyzer = '1';

SET join_algorithm = 'full_sorting_merge';

SET joined_subquery_requires_alias = '0';

SELECT
    begin,
    value IN (
        SELECT e1.value
        FROM
            (
                SELECT *
                FROM events AS e1
                WHERE e1.value = events.value
            ) AS e1
        ASOF INNER JOIN (
                SELECT number::Float64 AS begin
                FROM numbers(10)
                WHERE number >= 1
                    AND number < 10
            )
            USING (begin)
    )
FROM events
ORDER BY begin ASC;