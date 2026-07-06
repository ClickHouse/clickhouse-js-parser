-- Tags: long, zookeeper
-- Replicated
SET allow_suspicious_ttl_expressions = '0';

DROP TABLE IF EXISTS replicated_ttl_00933 SYNC;

-- Create
CREATE TABLE replicated_ttl_00933
(
    a Int32,
    d DateTime
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_ttl_00933', 'r1')
ORDER BY a
PARTITION BY tuple()
TTL now() + toIntervalSecond(1); -- { serverError BAD_ARGUMENTS }

SET allow_suspicious_ttl_expressions = '1';

ALTER TABLE replicated_ttl_00933 MODIFY TTL now() + toIntervalDay(1); -- { serverError BAD_ARGUMENTS }

CREATE TABLE replicated_ttl_00933
(
    a Int32 TTL now() + toIntervalSecond(1),
    d DateTime
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_ttl_00933', 'r1')
ORDER BY d; -- { serverError BAD_ARGUMENTS }

ALTER TABLE replicated_ttl_00933 MODIFY COLUMN a Int32 TTL now() + toIntervalDay(1); -- { serverError BAD_ARGUMENTS }

SHOW CREATE TABLE replicated_ttl_00933;