-- { echoOn }
-- year
SELECT parseDateTime('2020', '%Y', 'UTC') = toDateTime('2020-01-01', 'UTC');

-- month
SELECT parseDateTime('02', '%m', 'UTC') = toDateTime('2000-02-01', 'UTC');

SELECT parseDateTime('07', '%m', 'UTC') = toDateTime('2000-07-01', 'UTC');

SELECT parseDateTime('11-', '%m-', 'UTC') = toDateTime('2000-11-01', 'UTC');

SELECT parseDateTime('00', '%m'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('13', '%m'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('12345', '%m'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('02', '%c', 'UTC') = toDateTime('2000-02-01', 'UTC');

SELECT parseDateTime('07', '%c', 'UTC') = toDateTime('2000-07-01', 'UTC');

SELECT parseDateTime('11-', '%c-', 'UTC') = toDateTime('2000-11-01', 'UTC');

SELECT parseDateTime('00', '%c'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('13', '%c'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('12345', '%c'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('jun', '%b', 'UTC') = toDateTime('2000-06-01', 'UTC');

SELECT parseDateTime('abc', '%b'); -- { serverError CANNOT_PARSE_DATETIME }

SET formatdatetime_parsedatetime_m_is_month_name = '1';

SELECT parseDateTime('may', '%M', 'UTC') = toDateTime('2000-05-01', 'UTC');

SELECT parseDateTime('september', '%M', 'UTC') = toDateTime('2000-09-01', 'UTC');

SELECT parseDateTime('summer', '%M'); -- { serverError CANNOT_PARSE_DATETIME }

SET formatdatetime_parsedatetime_m_is_month_name = '0';

SELECT parseDateTime('08', '%M', 'UTC') = toDateTime('1970-01-01 00:08:00', 'UTC');

SELECT parseDateTime('59', '%M', 'UTC') = toDateTime('1970-01-01 00:59:00', 'UTC');

SELECT parseDateTime('00/', '%M/', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('60', '%M', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('-1', '%M', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('123456789', '%M', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

-- day of month
SELECT parseDateTime('07', '%d', 'UTC') = toDateTime('2000-01-07', 'UTC');

SELECT parseDateTime('01', '%d', 'UTC') = toDateTime('2000-01-01', 'UTC');

SELECT parseDateTime('/11', '/%d', 'UTC') = toDateTime('2000-01-11', 'UTC');

SELECT parseDateTime('00', '%d'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('32', '%d'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('12345', '%d'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('02-31', '%m-%d'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('04-31', '%m-%d'); -- { serverError CANNOT_PARSE_DATETIME }

-- The last one is chosen if multiple months of year if supplied
SELECT parseDateTime('01 31 20 02', '%m %d %d %m', 'UTC') = toDateTime('2000-02-20', 'UTC');

SELECT parseDateTime('02 31 20 04', '%m %d %d %m', 'UTC') = toDateTime('2000-04-20', 'UTC');

SELECT parseDateTime('02 31 01', '%m %d %m', 'UTC') = toDateTime('2000-01-31', 'UTC');

SELECT parseDateTime('2000-02-29', '%Y-%m-%d', 'UTC') = toDateTime('2000-02-29', 'UTC');

SELECT parseDateTime('2001-02-29', '%Y-%m-%d'); -- { serverError CANNOT_PARSE_DATETIME }

-- day of year
SELECT parseDateTime('001', '%j', 'UTC') = toDateTime('2000-01-01', 'UTC');

SELECT parseDateTime('007', '%j', 'UTC') = toDateTime('2000-01-07', 'UTC');

SELECT parseDateTime('/031/', '/%j/', 'UTC') = toDateTime('2000-01-31', 'UTC');

SELECT parseDateTime('032', '%j', 'UTC') = toDateTime('2000-02-01', 'UTC');

SELECT parseDateTime('060', '%j', 'UTC') = toDateTime('2000-02-29', 'UTC');

SELECT parseDateTime('365', '%j', 'UTC') = toDateTime('2000-12-30', 'UTC');

SELECT parseDateTime('366', '%j', 'UTC') = toDateTime('2000-12-31', 'UTC');

SELECT parseDateTime('1980 001', '%Y %j', 'UTC') = toDateTime('1980-01-01', 'UTC');

SELECT parseDateTime('1980 007', '%Y %j', 'UTC') = toDateTime('1980-01-07', 'UTC');

SELECT parseDateTime('1980 /007', '%Y /%j', 'UTC') = toDateTime('1980-01-07', 'UTC');

SELECT parseDateTime('1980 /031/', '%Y /%j/', 'UTC') = toDateTime('1980-01-31', 'UTC');

SELECT parseDateTime('1980 032', '%Y %j', 'UTC') = toDateTime('1980-02-01', 'UTC');

SELECT parseDateTime('1980 060', '%Y %j', 'UTC') = toDateTime('1980-02-29', 'UTC');

SELECT parseDateTime('1980 366', '%Y %j', 'UTC') = toDateTime('1980-12-31', 'UTC');

SELECT parseDateTime('1981 366', '%Y %j'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('367', '%j'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('000', '%j'); -- { serverError CANNOT_PARSE_DATETIME }

-- The last one is chosen if multiple day of years are supplied.
SELECT parseDateTime('2000 366 2001', '%Y %j %Y'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('2001 366 2000', '%Y %j %Y', 'UTC') = toDateTime('2000-12-31', 'UTC');

-- hour of day
SELECT parseDateTime('07', '%H', 'UTC') = toDateTime('1970-01-01 07:00:00', 'UTC');

SELECT parseDateTime('23', '%H', 'UTC') = toDateTime('1970-01-01 23:00:00', 'UTC');

SELECT parseDateTime('00', '%H', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('10', '%H', 'UTC') = toDateTime('1970-01-01 10:00:00', 'UTC');

SELECT parseDateTime('24', '%H', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('-1', '%H', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('1234567', '%H', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('07', '%k', 'UTC') = toDateTime('1970-01-01 07:00:00', 'UTC');

SELECT parseDateTime('23', '%k', 'UTC') = toDateTime('1970-01-01 23:00:00', 'UTC');

SELECT parseDateTime('00', '%k', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('10', '%k', 'UTC') = toDateTime('1970-01-01 10:00:00', 'UTC');

SELECT parseDateTime('24', '%k', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('-1', '%k', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('1234567', '%k', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('12', '%h', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('01', '%h', 'UTC') = toDateTime('1970-01-01 01:00:00', 'UTC');

SELECT parseDateTime('00', '%h', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('13', '%h', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('123456789', '%h', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('07', '%I', 'UTC') = toDateTime('1970-01-01 07:00:00', 'UTC');

SELECT parseDateTime('12', '%I', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('01', '%I', 'UTC') = toDateTime('1970-01-01 01:00:00', 'UTC');

SELECT parseDateTime('10', '%I', 'UTC') = toDateTime('1970-01-01 10:00:00', 'UTC');

SELECT parseDateTime('00', '%I', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('13', '%I', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('123456789', '%I', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('07', '%l', 'UTC') = toDateTime('1970-01-01 07:00:00', 'UTC');

SELECT parseDateTime('12', '%l', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('01', '%l', 'UTC') = toDateTime('1970-01-01 01:00:00', 'UTC');

SELECT parseDateTime('10', '%l', 'UTC') = toDateTime('1970-01-01 10:00:00', 'UTC');

SELECT parseDateTime('00', '%l', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('13', '%l', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('123456789', '%l', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

-- half of day
SELECT parseDateTime('07 PM', '%H %p', 'UTC') = toDateTime('1970-01-01 07:00:00', 'UTC');

SELECT parseDateTime('07 AM', '%H %p', 'UTC') = toDateTime('1970-01-01 07:00:00', 'UTC');

SELECT parseDateTime('00 AM', '%H %p', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('00 PM', '%H %p', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('01 PM', '%h %p', 'UTC') = toDateTime('1970-01-01 13:00:00', 'UTC');

SELECT parseDateTime('01 AM', '%h %p', 'UTC') = toDateTime('1970-01-01 01:00:00', 'UTC');

SELECT parseDateTime('06 PM', '%h %p', 'UTC') = toDateTime('1970-01-01 18:00:00', 'UTC');

SELECT parseDateTime('06 AM', '%h %p', 'UTC') = toDateTime('1970-01-01 06:00:00', 'UTC');

SELECT parseDateTime('12 PM', '%h %p', 'UTC') = toDateTime('1970-01-01 12:00:00', 'UTC');

SELECT parseDateTime('12 AM', '%h %p', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

-- minute
SELECT parseDateTime('08', '%i', 'UTC') = toDateTime('1970-01-01 00:08:00', 'UTC');

SELECT parseDateTime('59', '%i', 'UTC') = toDateTime('1970-01-01 00:59:00', 'UTC');

SELECT parseDateTime('00/', '%i/', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('60', '%i', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('-1', '%i', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

-- second
SELECT parseDateTime('09', '%s', 'UTC') = toDateTime('1970-01-01 00:00:09', 'UTC');

SELECT parseDateTime('58', '%s', 'UTC') = toDateTime('1970-01-01 00:00:58', 'UTC');

SELECT parseDateTime('00/', '%s/', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('60', '%s', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('-1', '%s', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('123456789', '%s', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

-- microsecond
SELECT parseDateTime('000000', '%f', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('456789', '%f', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTime('42', '%f', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC'); -- { serverError NOT_ENOUGH_SPACE }

SELECT parseDateTime('12ABCD', '%f', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

-- mixed YMD format
SELECT parseDateTime('2021-01-04+23:00:00.654321', '%Y-%m-%d+%H:%i:%s.%f', 'UTC') = toDateTime('2021-01-04 23:00:00', 'UTC');

SELECT parseDateTime('2019-07-03 11:04:10.975319', '%Y-%m-%d %H:%i:%s.%f', 'UTC') = toDateTime('2019-07-03 11:04:10', 'UTC');

SELECT parseDateTime('10:04:11 03-07-2019.242424', '%s:%i:%H %d-%m-%Y.%f', 'UTC') = toDateTime('2019-07-03 11:04:10', 'UTC');

-- *OrZero, *OrNull, str_to_date
SELECT parseDateTimeOrZero('10:04:11 03-07-2019', '%s:%i:%H %d-%m-%Y', 'UTC') = toDateTime('2019-07-03 11:04:10', 'UTC');

SELECT parseDateTimeOrZero('10:04:11 invalid 03-07-2019', '%s:%i:%H %d-%m-%Y', 'UTC') = toDateTime('1970-01-01 00:00:00', 'UTC');

SELECT parseDateTimeOrNull('10:04:11 03-07-2019', '%s:%i:%H %d-%m-%Y', 'UTC') = toDateTime('2019-07-03 11:04:10', 'UTC');

SELECT parseDateTimeOrNull('10:04:11 invalid 03-07-2019', '%s:%i:%H %d-%m-%Y', 'UTC') IS NULL;

SELECT str_to_date('10:04:11 03-07-2019', '%s:%i:%H %d-%m-%Y', 'UTC') = toDateTime('2019-07-03 11:04:10', 'UTC');

SELECT str_to_date('10:04:11 invalid 03-07-2019', '%s:%i:%H %d-%m-%Y', 'UTC') IS NULL;

-- Error handling
SELECT parseDateTime(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT parseDateTime('12 AM', '%h %p', 'UTC', 'a fourth argument'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- Fuzzer crash bug #53715
SELECT parseDateTime('', '', toString(number))
FROM numbers(13); -- { serverError ILLEGAL_COLUMN }

-- %h
SELECT parseDateTime('Aug 13, 2022, 7:58:32 PM', '%b %e, %G, %h:%i:%s %p', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('Aug 13, 2022, 07:58:32 PM', '%b %e, %G, %h:%i:%s %p', 'UTC');

-- %l accepts single or double digits inputs
SELECT parseDateTime('Aug 13, 2022, 7:58:32 PM', '%b %e, %G, %l:%i:%s %p', 'UTC');

SELECT parseDateTime('Aug 13, 2022, 07:58:32 PM', '%b %e, %G, %l:%i:%s %p', 'UTC');

-- %H
SELECT parseDateTime('Aug 13, 2022, 7:58:32', '%b %e, %G, %H:%i:%s', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('Aug 13, 2022, 07:58:32', '%b %e, %G, %H:%i:%s', 'UTC');

-- %k accepts single or double digits inputs
SELECT parseDateTime('Aug 13, 2022, 7:58:32', '%b %e, %G, %k:%i:%s', 'UTC');

SELECT parseDateTime('Aug 13, 2022, 07:58:32', '%b %e, %G, %k:%i:%s', 'UTC');

-- %m
SELECT parseDateTime('8 13, 2022, 7:58:32', '%m %e, %G, %k:%i:%s', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('08 13, 2022, 07:58:32', '%m %e, %G, %k:%i:%s', 'UTC');

-- %c accepts single or double digits inputs
SELECT parseDateTime('8 13, 2022, 7:58:32', '%c %e, %G, %k:%i:%s', 'UTC');

SELECT parseDateTime('08 13, 2022, 07:58:32', '%c %e, %G, %k:%i:%s', 'UTC');

-- The format string argument is optional
SET session_timezone = 'UTC'; -- don't randomize the session timezone

SELECT parseDateTime('2021-01-04 23:12:34') = toDateTime('2021-01-04 23:12:34');

SELECT parseDateTime(''); -- { serverError NOT_ENOUGH_SPACE }

-- Test setting 'parsedatetime_e_requires_space_padding'
--     In the default behavior, leading spaces for %e are optional
SELECT parseDateTime('  1/12/2024', '%e/%m/%Y')
SETTINGS parsedatetime_e_requires_space_padding = '0';

SELECT parseDateTime('1/12/2024', '%e/%m/%Y')
SETTINGS parsedatetime_e_requires_space_padding = '0';

--     If we enable the legacy behavior, leading spaces for %e are mandatory
SELECT parseDateTime('  1/12/2024', '%e/%m/%Y')
SETTINGS parsedatetime_e_requires_space_padding = '1'; -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime('1/12/2024', '%e/%m/%Y')
SETTINGS parsedatetime_e_requires_space_padding = '1'; -- { serverError CANNOT_PARSE_DATETIME }

-- -------------------------------------------------------------------------------------------------------------------------
-- Tests for parseDateTime64, these are not systematic
SELECT parseDateTime64(''); -- { serverError NOT_ENOUGH_SPACE }

SELECT parseDateTime64('2021-01-04 23:12:34.118'); -- { serverError NOT_ENOUGH_SPACE }

SELECT parseDateTime64('2177-10-09 10:30:10.123'); -- { serverError NOT_ENOUGH_SPACE }

SELECT parseDateTime64('2021-01-04 23:12:34.118112') = toDateTime64('2021-01-04 23:12:34.118112', 6);

SELECT parseDateTime64('2021-01-04 23:12:34.118112', '%Y-%m-%d %H:%i:%s.%f') = toDateTime64('2021-01-04 23:12:34.118112', 6);

SELECT parseDateTime64('2021-01-04 23:12:34.118', '%Y-%m-%d %H:%i:%s.%f'); -- { serverError NOT_ENOUGH_SPACE }

SELECT parseDateTime64('2021-01-04 23:12:34.11811235', '%Y-%m-%d %H:%i:%s.%f'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime64('2021-01-04 23:12:34.118112', '%Y-%m-%d %H:%i:%s'); -- { serverError CANNOT_PARSE_DATETIME }

-- leap vs non-leap years
SELECT parseDateTime64('2024-02-29 11:23:34.123433', '%Y-%m-%d %H:%i:%s.%f') = toDateTime64('2024-02-29 11:23:34.123433', 6);

SELECT parseDateTime64('2023-02-29 11:22:33.123433', '%Y-%m-%d %H:%i:%s.%f'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime64('2024-02-28 23:22:33.123433', '%Y-%m-%d %H:%i:%s.%f') = toDateTime64('2024-02-28 23:22:33.123433', 6);

SELECT parseDateTime64('2023-02-28 23:22:33.123433', '%Y-%m-%d %H:%i:%s.%f') = toDateTime64('2023-02-28 23:22:33.123433', 6);

-- parseDateTime64OrNull
SELECT parseDateTime64OrNull('2021-01-04 23:12:34.118') IS NULL;

SELECT parseDateTime64OrNull('2021-01-04 23:12:34.118', '%Y-%m-%d %H:%i:%s.%f') IS NULL;

SELECT parseDateTime64OrNull('2021-01-04 23:12:34.118112', '%Y-%m-%d %H:%i:%s') IS NULL;

SELECT parseDateTime64OrNull('2021-01-04 23:12:34.11811235', '%Y-%m-%d %H:%i:%s.%f') IS NULL;

-- parseDateTime64OrZero
SELECT parseDateTime64OrZero('2021-01-04 23:12:34.118') = toDateTime64('1970-01-01 00:00:00', 6);

SELECT parseDateTime64OrZero('2021-01-04 23:12:34.118', '%Y-%m-%d %H:%i:%s.%f') = toDateTime64('1970-01-01 00:00:00', 6);

SELECT parseDateTime64OrZero('2021-01-04 23:12:34.118112', '%Y-%m-%d %H:%i:%s') = toDateTime64('1970-01-01 00:00:00', 6);

SELECT parseDateTime64OrZero('2021-01-04 23:12:34.11811235', '%Y-%m-%d %H:%i:%s.%f') = toDateTime64('1970-01-01 00:00:00', 6);

-- Test parseDataTime64 supports range between 1900 - 2299
SELECT parseDateTime64('1899-12-31 23:59:59', '%Y-%m-%d %H:%i:%s'); -- { serverError CANNOT_PARSE_DATETIME }

SELECT parseDateTime64('1900-01-01 00:00:00', '%Y-%m-%d %H:%i:%s') = toDateTime64('1900-01-01 00:00:00', 0);

SELECT parseDateTime64('1920-06-06 00:00:01', '%Y-%m-%d %H:%i:%s') = toDateTime64('1920-06-06 00:00:01', 0);

SELECT parseDateTime64('1970-01-01 00:00:00', '%Y-%m-%d %H:%i:%s') = toDateTime64('1970-01-01 00:00:00', 0);

SELECT parseDateTime64('1971-02-03 04:05:06', '%Y-%m-%d %H:%i:%s') = toDateTime64('1971-02-03 04:05:06', 0);

SELECT parseDateTime64('2105-02-03 04:05:06', '%Y-%m-%d %H:%i:%s') = toDateTime64('2105-02-03 04:05:06', 0);

SELECT parseDateTime64('2106-02-07 06:28:15', '%Y-%m-%d %H:%i:%s') = toDateTime64('2106-02-07 06:28:15', 0);

SELECT parseDateTime64('2106-02-08 06:28:15', '%Y-%m-%d %H:%i:%s') = toDateTime64('2106-02-08 06:28:15', 0);

SELECT parseDateTime64('2299-12-31 23:59:59', '%Y-%m-%d %H:%i:%s') = toDateTime64('2299-12-31 23:59:59', 0);

SELECT parseDateTime64('2300-01-01 00:00:00', '%Y-%m-%d %H:%i:%s'); -- { serverError CANNOT_PARSE_DATETIME }
-- -------------------------------------------------------------------------------------------------------------------------
-- { echoOff }