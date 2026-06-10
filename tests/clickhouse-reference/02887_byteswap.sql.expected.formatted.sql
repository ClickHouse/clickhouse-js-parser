SELECT byteSwap(CAST('0' AS UInt8));

SELECT byteSwap(CAST('1' AS UInt8));

SELECT byteSwap(CAST('255' AS UInt8));

SELECT byteSwap(CAST('256' AS UInt16));

SELECT byteSwap(CAST('4135' AS UInt16));

SELECT byteSwap(CAST('10000' AS UInt16));

SELECT byteSwap(CAST('65535' AS UInt16));

SELECT byteSwap(CAST('65536' AS UInt32));

SELECT byteSwap(CAST('3351772109' AS UInt32));

SELECT byteSwap(CAST('3455829959' AS UInt32));

SELECT byteSwap(CAST('4294967295' AS UInt32));

SELECT byteSwap(CAST('4294967296' AS UInt64));

SELECT byteSwap(CAST('123294967295' AS UInt64));

SELECT byteSwap(CAST('18439412204227788800' AS UInt64));

SELECT byteSwap(CAST('18446744073709551615' AS UInt64));

SELECT byteSwap(CAST('-0' AS Int8));

SELECT byteSwap(CAST('-1' AS Int8));

SELECT byteSwap(CAST('-128' AS Int8));

SELECT byteSwap(CAST('-129' AS Int16));

SELECT byteSwap(CAST('-4135' AS Int16));

SELECT byteSwap(CAST('-32768' AS Int16));

SELECT byteSwap(CAST('-32769' AS Int32));

SELECT byteSwap(CAST('-3351772109' AS Int32));

SELECT byteSwap(CAST('-2147483648' AS Int32));

SELECT byteSwap(CAST('-2147483649' AS Int64));

SELECT byteSwap(CAST('-1242525266376' AS Int64));

SELECT byteSwap(CAST('-9223372036854775808' AS Int64));

SELECT byteSwap(CAST('18446744073709551616' AS UInt128));

SELECT byteSwap(CAST('-9223372036854775809' AS Int128));

SELECT byteSwap(CAST('340282366920938463463374607431768211456' AS UInt256));

SELECT byteSwap(CAST('-170141183460469231731687303715884105729' AS Int256));

-- Booleans are interpreted as UInt8
SELECT byteSwap(false);

SELECT byteSwap(true);

-- Number of arguments should equal 1
SELECT byteSwap(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT byteSwap(128, 129); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- Input should be integral
SELECT byteSwap('abc'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT byteSwap(toFixedString('abc', 3)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT byteSwap(toDate('2019-01-01')); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT byteSwap(toDate32('2019-01-01')); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT byteSwap(toDateTime32(1546300800)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT byteSwap(toDateTime64(1546300800, 3)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT byteSwap(generateUUIDv4()); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT byteSwap(toDecimal32(2, 4)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT byteSwap(toFloat32(123.456)); -- { serverError NOT_IMPLEMENTED }

SELECT byteSwap(toFloat64(123.456)); -- { serverError NOT_IMPLEMENTED }