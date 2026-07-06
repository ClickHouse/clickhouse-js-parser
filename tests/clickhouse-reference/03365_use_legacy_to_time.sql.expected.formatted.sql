SET session_timezone = 'UTC';

SET use_legacy_to_time = '0';

WITH toTime(toDateTime(12)) AS a

SELECT
    toTypeName(a),
    a;

SET use_legacy_to_time = '1';