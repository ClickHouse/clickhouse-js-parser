SELECT
    arrayMap(((x, y) -> floor((y - x) / x, 3)), l, r) AS diff_percent,
    test,
    query
FROM
    (
        SELECT [1] AS l
    ) AS s1,
    (
        SELECT [2] AS r
    ) AS s2,
    (
        SELECT
            'test' AS test,
            'query' AS query
    ) AS any_query,
    (
        SELECT 1
    ) AS check_single_query;

SELECT
    arrayMap((x -> floor(x, 4)), original_medians_array.medians_by_version[1] AS l) AS l_rounded,
    arrayMap((x -> floor(x, 4)), original_medians_array.medians_by_version[2] AS r) AS r_rounded,
    arrayMap(((x, y) -> floor((y - x) / x, 3)), l, r) AS diff_percent,
    test,
    query
FROM
    (
        SELECT 1
    ) AS rd,
    (
        SELECT [[1, 2], [3, 4]] AS medians_by_version
    ) AS original_medians_array,
    (
        SELECT
            'test' AS test,
            'query' AS query
    ) AS any_query,
    (
        SELECT 1 AS A
    ) AS check_single_query;

DROP TABLE IF EXISTS table;

CREATE TABLE table
(
    query String,
    test String,
    run UInt32,
    metrics Array(UInt32),
    version UInt32
)
ENGINE = Memory();

SELECT
    arrayMap((x -> floor(x, 4)), original_medians_array.medians_by_version[1] AS l) AS l_rounded,
    arrayMap((x -> floor(x, 4)), original_medians_array.medians_by_version[2] AS r) AS r_rounded,
    arrayMap(((x, y) -> floor((y - x) / x, 3)), l, r) AS diff_percent,
    arrayMap(((x, y) -> floor(x / y, 3)), threshold, l) AS threshold_percent,
    test,
    query
FROM
    (
        SELECT quantileExactForEach(0.999)(arrayMap(((x, y) -> abs(x - y)), metrics_by_label[1], metrics_by_label[2]) AS d) AS threshold
        FROM (
                SELECT
                    virtual_run,
                    groupArrayInsertAt(median_metrics, random_label) AS metrics_by_label
                FROM (
                        SELECT
                            medianExactForEach(metrics) AS median_metrics,
                            virtual_run,
                            random_label
                        FROM (
                                SELECT
                                    *,
                                    toUInt32(rowNumberInAllBlocks() % 2) AS random_label
                                FROM (
                                        SELECT
                                            metrics,
                                            number AS virtual_run
                                        FROM
                                            (
                                                SELECT
                                                    metrics,
                                                    run,
                                                    version
                                                FROM table
                                            ) AS no_query,
                                            numbers(1, 100000) AS nn
                                        ORDER BY
                                            virtual_run ASC,
                                            rand() ASC
                                    ) AS virtual_runs
                            ) AS relabeled
                        GROUP BY
                            virtual_run,
                            random_label
                    ) AS virtual_medians
                GROUP BY virtual_run
            ) AS virtual_medians_array
    ) AS rd,
    (
        SELECT groupArrayInsertAt(median_metrics, version) AS medians_by_version
        FROM (
                SELECT
                    medianExactForEach(metrics) AS median_metrics,
                    version
                FROM table
                GROUP BY version
            ) AS original_medians
    ) AS original_medians_array,
    (
        SELECT
            any(test) AS test,
            any(query) AS query
        FROM table
    ) AS any_query,
    (
        SELECT throwIf(uniq((test, query)))
        FROM table
    ) AS check_single_query;

DROP TABLE table;