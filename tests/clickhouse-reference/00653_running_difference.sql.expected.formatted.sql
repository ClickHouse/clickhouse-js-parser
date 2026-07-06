SET allow_deprecated_error_prone_window_functions = '1';

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin([0, 1, 5, 10]) AS x
    );

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin([2, NULL, 3, NULL, 10]) AS x
    );

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin([NULL, 1]) AS x
    );

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin([NULL, NULL, 1, 3, NULL, NULL, 5]) AS x
    );

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin(CAST('[0, 1, 5, 10, 170141183460469231731687303715884105727]' AS Array(UInt128))) AS x
    );

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin(CAST('[0, 1, 5, 10, 170141183460469231731687303715884105728]' AS Array(UInt256))) AS x
    );

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin(CAST('[0, 1, 5, 10, 170141183460469231731687303715884105727]' AS Array(Int128))) AS x
    );

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin(CAST('[0, 1, 5, 10, 170141183460469231731687303715884105728]' AS Array(Int256))) AS x
    );

SELECT '--Date Difference--';

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin([NULL, NULL, toDate('1970-1-1'), toDate('1970-12-31'), NULL, NULL, toDate('2010-8-9')]) AS x
    );

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin([NULL, NULL, toDate32('1900-1-1'), toDate32('1930-5-25'), toDate('1990-9-4'), NULL, toDate32('2279-5-4')]) AS x
    );

SELECT runningDifference(x)
FROM (
        SELECT arrayJoin([NULL, NULL, toDateTime('1970-06-28 23:48:12', 'Asia/Istanbul'), toDateTime('2070-04-12 21:16:41', 'Asia/Istanbul'), NULL, NULL, toDateTime('2106-02-03 06:38:52', 'Asia/Istanbul')]) AS x
    );