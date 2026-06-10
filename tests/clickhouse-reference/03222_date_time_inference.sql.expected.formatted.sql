SET input_format_try_infer_datetimes = '1';

SET input_format_try_infer_dates = '1';

SET schema_inference_make_columns_nullable = '0';

SET input_format_json_try_infer_numbers_from_strings = '0';

SET session_timezone = 'UTC';

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020:01:01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020:1:01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020:01:1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020:1:1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-1-01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-1-1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020/01/01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020/1/01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020/01/1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020/1/1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020_01_01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020_1_01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020_01_1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020_1_1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020a01a01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020a1a01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020a01a1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020a1a1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20200101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020:01:01 42:42:42"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020/01/01 42:42:42"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-01 42:42:42"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020_01_01 42:42:42"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020a01a01 42:42:42"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-01 42.42.42"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-01 42 42 42"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-01 42a42a42"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020:01:01 42:42:42.4242"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020/01/01 42:42:42.4242"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-01 42:42:42.4242"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020_01_01 42:42:42.4242"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020a01a01 42:42:42.4242"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-01 42.42.42.4242"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-01 42 42 42.4242"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2020-01-01 42a42a42.4242"}');

SET date_time_input_format = 'best_effort';

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01-01 00:00:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01-01 01:00:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01-01 01:00:00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/17 010203 MSK"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/17 010203.000 MSK"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/17 010203 MSK+0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/17 010203.000 MSK+0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/17 010203 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/17 010203.000 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/17 010203Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/17 010203.000Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/1970 010203Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/1970 010203.000Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/70 010203Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "02/01/70 010203.000Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "11 Feb 2018 06:40:50 +0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "11 Feb 2018 06:40:50.000 +0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "17 Apr 2000 2 1:2:3"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "17 Apr 2000 2 1:2:3.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "19700102 01:00:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "19700102 01:00:00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "19700102010203Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "19700102010203Z.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "1970/01/02 010203Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "1970/01/02 010203.000Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2016-01-01MSD"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2016-01-01 MSD"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2016-01-01UTC"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2016-01-01Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "201701 02 010203 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "201701 02 010203.000 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05+0"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000+0"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05+00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000+00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05+0000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000+0000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05 -0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000 -0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05+030"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000+030"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05+1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000+1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05+300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000+300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05+900"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000+900"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05GMT"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000GMT"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05 MSD"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000 MSD"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05 MSD Feb"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000 MSD Feb"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05 MSD Jun"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000 MSD Jun"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05 MSK"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02 03:04:05.000 MSK"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05+00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05.000+00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05 -0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05.000 -0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05-0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05.000-0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05+0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05.000+0100"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017-01-02T03:04:05.000Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 01 11:22:33"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 01 11:22:33.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 010203 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 010203.000 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 01:2:3 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 01:2:3.000 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:02:3"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:02:3.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 11:22:33"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 11:22:33.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:03"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:03.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:22:33"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:22:33.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:33"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:33.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3 MSK"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3.000 MSK"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3 UTC+0000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3.000 UTC+0000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3.000 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3 UTC+0400"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 02 1:2:3.000 UTC+0400"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 2 1:2:3"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Apr 2 1:2:3.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Jan 02 010203 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2017 Jan 02 010203.000 UTC+0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Apr 2017 01:02:03"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Apr 2017 01:02:03.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Apr 2017 1:2:3"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Apr 2017 1:2:3.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 MSK"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 MSK"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 Z"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 Z +0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 Z +0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 Z+03:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 Z+03:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 Z +03:00 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 Z +03:00 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 Z +0300 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 Z +0300 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 Z+03:00 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 Z+03:00 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 Z +03:30 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 Z +03:30 PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3Z Mon"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000Z Mon"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 Z PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 Z PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3Z PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000Z PM"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3 Z PM +03:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "25 Jan 2017 1:2:3.000 Z PM +03:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 11 Feb 2018 06:40:50 +0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 11 Feb 2018 06:40:50.000 +0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun, 11 Feb 2018 06:40:50 +0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun, 11 Feb 2018 06:40:50.000 +0300"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "200"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "200001"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000010"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20000101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "200001010"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000010101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20000101010"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "200001010101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000010101010"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20000101010101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "200.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20000.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "200001.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000010.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20000101.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "200001010.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000010101.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20000101010.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "200001010101.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000010101010.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "20000101010101.1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar2020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 2020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar012020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 012020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar01012020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 01012020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar0101202001"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 0101202001"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar010120200101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 010120200101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar01012020010101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 01012020010101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar01012020010101.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 0101202001010101.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 1"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun2020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 2020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun012020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 012020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun01012020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 01012020"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun0101202001"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 0101202001"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun010120200101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 010120200101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun01012020010101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 01012020010101"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun01012020010101.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Sun 0101202001010101.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000 01 01 01:00:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000 01 01 01:00:00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000a01a01 01:00:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000a01a01 01:00:00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01-01 01 00 00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01-01 01 00 00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01-01 01-00-00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01-01 01-00-00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01-01 01a00a00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01-01 01a00a00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01 01:00:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01 01:00:00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000 01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000-01"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 2000 00:00:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 2000 00:00:00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000 00:00:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "2000 00:00:00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 2000-01-01 00:00:00"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "Mar 2000-01-01 00:00:00.000"}');

SELECT
    x,
    toTypeName(x)
FROM format(JSONEachRow, '{"x" : "1.7.10"}');