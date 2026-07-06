SELECT IPv4StringToNum('test'); --{serverError CANNOT_PARSE_IPV4}

SELECT IPv4StringToNumOrDefault('test');

SELECT IPv4StringToNumOrNull('test');

SELECT IPv4StringToNum('127.0.0.1');

SELECT IPv4StringToNumOrDefault('127.0.0.1');

SELECT IPv4StringToNumOrNull('127.0.0.1');

SELECT '--';

SELECT toIPv4('test'); --{serverError CANNOT_PARSE_IPV4}

SELECT toIPv4OrDefault('test');

SELECT toIPv4OrNull('test');

SELECT toIPv4('127.0.0.1');

SELECT toIPv4OrDefault('127.0.0.1');

SELECT toIPv4OrNull('127.0.0.1');

SELECT toIPv4(toIPv6('::ffff:1.2.3.4'));

SELECT toIPv4(toIPv6('::afff:1.2.3.4')); --{serverError CANNOT_CONVERT_TYPE}

SELECT toIPv4OrDefault(toIPv6('::ffff:1.2.3.4'));

SELECT toIPv4OrDefault(toIPv6('::afff:1.2.3.4'));

SELECT CAST('test' AS IPv4); --{serverError CANNOT_PARSE_IPV4}

SELECT CAST('127.0.0.1' AS IPv4);

SET cast_ipv4_ipv6_default_on_conversion_error = '1';

SELECT IPv4StringToNum('');

SELECT toIPv4('');

SELECT CAST('' AS IPv4);

SET cast_ipv4_ipv6_default_on_conversion_error = '0';

SELECT IPv6StringToNum('test'); --{serverError CANNOT_PARSE_IPV6}

SELECT IPv6StringToNumOrDefault('test');

SELECT IPv6StringToNumOrNull('test');

SELECT IPv6StringToNum('::ffff:127.0.0.1');

SELECT IPv6StringToNumOrDefault('::ffff:127.0.0.1');

SELECT IPv6StringToNumOrNull('::ffff:127.0.0.1');

SELECT toIPv6('test'); --{serverError CANNOT_PARSE_IPV6}

SELECT toIPv6OrDefault('test');

SELECT toIPv6OrNull('test');

SELECT toIPv6('::ffff:127.0.0.1');

SELECT toIPv6OrDefault('::ffff:127.0.0.1');

SELECT toIPv6OrNull('::ffff:127.0.0.1');

SELECT toIPv6('::.1.2.3'); --{serverError CANNOT_PARSE_IPV6}

SELECT toIPv6OrDefault('::.1.2.3');

SELECT toIPv6OrNull('::.1.2.3');

SELECT count()
FROM numbers_mt(20000000)
WHERE NOT ignore(toIPv6OrZero(randomString(8)));

SELECT CAST('test' AS IPv6); -- { serverError CANNOT_PARSE_IPV6 }

SELECT CAST('::ffff:127.0.0.1' AS IPv6);

SELECT IPv6StringToNum('');

SELECT toIPv6('');

SELECT CAST('' AS IPv6);

SELECT
    toFixedString('::1', 3) AS value,
    CAST(value AS IPv6),
    toIPv6(value);

SELECT
    toFixedString('', 16) AS value,
    CAST(value AS IPv6);

SELECT
    toFixedString('', 16) AS value,
    toIPv6(value);