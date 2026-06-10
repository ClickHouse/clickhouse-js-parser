DROP TABLE IF EXISTS test_table_join;

CREATE TABLE test_table_join
(
    id UInt64,
    value String
)
ENGINE = Join(`Any`, `Left`, id);

INSERT INTO test_table_join;

INSERT INTO test_table_join SELECT *
FROM test_table_join; -- { serverError DEADLOCK_AVOIDED }

INSERT INTO test_table_join SELECT *
FROM
    (
        SELECT 1 AS id
    ) AS t1
ANY LEFT JOIN test_table_join
    USING (id); -- { serverError DEADLOCK_AVOIDED }

INSERT INTO test_table_join SELECT
    id,
    toString(id)
FROM
    (
        SELECT 1 AS id
    ) AS t1
ANY LEFT JOIN (
        SELECT id
        FROM test_table_join
    ) AS t2
    USING (id); -- { serverError DEADLOCK_AVOIDED }