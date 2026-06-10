SELECT CAST(CAST(NULL AS Nullable(String)) AS Nullable(Bool));

SELECT CAST(CAST(NULL AS Nullable(String)) AS Nullable(IPv4));

SELECT CAST(CAST(NULL AS Nullable(String)) AS Nullable(IPv6));

SELECT toBool(CAST(NULL AS Nullable(String)));

SELECT toIPv4(CAST(NULL AS Nullable(String)));

SELECT IPv4StringToNum(CAST(NULL AS Nullable(String)));

SELECT toIPv6(CAST(NULL AS Nullable(String)));

SELECT IPv6StringToNum(CAST(NULL AS Nullable(String)));

SELECT CAST(number % 2 ? 'true' : NULL AS Nullable(Bool))
FROM numbers(2);

SELECT CAST(number % 2 ? '0.0.0.0' : NULL AS Nullable(IPv4))
FROM numbers(2);

SELECT CAST(number % 2 ? '0000:0000:0000:0000:0000:0000:0000:0000' : NULL AS Nullable(IPv6))
FROM numbers(2);

SET cast_keep_nullable = '1';

SELECT toBool(number % 2 ? 'true' : NULL)
FROM numbers(2);

SELECT toIPv4(number % 2 ? '0.0.0.0' : NULL)
FROM numbers(2);

SELECT toIPv4OrDefault(number % 2 ? '' : NULL)
FROM numbers(2);

SELECT toIPv4OrNull(number % 2 ? '' : NULL)
FROM numbers(2);

SELECT IPv4StringToNum(number % 2 ? '0.0.0.0' : NULL)
FROM numbers(2);

SELECT toIPv6(number % 2 ? '0000:0000:0000:0000:0000:0000:0000:0000' : NULL)
FROM numbers(2);

SELECT toIPv6OrDefault(number % 2 ? '' : NULL)
FROM numbers(2);

SELECT toIPv6OrNull(number % 2 ? '' : NULL)
FROM numbers(2);

SELECT IPv6StringToNum(number % 2 ? '0000:0000:0000:0000:0000:0000:0000:0000' : NULL)
FROM numbers(2);

SELECT CAST(if(number % 2, 'truetrue', NULL) AS Nullable(Bool))
FROM numbers(2); -- {serverError CANNOT_PARSE_BOOL}

SELECT CAST(if(number % 2, 'falsefalse', NULL) AS Nullable(Bool))
FROM numbers(2); -- {serverError CANNOT_PARSE_BOOL}

SELECT accurateCastOrNull(if(number % 2, NULL, 'truex'), 'Bool')
FROM numbers(4);

SELECT accurateCastOrNull(if(number % 2, 'truex', NULL), 'Bool')
FROM numbers(4);