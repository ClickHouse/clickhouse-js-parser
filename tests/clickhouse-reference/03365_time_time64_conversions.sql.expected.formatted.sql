-- echoOn
SET session_timezone = 'UTC';

SET allow_experimental_time_time64_type = '1';

SET use_legacy_to_time = '0';

-- Conversion from Time to String 
SELECT toTime(0)::String;

SELECT toTime(12)::String;

SELECT toTime(3600)::String;

-- Conversion from numeric to Time
-- Int, using toTime
SELECT toTime(0);

SELECT toTime(12);

SELECT toTime(3600);

SELECT toTime(360000);

SELECT toTime(-12);

SELECT toTime(-3600);

SELECT toTime(-360000);

SELECT toTime(999999999);

-- Float, using toTime
SELECT toTime(0.1);

SELECT toTime(12.1);

SELECT toTime(3600.1);

SELECT toTime(360000.1);

SELECT toTime(-12.1);

SELECT toTime(-3600.1);

SELECT toTime(-360000.1);

SELECT toTime(999999999.1);

-- UInt16
SELECT CAST('0' AS UInt16)::Time;

SELECT CAST('12' AS UInt16)::Time;

SELECT CAST('3600' AS UInt16)::Time;

-- UInt32
SELECT CAST('0' AS UInt32)::Time;

SELECT CAST('12' AS UInt32)::Time;

SELECT CAST('3600' AS UInt32)::Time;

SELECT CAST('360000' AS UInt32)::Time;

-- UInt64
SELECT CAST('0' AS UInt64)::Time;

SELECT CAST('12' AS UInt64)::Time;

SELECT CAST('3600' AS UInt64)::Time;

SELECT CAST('360000' AS UInt64)::Time;

SELECT CAST('999999999' AS UInt64)::Time;

-- UInt128
SELECT CAST('0' AS UInt128)::Time;

SELECT CAST('12' AS UInt128)::Time;

SELECT CAST('3600' AS UInt128)::Time;

SELECT CAST('360000' AS UInt128)::Time;

SELECT CAST('999999999' AS UInt128)::Time;

-- UInt256
SELECT CAST('0' AS UInt256)::Time;

SELECT CAST('12' AS UInt256)::Time;

SELECT CAST('3600' AS UInt256)::Time;

SELECT CAST('360000' AS UInt256)::Time;

SELECT CAST('999999999' AS UInt256)::Time;

-- Int16
SELECT CAST('0' AS Int16)::Time;

SELECT CAST('12' AS Int16)::Time;

SELECT CAST('3600' AS Int16)::Time;

SELECT CAST('-0' AS Int16)::Time;

SELECT CAST('-12' AS Int16)::Time;

SELECT CAST('-3600' AS Int16)::Time;

-- Int32
SELECT CAST('0' AS Int32)::Time;

SELECT CAST('12' AS Int32)::Time;

SELECT CAST('3600' AS Int32)::Time;

SELECT CAST('360000' AS Int32)::Time;

SELECT CAST('-0' AS Int32)::Time;

SELECT CAST('-12' AS Int32)::Time;

SELECT CAST('-3600' AS Int32)::Time;

SELECT CAST('-360000' AS Int32)::Time;

-- Int64
SELECT CAST('0' AS Int64)::Time;

SELECT CAST('12' AS Int64)::Time;

SELECT CAST('3600' AS Int64)::Time;

SELECT CAST('360000' AS Int64)::Time;

SELECT CAST('999999999' AS Int64)::Time;

SELECT CAST('-0' AS Int64)::Time;

SELECT CAST('-12' AS Int64)::Time;

SELECT CAST('-3600' AS Int64)::Time;

SELECT CAST('-360000' AS Int64)::Time;

-- Int128
SELECT CAST('0' AS Int128)::Time;

SELECT CAST('12' AS Int128)::Time;

SELECT CAST('3600' AS Int128)::Time;

SELECT CAST('360000' AS Int128)::Time;

SELECT CAST('999999999' AS Int128)::Time;

SELECT CAST('-0' AS Int128)::Time;

SELECT CAST('-12' AS Int128)::Time;

SELECT CAST('-3600' AS Int128)::Time;

SELECT CAST('-360000' AS Int128)::Time;

-- Int256
SELECT CAST('0' AS Int256)::Time;

SELECT CAST('12' AS Int256)::Time;

SELECT CAST('3600' AS Int256)::Time;

SELECT CAST('360000' AS Int256)::Time;

SELECT CAST('999999999' AS Int256)::Time;

SELECT CAST('-0' AS Int256)::Time;

SELECT CAST('-12' AS Int256)::Time;

SELECT CAST('-3600' AS Int256)::Time;

SELECT CAST('-360000' AS Int256)::Time;

-- Float32
SELECT CAST('0' AS Float32)::Time;

SELECT CAST('12' AS Float32)::Time;

SELECT CAST('3600' AS Float32)::Time;

SELECT CAST('360000' AS Float32)::Time;

SELECT CAST('-0' AS Float32)::Time;

SELECT CAST('-12' AS Float32)::Time;

SELECT CAST('-3600' AS Float32)::Time;

SELECT CAST('-360000' AS Float32)::Time;

-- Float64
SELECT CAST('0' AS Float64)::Time;

SELECT CAST('12' AS Float64)::Time;

SELECT CAST('3600' AS Float64)::Time;

SELECT CAST('360000' AS Float64)::Time;

SELECT CAST('-0' AS Float64)::Time;

SELECT CAST('-12' AS Float64)::Time;

SELECT CAST('-3600' AS Float64)::Time;

SELECT CAST('-360000' AS Float64)::Time;

-- Conversion from numeric to Time64
-- Int, using toTime64
SELECT toTime64(0, 0);

SELECT toTime64(12, 0);

SELECT toTime64(3600, 0);

SELECT toTime64(360000, 0);

SELECT toTime64(-12, 0);

SELECT toTime64(-3600, 0);

SELECT toTime64(-360000, 0);

-- Float, using toTime64
SELECT toTime64(0.1, 2);

SELECT toTime64(12.1, 2);

SELECT toTime64(3600.1, 2);

SELECT toTime64(360000.1, 2);

SELECT toTime64(-12.1, 2);

SELECT toTime64(-3600.1, 2);

SELECT toTime64(-360000.1, 2);

-- UInt16
SELECT CAST('0' AS UInt16)::Time64;

SELECT CAST('12' AS UInt16)::Time64;

SELECT CAST('3600' AS UInt16)::Time64;

-- UInt32
SELECT CAST('0' AS UInt32)::Time64;

SELECT CAST('12' AS UInt32)::Time64;

SELECT CAST('3600' AS UInt32)::Time64;

SELECT CAST('360000' AS UInt32)::Time64;

-- UInt64
SELECT CAST('0' AS UInt64)::Time64;

SELECT CAST('12' AS UInt64)::Time64;

SELECT CAST('3600' AS UInt64)::Time64;

SELECT CAST('360000' AS UInt64)::Time64;

-- Int16
SELECT CAST('0' AS Int16)::Time64;

SELECT CAST('12' AS Int16)::Time64;

SELECT CAST('3600' AS Int16)::Time64;

SELECT CAST('-0' AS Int16)::Time64;

SELECT CAST('-12' AS Int16)::Time64;

SELECT CAST('-3600' AS Int16)::Time64;

-- Int32
SELECT CAST('0' AS Int32)::Time64;

SELECT CAST('12' AS Int32)::Time64;

SELECT CAST('3600' AS Int32)::Time64;

SELECT CAST('360000' AS Int32)::Time64;

SELECT CAST('-0' AS Int32)::Time64;

SELECT CAST('-12' AS Int32)::Time64;

SELECT CAST('-3600' AS Int32)::Time64;

SELECT CAST('-360000' AS Int32)::Time64;

-- Int64
SELECT CAST('0' AS Int64)::Time64;

SELECT CAST('12' AS Int64)::Time64;

SELECT CAST('3600' AS Int64)::Time64;

SELECT CAST('360000' AS Int64)::Time64;

SELECT CAST('999999999' AS Int64)::Time64;

SELECT CAST('-0' AS Int64)::Time64;

SELECT CAST('-12' AS Int64)::Time64;

SELECT CAST('-3600' AS Int64)::Time64;

SELECT CAST('-360000' AS Int64)::Time64;

-- Float32
SELECT CAST('0' AS Float32)::Time64;

SELECT CAST('12' AS Float32)::Time64;

SELECT CAST('3600' AS Float32)::Time64;

SELECT CAST('360000' AS Float32)::Time64;

SELECT CAST('-0' AS Float32)::Time64;

SELECT CAST('-12' AS Float32)::Time64;

SELECT CAST('-3600' AS Float32)::Time64;

SELECT CAST('-360000' AS Float32)::Time64;

-- Float64
SELECT CAST('0' AS Float64)::Time64;

SELECT CAST('12' AS Float64)::Time64;

SELECT CAST('3600' AS Float64)::Time64;

SELECT CAST('360000' AS Float64)::Time64;

SELECT CAST('-0' AS Float64)::Time64;

SELECT CAST('-12' AS Float64)::Time64;

SELECT CAST('-3600' AS Float64)::Time64;

SELECT CAST('-360000' AS Float64)::Time64;

-- Conversion from DateTime to Time
SELECT toTime(toDateTime('2022-01-01 12:12:12'));

SELECT toTime(toDateTime('1970-01-01 12:12:12'));

SELECT toTime(toDateTime('2022-01-01 23:99:12'));

SELECT toTime(toDateTime('1970-01-01 23:99:12'));

SELECT toTime(toDateTime('2022-01-01 00:99:12'));

SELECT toTime(toDateTime('1970-01-01 00:99:12'));

-- Conversion from Time to DateTime
SELECT toDateTime(toTime('12:12:12'));

SELECT toDateTime(toTime('23:99:12'));

SELECT toDateTime(toTime('00:99:12'));

SELECT toDateTime(toTime('100:99:12'));

SELECT toDateTime(toTime('999:59:12'));

-- Conversion from DateTime64 to Time
SELECT toTime(toDateTime64('2022-01-01 12:12:12.123', 2));

SELECT toTime(toDateTime64('1970-01-01 12:12:12.123', 2));

SELECT toTime(toDateTime64('2022-01-01 23:99:12.123', 2));

SELECT toTime(toDateTime64('1970-01-01 23:99:12.123', 2));

SELECT toTime(toDateTime64('2022-01-01 00:99:12.123', 2));

SELECT toTime(toDateTime64('1970-01-01 00:99:12.123', 2));

-- Conversion from DateTime to Time64
SELECT toTime64(toDateTime('2022-01-01 12:12:12'), 2);

SELECT toTime64(toDateTime('1970-01-01 12:12:12'), 2);

SELECT toTime64(toDateTime('2022-01-01 23:99:12'), 2);

SELECT toTime64(toDateTime('1970-01-01 23:99:12'), 2);

SELECT toTime64(toDateTime('2022-01-01 00:99:12'), 2);

SELECT toTime64(toDateTime('1970-01-01 00:99:12'), 2);

-- Conversion from Time64 to DateTime64
SELECT toDateTime64(toTime64('12:12:12', 2), 2);

SELECT toDateTime64(toTime64('23:99:12', 2), 2);

SELECT toDateTime64(toTime64('00:99:12', 2), 2);

SELECT toDateTime64(toTime64('100:99:12', 2), 2);

SELECT toDateTime64(toTime64('999:59:12', 2), 2);

-- Conversion from DateTime64 to Time64
SELECT toTime64(toDateTime64('2022-01-01 12:12:12', 2), 2);

SELECT toTime64(toDateTime64('1970-01-01 12:12:12', 2), 2);

SELECT toTime64(toDateTime64('2022-01-01 23:99:12', 2), 2);

SELECT toTime64(toDateTime64('1970-01-01 23:99:12', 2), 2);

SELECT toTime64(toDateTime64('2022-01-01 00:99:12', 2), 2);

SELECT toTime64(toDateTime64('1970-01-01 00:99:12', 2), 2);

-- Conversion from Date to Time
SELECT toTime(toDate('2022-01-01'));

SELECT toTime(toDate('1970-01-01'));

-- Conversion from Date to Time64
SELECT toTime64(toDate('2022-01-01'), 2);

SELECT toTime64(toDate('1970-01-01'), 2);

-- Conversion from Time to Date
SELECT toDate(toTime('00:99:12'));

SELECT toDate(toTime('23:99:12'));

SELECT toDate(toTime('999:99:99'));

-- Conversion from Time to Date32
SELECT toDate32(toTime('00:99:12'));

SELECT toDate32(toTime('23:99:12'));

SELECT toDate32(toTime('999:99:99'));

-- Conversion from Time64 to Date32 (result is always zero)
SELECT toDate32(toTime64('00:99:12', 2));

SELECT toDate32(toTime64('23:99:12', 2));

SELECT toDate32(toTime64('999:99:99', 2));

-- Conversion from Time64 to Date (result is always zero)
SELECT toDate(toTime64('00:99:12', 2));

SELECT toDate(toTime64('23:99:12', 2));

SELECT toDate(toTime64('999:99:99', 2));