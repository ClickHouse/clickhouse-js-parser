DROP TABLE IF EXISTS xp;

DROP TABLE IF EXISTS xp_d;

SET log_queries = '1';

CREATE TABLE xp
(
    A Date,
    B Int64,
    S String
)
ENGINE = MergeTree()
ORDER BY B
PARTITION BY toYYYYMM(A);

INSERT INTO xp SELECT
    '2020-01-01',
    number,
    ''
FROM numbers(100000);

CREATE TABLE xp_d AS xp
ENGINE = Distributed(test_shard_localhost, currentDatabase(), xp);

SELECT count(7 = (
        SELECT number
        FROM numbers(0)
        ORDER BY number ASC NULLS FIRST
        LIMIT 7
    ))
FROM xp_d
PREWHERE toYYYYMM(A) GLOBAL IN (
        SELECT
            NULL = (
                SELECT number
                FROM numbers(1)
                ORDER BY number DESC NULLS LAST
                LIMIT 1
            ),
            toYYYYMM(min(A))
        FROM xp_d
    )
WHERE B > NULL
FORMAT Null;

SELECT count()
FROM xp_d
WHERE A GLOBAL IN (
        SELECT NULL
    );

DROP TABLE IF EXISTS trace_log;

CREATE TABLE trace_log
(
    event_date Date,
    event_time DateTime,
    event_time_microseconds DateTime64(6),
    timestamp_ns UInt64,
    revision UInt32,
    trace_type Enum8('Real' = 0, 'CPU' = 1, 'Memory' = 2, 'MemorySample' = 3),
    thread_id UInt64,
    query_id String,
    trace Array(UInt64),
    size Int64
)
ENGINE = MergeTree()
ORDER BY (event_date, event_time)
PARTITION BY toYYYYMM(event_date)
SETTINGS index_granularity = '8192';

INSERT INTO trace_log;

SET allow_introspection_functions = '1';

-- make sure query_log exists
SYSTEM FLUSH LOGS query_log;

WITH concat(addressToLine(arrayJoin(trace) AS addr), '#') AS symbol

SELECT count() > 7
FROM trace_log AS t
WHERE query_id = (
        SELECT
            [NULL, NULL, NULL, NULL, 0.00009999999747378752, NULL, NULL, NULL, NULL, NULL],
            query_id
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
            AND query LIKE '%test cpu time query profiler%'
            AND query NOT LIKE '%system%'
        ORDER BY event_time DESC
        LIMIT 1
    )
    AND symbol LIKE '%Source%';

WITH addressToSymbol(arrayJoin(trace)) AS symbol

SELECT count() > 0
FROM trace_log AS t
WHERE greaterOrEquals(event_date, ignore(ignore(ignore(NULL, '')), 256), yesterday())
    AND trace_type = 'Memory'
    AND query_id = (
        SELECT
            ignore(ignore(ignore(ignore(65536)), ignore(65537), ignore(2)), ''),
            query_id
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
            AND event_date >= yesterday()
            AND query LIKE '%test memory profiler%'
        ORDER BY event_time DESC
        LIMIT 1
    ); -- { serverError INCORRECT_RESULT_OF_SCALAR_SUBQUERY, 42 }

WITH (
        SELECT query_start_time_microseconds
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS time_with_microseconds,

(
        SELECT
            inf,
            query_start_time
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS t

SELECT if(dateDiff('second', toDateTime(time_with_microseconds), toDateTime(t)) = -9223372036854775808, 'ok', ''); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

WITH (
    (
        SELECT query_start_time_microseconds
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS time_with_microseconds,
    (
        SELECT
            inf,
            query_start_time
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS t)

SELECT if(dateDiff('second', toDateTime(time_with_microseconds), toDateTime(t)) = -9223372036854775808, 'ok', '')
SETTINGS enable_analyzer = '1'; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

WITH (
    (
        SELECT query_start_time_microseconds
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS time_with_microseconds,
    (
        SELECT query_start_time
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS t)

SELECT if(dateDiff('second', toDateTime(time_with_microseconds), toDateTime(t)) = -9223372036854775808, 'ok', '');

SET joined_subquery_requires_alias = '0', enable_analyzer = '0'; -- the query is invalid with a new analyzer

SELECT
    number,
    number / 2 AS n,
    j1,
    j2
FROM
    remote('127.0.0.{2,3}', `system`.numbers)
GLOBAL ANY LEFT JOIN (
        SELECT
            number / 3 AS n,
            number AS j1,
            'Hello' AS j2
        FROM `system`.numbers
        LIMIT 1048577
    )
    USING (n)
LIMIT 10
FORMAT Null;