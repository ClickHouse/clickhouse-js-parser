SET allow_deprecated_error_prone_window_functions = '1';

CREATE TABLE t
(
    rDate String,
    cpu_total Int64
)
ENGINE = Log();

INSERT INTO t;

SELECT cpu_total_week
FROM (
        WITH neighbor(cpu_total, 7) AS cpu_total_7

        SELECT
            rDate,
            floor(multiIf(cpu_total_7 = 0, 0, cpu_total - cpu_total_7), 2) AS cpu_total_week
        FROM t
    ) AS t_table_471873
WHERE rDate >= '2022-03-06'
    AND rDate <= '2022-03-06'
SETTINGS enable_optimize_predicate_expression = '1';