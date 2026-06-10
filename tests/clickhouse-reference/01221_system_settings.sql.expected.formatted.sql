-- Tags: no-object-storage
SELECT *
FROM `system`.`settings`
WHERE name = 'send_timeout';

SELECT *
FROM `system`.merge_tree_settings
WHERE name = 'index_granularity';

WITH ['Seconds', 'Bool', 'Int64', 'String', 'Char', 'LogsLevel', 'URI', 'Float', 'UInt64', 'MaxThreads', 'Milliseconds', 'JoinStrictness', 'JoinAlgorithm', 'OverflowMode', 'TotalsMode', 'LoadBalancing', 'OverflowModeGroupBy', 'DateTimeInputFormat', 'DistributedProductMode'] AS types

SELECT hasAll(arrayDistinct(groupArray(type)), types)
FROM `system`.`settings`;

WITH ['Seconds', 'Bool', 'Int64', 'String', 'Float', 'UInt64', 'MaxThreads'] AS types

SELECT hasAll(arrayDistinct(groupArray(type)), types)
FROM `system`.merge_tree_settings;