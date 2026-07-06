CREATE TABLE query_run_metric_arrays
ENGINE = Memory() AS
WITH (
        WITH (
                SELECT groupUniqArrayArray(['a', 'b'])
                FROM numbers(1)
            ) AS all_names

        SELECT all_names
    ) AS all_metrics

SELECT all_metrics;

SELECT *
FROM query_run_metric_arrays;