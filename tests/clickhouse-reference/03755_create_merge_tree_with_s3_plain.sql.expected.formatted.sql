-- Tags: no-fasttest
CREATE OR REPLACE TABLE t0
(
    c0 Int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS storage_policy = 'policy_03755';

INSERT INTO t0 (c0); -- { serverError NOT_IMPLEMENTED }

CREATE OR REPLACE TABLE t1
(
    c0 Int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS non_replicated_deduplication_window = '2', storage_policy = 'policy_03755';

INSERT INTO t1 (c0); -- { serverError NOT_IMPLEMENTED }