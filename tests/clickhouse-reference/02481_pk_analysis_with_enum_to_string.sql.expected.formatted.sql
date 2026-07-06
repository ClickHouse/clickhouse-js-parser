CREATE TABLE gen
(
    repo_name String,
    event_type Enum8('CommitCommentEvent' = 1, 'CreateEvent' = 2, 'DeleteEvent' = 3, 'ForkEvent' = 4, 'GollumEvent' = 5, 'IssueCommentEvent' = 6, 'IssuesEvent' = 7, 'MemberEvent' = 8, 'PublicEvent' = 9, 'PullRequestEvent' = 10, 'PullRequestReviewCommentEvent' = 11, 'PushEvent' = 12, 'ReleaseEvent' = 13, 'SponsorshipEvent' = 14, 'WatchEvent' = 15, 'GistEvent' = 16, 'FollowEvent' = 17, 'DownloadEvent' = 18, 'PullRequestReviewEvent' = 19, 'ForkApplyEvent' = 20, 'Event' = 21, 'TeamAddEvent' = 22),
    actor_login String,
    created_at DateTime,
    action Enum8('none' = 0, 'created' = 1, 'added' = 2, 'edited' = 3, 'deleted' = 4, 'opened' = 5, 'closed' = 6, 'reopened' = 7, 'assigned' = 8, 'unassigned' = 9, 'labeled' = 10, 'unlabeled' = 11, 'review_requested' = 12, 'review_request_removed' = 13, 'synchronize' = 14, 'started' = 15, 'published' = 16, 'update' = 17, 'create' = 18, 'fork' = 19, 'merged' = 20),
    number UInt32,
    merged_at DateTime
)
ENGINE = GenerateRandom();

CREATE TABLE github_events AS gen
ENGINE = MergeTree()
ORDER BY (event_type, repo_name, created_at)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO github_events SELECT *
FROM gen
LIMIT 100000;

INSERT INTO github_events;

OPTIMIZE TABLE github_events FINAL;

SELECT count()
FROM github_events
WHERE repo_name = 'apache/pulsar'
    AND toString(event_type) IN ('PullRequestEvent', 'PullRequestReviewCommentEvent', 'PullRequestReviewEvent', 'IssueCommentEvent')
    AND actor_login NOT IN ('github-actions[bot]', 'codecov-commenter')
    AND number = 9276;