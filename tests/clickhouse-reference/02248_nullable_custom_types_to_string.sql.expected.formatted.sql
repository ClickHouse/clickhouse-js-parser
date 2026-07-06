SELECT toString(toNullable(true));

SELECT toString(CAST(NULL AS Nullable(Bool)));

SELECT toString(toNullable(toIPv4('0.0.0.0')));

SELECT toString(CAST(NULL AS Nullable(IPv4)));

SELECT toString(toNullable(toIPv6('::ffff:127.0.0.1')));

SELECT toString(CAST(NULL AS Nullable(IPv6)));