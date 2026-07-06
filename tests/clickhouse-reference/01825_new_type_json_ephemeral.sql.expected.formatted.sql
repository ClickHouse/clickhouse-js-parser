SET enable_json_type = '1';

DROP TABLE IF EXISTS t_github_json;

CREATE TABLE t_github_json
(
    event_type LowCardinality(String) DEFAULT JSONExtractString(message_raw, 'type'),
    repo_name LowCardinality(String) DEFAULT JSONExtractString(message_raw, 'repo', 'name'),
    message JSON DEFAULT empty(message_raw) ? '{}' : message_raw,
    message_raw String EPHEMERAL
)
ENGINE = MergeTree()
ORDER BY (event_type, repo_name);

INSERT INTO t_github_json (message_raw) FORMAT JSONEachRow;

DROP TABLE t_github_json;