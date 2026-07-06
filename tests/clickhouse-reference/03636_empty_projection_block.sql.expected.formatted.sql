-- This test would hit a LOGICAL_ERROR during merge
CREATE TABLE post_state
(
    ts DateTime,
    id Int64,
    state Nullable(UInt8) TTL ts + toIntervalMonth(1),
    PROJECTION p_digest_posts_state (SELECT id, argMax(state, ts) AS state GROUP BY id)
)
ENGINE = MergeTree()
ORDER BY id
TTL ts + toIntervalSecond(0) WHERE state IS NULL
SETTINGS index_granularity = '8192', deduplicate_merge_projection_mode = 'rebuild';

SYSTEM STOP MERGES post_state;

INSERT INTO post_state;

INSERT INTO post_state;

SYSTEM START MERGES post_state;

OPTIMIZE TABLE post_state;