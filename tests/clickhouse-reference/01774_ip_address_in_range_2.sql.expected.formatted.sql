SELECT isIPAddressInRange(CAST('127.0.0.1' AS Nullable(String)), '127.0.0.0/8');

SELECT isIPAddressInRange(CAST('128.0.0.1' AS Nullable(String)), '127.0.0.0/8');

SELECT isIPAddressInRange(CAST('ffff::1' AS Nullable(String)), 'ffff::/16');

SELECT isIPAddressInRange(CAST('fffe::1' AS Nullable(String)), 'ffff::/16');

SELECT isIPAddressInRange(toIPv4('127.0.0.1'), '127.0.0.0/8');

SELECT isIPAddressInRange(toIPv4('128.0.0.1'), '127.0.0.0/8');

SELECT isIPAddressInRange(toIPv6('ffff::1'), 'ffff::/16');

SELECT isIPAddressInRange(toIPv6('fffe::1'), 'ffff::/16');

SELECT isIPAddressInRange(CAST(toIPv4('127.0.0.1') AS Nullable(IPv4)), '127.0.0.0/8');

SELECT isIPAddressInRange(CAST(toIPv4('128.0.0.1') AS Nullable(IPv4)), '127.0.0.0/8');

SELECT isIPAddressInRange(CAST(toIPv6('ffff::1') AS Nullable(IPv6)), 'ffff::/16');

SELECT isIPAddressInRange(CAST(toIPv6('fffe::1') AS Nullable(IPv6)), 'ffff::/16');

WITH arrayJoin([NULL, CAST('192.168.99.255' AS Nullable(String)), CAST('192.168.100.1' AS Nullable(String)), CAST('192.168.103.255' AS Nullable(String)), CAST('192.168.104.0' AS Nullable(String))]) AS addr,

'192.168.100.0/22' AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([toIPv4('192.168.99.255'), toIPv4('192.168.100.1'), toIPv4('192.168.103.255'), toIPv4('192.168.104.0')]) AS addr,

'192.168.100.0/22' AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([NULL, CAST(toIPv4('192.168.99.255') AS Nullable(IPv4)), CAST(toIPv4('192.168.100.1') AS Nullable(IPv4)), CAST(toIPv4('192.168.103.255') AS Nullable(IPv4)), CAST(toIPv4('192.168.104.0') AS Nullable(IPv4))]) AS addr,

'192.168.100.0/22' AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([toIPv6('::192.168.99.255'), toIPv6('::192.168.100.1'), toIPv6('::192.168.103.255'), toIPv6('::192.168.104.0')]) AS addr,

'::192.168.100.0/118' AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([NULL, CAST(toIPv6('::192.168.99.255') AS Nullable(IPv6)), CAST(toIPv6('::192.168.100.1') AS Nullable(IPv6)), CAST(toIPv6('::192.168.103.255') AS Nullable(IPv6)), CAST(toIPv6('::192.168.104.0') AS Nullable(IPv6))]) AS addr,

'::192.168.100.0/118' AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH CAST('192.168.100.1' AS Nullable(String)) AS addr,

arrayJoin(['192.168.100.0/22', '192.168.100.0/24', '192.168.100.0/32']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH CAST('::192.168.100.1' AS Nullable(String)) AS addr,

arrayJoin(['::192.168.100.0/118', '::192.168.100.0/120', '::192.168.100.0/128']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH CAST(NULL AS Nullable(String)) AS addr,

arrayJoin(['::192.168.100.0/118', '::192.168.100.0/120', '::192.168.100.0/128']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH toIPv4('192.168.100.1') AS addr,

arrayJoin(['192.168.100.0/22', '192.168.100.0/24', '192.168.100.0/32']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH toIPv6('::192.168.100.1') AS addr,

arrayJoin(['::192.168.100.0/118', '::192.168.100.0/120', '::192.168.100.0/128']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH CAST(toIPv4('192.168.100.1') AS Nullable(IPv4)) AS addr,

arrayJoin(['192.168.100.0/22', '192.168.100.0/24', '192.168.100.0/32']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH CAST(NULL AS Nullable(IPv4)) AS addr,

arrayJoin(['192.168.100.0/22', '192.168.100.0/24', '192.168.100.0/32']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH CAST(toIPv6('::192.168.100.1') AS Nullable(IPv6)) AS addr,

arrayJoin(['::192.168.100.0/118', '::192.168.100.0/120', '::192.168.100.0/128']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH CAST(NULL AS Nullable(IPv6)) AS addr,

arrayJoin(['::192.168.100.0/118', '::192.168.100.0/120', '::192.168.100.0/128']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([CAST('192.168.100.1' AS Nullable(String)), CAST('192.168.103.255' AS Nullable(String))]) AS addr,

arrayJoin(['192.168.100.0/22', '192.168.100.0/24']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([CAST('::192.168.100.1' AS Nullable(String)), CAST('::192.168.103.255' AS Nullable(String))]) AS addr,

arrayJoin(['::192.168.100.0/118', '::192.168.100.0/120']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([toIPv4('192.168.100.1'), toIPv4('192.168.103.255')]) AS addr,

arrayJoin(['192.168.100.0/22', '192.168.100.0/24']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([toIPv6('::192.168.100.1'), toIPv6('::192.168.103.255')]) AS addr,

arrayJoin(['::192.168.100.0/118', '::192.168.100.0/120']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([CAST(toIPv4('192.168.100.1') AS Nullable(IPv4)), CAST(toIPv4('192.168.103.255') AS Nullable(IPv4))]) AS addr,

arrayJoin(['192.168.100.0/22', '192.168.100.0/24']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

WITH arrayJoin([CAST(toIPv6('::192.168.100.1') AS Nullable(IPv6)), CAST(toIPv6('::192.168.103.255') AS Nullable(IPv6))]) AS addr,

arrayJoin(['::192.168.100.0/118', '::192.168.100.0/120']) AS prefix

SELECT
    addr,
    prefix,
    isIPAddressInRange(addr, prefix);

DROP TABLE IF EXISTS test_data_2;

CREATE TABLE test_data_2
(
    cidr String
)
ENGINE = Memory();

INSERT INTO test_data_2 SELECT IPv4NumToString(IPv4CIDRToRange(IPv4StringToNum('255.255.255.255'), toUInt8(number)).1) || '/' || toString(number) AS cidr
FROM `system`.numbers
LIMIT 33;

SELECT sum(isIPAddressInRange(CAST(NULL AS Nullable(String)), cidr)) = 0
FROM test_data_2;

SELECT sum(isIPAddressInRange(toIPv4('0.0.0.0'), cidr)) = 1
FROM test_data_2;

SELECT sum(isIPAddressInRange(toIPv4('127.0.0.0'), cidr)) = 1
FROM test_data_2;

SELECT sum(isIPAddressInRange(toIPv4('128.0.0.0'), cidr)) = 2
FROM test_data_2;

SELECT sum(isIPAddressInRange(toIPv4('255.0.0.0'), cidr)) = 9
FROM test_data_2;

SELECT sum(isIPAddressInRange(toIPv4('255.0.0.1'), cidr)) = 9
FROM test_data_2;

SELECT sum(isIPAddressInRange(toIPv4('255.0.0.255'), cidr)) = 9
FROM test_data_2;

SELECT sum(isIPAddressInRange(toIPv4('255.255.255.255'), cidr)) = 33
FROM test_data_2;

SELECT sum(isIPAddressInRange(toIPv4('255.255.255.254'), cidr)) = 32
FROM test_data_2;

SELECT sum(isIPAddressInRange(CAST(NULL AS Nullable(IPv4)), cidr)) = 0
FROM test_data_2;

SELECT isIPAddressInRange(toIPv4('127.0.0.1'), 'ffff::/16');

SELECT isIPAddressInRange(toIPv4('127.0.0.1'), '::127.0.0.1/128');

SELECT isIPAddressInRange(CAST(toIPv4('127.0.0.1') AS Nullable(IPv4)), 'ffff::/16');

SELECT isIPAddressInRange(CAST(toIPv4('127.0.0.1') AS Nullable(IPv4)), '::127.0.0.1/128');

SELECT isIPAddressInRange(CAST(NULL AS Nullable(IPv4)), '::127.0.0.1/128');

SELECT isIPAddressInRange(toIPv6('::1'), '127.0.0.0/8');

SELECT isIPAddressInRange(toIPv6('::127.0.0.1'), '127.0.0.1/32');

SELECT isIPAddressInRange(CAST(toIPv6('::1') AS Nullable(IPv6)), '127.0.0.0/8');

SELECT isIPAddressInRange(CAST(toIPv6('::127.0.0.1') AS Nullable(IPv6)), '127.0.0.1/32');

SELECT isIPAddressInRange(CAST(NULL AS Nullable(IPv6)), '127.0.0.1/32');