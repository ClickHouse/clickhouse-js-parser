-- force data path with the user/pass in it
SET use_compact_format_in_distributed_parts_names = '0';

-- use async send even for localhost
SET prefer_localhost_replica = '0';

DROP TABLE IF EXISTS dist_01555;

DROP TABLE IF EXISTS data_01555;

CREATE TABLE data_01555
(
    key Int
)
ENGINE = Null();

CREATE TABLE dist_01555
(
    key Int
)
ENGINE = Distributed(test_cluster_with_incorrect_pw, currentDatabase(), data_01555, key);

SYSTEM STOP DISTRIBUTED SENDS dist_01555;

INSERT INTO dist_01555;

-- since test_cluster_with_incorrect_pw contains incorrect password ignore error
SYSTEM FLUSH DISTRIBUTED dist_01555; -- { serverError AUTHENTICATION_FAILED }

SELECT
    length(splitByChar('*', data_path)),
    replaceRegexpOne(data_path, '^.*/([^/]*)/', '\\1'),
    extract(last_exception, 'AUTHENTICATION_FAILED'),
    dateDiff('s', last_exception_time, now()) < 3600
FROM `system`.distribution_queue
WHERE database = currentDatabase()
    AND table = 'dist_01555'
FORMAT CSV;

DROP TABLE dist_01555;

CREATE TABLE dist_01555
(
    key Int
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), data_01555, key);

SELECT
    length(splitByChar('*', data_path)),
    replaceRegexpOne(data_path, '^.*/([^/]*)/', '\\1')
FROM `system`.distribution_queue
WHERE database = currentDatabase()
    AND table = 'dist_01555'
FORMAT CSV;

DROP TABLE data_01555;