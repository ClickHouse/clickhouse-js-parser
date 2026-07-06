DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id Nullable(String),
    status Nullable(Enum8('NEW' = 0, 'CANCEL' = 1)),
    `nested.nestedType` Array(Nullable(String)),
    `partition` Date
)
ENGINE = MergeTree()
ORDER BY `partition`
PARTITION BY `partition`
SETTINGS index_granularity = '8192';

INSERT INTO test;

SELECT
    status,
    count() AS `all`
FROM
    test
ARRAY JOIN nested AS nestedJoined
WHERE status IN (
        SELECT status
        FROM
            test
        ARRAY JOIN nested AS nestedJoined
        GROUP BY status
        ORDER BY count() DESC
        LIMIT 10
    )
    AND id IN ('1', '2')
GROUP BY status
WITH CUBE
LIMIT 100;

DROP TABLE test;