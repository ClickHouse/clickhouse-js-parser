-- Tags: no-parallel
DROP DICTIONARY IF EXISTS `system`.dict1;

CREATE DICTIONARY IF NOT EXISTS `system`.dict1
(
    bytes_allocated UInt64,
    element_count Int32,
    loading_start_time DateTime
)
PRIMARY KEY bytes_allocated
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' PASSWORD '' TABLE 'dictionaries' DB 'system'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT
    join_key,
    toTimeZone(dictGetDateTime('system.dict1', 'loading_start_time', toUInt64(dict_key)), 'UTC') AS datetime
FROM
    (
        SELECT
            dictGetInt32('system.dict1', 'element_count', toUInt64(dict_key)) AS join_key,
            1 AS dict_key
    ) AS js1
LEFT JOIN (
        SELECT toInt32(2) AS join_key
    ) AS js2
    USING (join_key)
WHERE now() >= datetime;