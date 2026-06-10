SET enable_analyzer = '1';

SET enable_named_columns_in_function_tuple = '1';

SELECT * APPLY(finalizeAggregation)
FROM (
        WITH CAST('(1, 2)' AS Tuple(a int, b int)) AS nt

        SELECT
            uniqState(nt)::AggregateFunction(uniq, Tuple(int, int)) AS x,
            uniqState([nt])::AggregateFunction(uniq, Array(Tuple(int, int))) AS y,
            uniqState(map(nt, nt))::AggregateFunction(uniq, Map(Tuple(int, int), Tuple(int, int))) AS z
    )
FORMAT JSONEachRow;

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS users2;

DROP TABLE IF EXISTS test_mv;

CREATE TABLE users
(
    id UInt8,
    city String,
    name String
)
ENGINE = Memory();

CREATE TABLE users2
(
    id UInt8,
    city_name_uniq AggregateFunction(uniq, Tuple(String, String))
)
ENGINE = AggregatingMergeTree()
ORDER BY id;

CREATE MATERIALIZED VIEW test_mv
TO users2
AS
SELECT
    id,
    uniqState((city, name)) AS city_name_uniq
FROM users
GROUP BY id;

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

SELECT
    id,
    uniqMerge(city_name_uniq)
FROM users2
GROUP BY id
ORDER BY id ASC;