SELECT
    count(number),
    1 AS k1,
    2 AS k2,
    3 AS k3
FROM numbers_mt(10000000)
GROUP BY
    k1,
    k2,
    k3
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '0',
    compile_aggregate_expressions = '0';

SELECT
    count(number),
    1 AS k1,
    2 AS k2,
    3 AS k3
FROM numbers_mt(10000000)
GROUP BY
    k1,
    k2,
    k3
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '1',
    compile_aggregate_expressions = '0';

SELECT
    count(number),
    1 AS k1,
    2 AS k2,
    3 AS k3
FROM numbers_mt(10000000)
GROUP BY
    k1,
    k2,
    k3
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '0',
    compile_aggregate_expressions = '1';

SELECT
    count(number),
    1 AS k1,
    2 AS k2,
    3 AS k3
FROM numbers_mt(10000000)
GROUP BY
    k1,
    k2,
    k3
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '1',
    compile_aggregate_expressions = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt64
)
ENGINE = File(JSON);

SET engine_file_allow_create_multiple_files = '1';

INSERT INTO test SELECT *
FROM numbers(10);

SELECT count()
FROM test
GROUP BY _file
ORDER BY _file ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '0',
    compile_aggregate_expressions = '0';

SELECT count()
FROM test
GROUP BY _file
ORDER BY _file ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '1',
    compile_aggregate_expressions = '0';

SELECT count()
FROM test
GROUP BY _file
ORDER BY _file ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '0',
    compile_aggregate_expressions = '1';

SELECT count()
FROM test
GROUP BY _file
ORDER BY _file ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '1',
    compile_aggregate_expressions = '1';

SELECT
    count(),
    _file
FROM test
GROUP BY _file
ORDER BY _file ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '0',
    compile_aggregate_expressions = '0';

SELECT
    count(),
    _file
FROM test
GROUP BY _file
ORDER BY _file ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '1',
    compile_aggregate_expressions = '0';

SELECT
    count(),
    _file
FROM test
GROUP BY _file
ORDER BY _file ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '0',
    compile_aggregate_expressions = '1';

SELECT
    count(),
    _file
FROM test
GROUP BY _file
ORDER BY _file ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '1',
    compile_aggregate_expressions = '1';

SELECT count()
FROM test
GROUP BY
    _file,
    _path
ORDER BY
    _file ASC,
    _path ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '0',
    compile_aggregate_expressions = '0';

SELECT count()
FROM test
GROUP BY
    _file,
    _path
ORDER BY
    _file ASC,
    _path ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '1',
    compile_aggregate_expressions = '0';

SELECT count()
FROM test
GROUP BY
    _file,
    _path
ORDER BY
    _file ASC,
    _path ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '0',
    compile_aggregate_expressions = '1';

SELECT count()
FROM test
GROUP BY
    _file,
    _path
ORDER BY
    _file ASC,
    _path ASC
SETTINGS
    optimize_group_by_constant_keys = '1',
    enable_software_prefetch_in_aggregation = '1',
    compile_aggregate_expressions = '1';

DROP TABLE test;