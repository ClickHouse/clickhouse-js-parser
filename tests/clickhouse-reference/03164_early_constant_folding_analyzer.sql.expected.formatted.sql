CREATE TABLE checks
(
    pull_request_number UInt32,
    commit_sha LowCardinality(String),
    check_name LowCardinality(String),
    check_status LowCardinality(String),
    check_duration_ms UInt64,
    check_start_time DateTime,
    test_name LowCardinality(String),
    test_status LowCardinality(String),
    test_duration_ms UInt64,
    report_url String,
    pull_request_url String,
    commit_url String,
    task_url String,
    base_ref String,
    base_repo String,
    head_ref String,
    head_repo String,
    test_context_raw String,
    instance_type LowCardinality(String),
    instance_id String,
    date Date MATERIALIZED toDate(check_start_time)
)
ENGINE = MergeTree()
ORDER BY (date, pull_request_number, commit_sha, check_name, test_name, check_start_time);

INSERT INTO checks SELECT *
FROM generateRandom()
LIMIT 1;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT count(1)
                FROM checks
                WHERE test_name IS NOT NULL
            ))
    )
WHERE `explain` LIKE '%ReadFromPreparedSource%'
SETTINGS
    enable_analyzer = '1',
    enable_parallel_replicas = '0';