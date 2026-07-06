-- https://github.com/ClickHouse/ClickHouse/issues/56521
SYSTEM FLUSH LOGS query_log;

SET enable_analyzer = '1';

SELECT
    count(1) AS num,
    hostName() AS hostName
FROM
    `system`.query_log AS a
INNER JOIN `system`.processes AS b
    ON a.query_id = b.query_id
    AND type = 'QueryStart'
    AND dateDiff('second', event_time, now()) > 5
    AND current_database = currentDatabase()
FORMAT Null;