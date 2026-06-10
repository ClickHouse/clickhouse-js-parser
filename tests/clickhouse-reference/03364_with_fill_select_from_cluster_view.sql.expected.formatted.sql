SET param_CurrentStart = '2025-02-09', param_CurrentEnd = '2025-02-11';

SET prefer_localhost_replica = '0';

SELECT *
FROM cluster(test_shard_localhost, view(    SELECT
        toDate('placeholder'),
        dummy::Date AS x
    FROM `system`.one
    ORDER BY x ASC WITH FILL FROM toDate('placeholder') TO toDate('placeholder') + toIntervalDay(1) STEP toIntervalDay(1)));