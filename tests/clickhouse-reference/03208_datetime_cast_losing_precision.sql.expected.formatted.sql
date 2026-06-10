WITH toDateTime('2024-10-16 18:00:30') AS t

SELECT toDateTime64(t, 3) + toIntervalMillisecond(100) IN (
        SELECT t
    )
SETTINGS transform_null_in = '0';

WITH toDateTime('2024-10-16 18:00:30') AS t

SELECT toDateTime64(t, 3) + toIntervalMillisecond(100) IN (
        SELECT t
    )
SETTINGS transform_null_in = '1';

WITH toDateTime('1970-01-01 00:00:01') AS t

SELECT toDateTime64(t, 3) + toIntervalMillisecond(100) IN (now(), NULL)
SETTINGS transform_null_in = '1';

WITH toDateTime('1970-01-01 00:00:01') AS t

SELECT toDateTime64(t, 3) + toIntervalMillisecond(100) IN (now(), NULL)
SETTINGS transform_null_in = '0';

WITH toDateTime('1970-01-01 00:00:01') AS t,

arrayJoin([NULL, toDateTime64(t, 3) + toIntervalMillisecond(100)]) AS x

SELECT x IN (now(), NULL)
SETTINGS transform_null_in = '0';

WITH toDateTime('1970-01-01 00:00:01') AS t,

arrayJoin([NULL, toDateTime64(t, 3) + toIntervalMillisecond(100)]) AS x

SELECT x IN (now(), NULL)
SETTINGS transform_null_in = '1';

WITH toDateTime('2024-10-16 18:00:30') AS t

SELECT (
        SELECT
            toDateTime64(t, 3) + toIntervalMillisecond(100),
            toDateTime64(t, 3) + toIntervalMillisecond(101)
    ) IN (
        SELECT
            t,
            t
    )
SETTINGS transform_null_in = '0';

WITH toDateTime('2024-10-16 18:00:30') AS t

SELECT (
        SELECT
            toDateTime64(t, 3) + toIntervalMillisecond(100),
            toDateTime64(t, 3) + toIntervalMillisecond(101)
    ) IN (
        SELECT
            t,
            t
    )
SETTINGS transform_null_in = '1';