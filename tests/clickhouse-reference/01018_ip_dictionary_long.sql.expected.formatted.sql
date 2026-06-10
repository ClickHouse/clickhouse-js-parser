-- Tags: long
SET send_logs_level = 'fatal';

CREATE TABLE CLICKHOUSE_DATABASE.table_ipv4_trie
(
    prefix String,
    asn UInt32,
    cca2 String
)
ENGINE = TinyLog();

-- numbers reordered to test sorting criteria too
INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie SELECT
    '255.255.255.255/' || toString((number + 1) * 13 % 33) AS prefix,
    toUInt32((number + 1) * 13 % 33) AS asn,
    'NA' AS cca2
FROM `system`.numbers
LIMIT 33;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict_ipv4_trie
(
    prefix String,
    asn UInt32,
    cca2 String
)
PRIMARY KEY prefix
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB currentDatabase() TABLE 'table_ipv4_trie'))
LIFETIME(MIN 10 MAX 100)
LAYOUT(IP_TRIE())
SETTINGS(dictionary_use_async_executor = '1', max_threads = '8');

-- fuzzer
SELECT '127.0.0.0/24' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefixprefixprefixprefix', tuple(IPv4StringToNumOrDefault('127.0.0.0127.0.0.0'))); -- { serverError BAD_ARGUMENTS }

SELECT 0 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('0.0.0.0')));

SELECT 1 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('128.0.0.0')));

SELECT 2 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('192.0.0.0')));

SELECT 3 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('224.0.0.0')));

SELECT 4 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('240.0.0.0')));

SELECT 5 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('248.0.0.0')));

SELECT 6 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('252.0.0.0')));

SELECT 7 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('254.0.0.0')));

SELECT 8 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.0.0.0')));

SELECT 9 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.128.0.0')));

SELECT 10 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.192.0.0')));

SELECT 11 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.224.0.0')));

SELECT 12 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.240.0.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.248.0.0')));

SELECT 14 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.252.0.0')));

SELECT 15 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.254.0.0')));

SELECT 16 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.0.0')));

SELECT 17 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.128.0')));

SELECT 18 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.192.0')));

SELECT 19 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.224.0')));

SELECT 20 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.240.0')));

SELECT 21 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.248.0')));

SELECT 22 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.252.0')));

SELECT 23 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.254.0')));

SELECT 24 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.255.0')));

SELECT 25 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.255.128')));

SELECT 26 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.255.192')));

SELECT 27 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.255.224')));

SELECT 28 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.255.240')));

SELECT 29 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.255.248')));

SELECT 30 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.255.252')));

SELECT 31 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.255.254')));

SELECT 32 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('255.255.255.255')));

SELECT 'RU' = dictGetString('placeholder' || '.dict_ipv4_trie', 'cca2', tuple(IPv4StringToNum('127.0.0.1')));

SELECT 1270 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('127.0.0.0')));

SELECT 1270 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('127.0.0.1')));

SELECT 1272 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('127.0.0.2')));

SELECT 1270 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('127.0.0.3')));

SELECT 1270 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('127.0.0.255')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.0.0.0')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.0.0.1')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.0.0.2')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.0.0.3')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.0.0.255')));

SELECT 11212 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('101.79.55.22')));

SELECT 11212 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv6StringToNum('::ffff:654f:3716')));

SELECT 11212 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv6StringToNum('::ffff:101.79.55.22')));

SELECT 11211 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(IPv4StringToNum('202.79.32.2')));

-- check that dictionary works with aliased types `IPv4` and `IPv6`
SELECT 11211 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(toIPv4('202.79.32.2')));

SELECT 11212 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'asn', tuple(toIPv6('::ffff:101.79.55.22')));

CREATE TABLE CLICKHOUSE_DATABASE.table_from_ipv4_trie_dict
(
    prefix String,
    asn UInt32,
    cca2 String
)
ENGINE = Dictionary(CLICKHOUSE_DATABASE.dict_ipv4_trie);

SELECT 1272 = asn
    AND 'RU' = cca2
FROM CLICKHOUSE_DATABASE.table_from_ipv4_trie_dict
WHERE prefix = '127.0.0.2/32';

SELECT 37 = COUNT(*)
FROM CLICKHOUSE_DATABASE.table_from_ipv4_trie_dict;

SELECT 37 = COUNTDistinct(prefix)
FROM CLICKHOUSE_DATABASE.table_from_ipv4_trie_dict;

DROP TABLE IF EXISTS CLICKHOUSE_DATABASE.table_from_ipv4_trie_dict;

DROP DICTIONARY IF EXISTS CLICKHOUSE_DATABASE.dict_ipv4_trie;

DROP TABLE IF EXISTS CLICKHOUSE_DATABASE.table_ipv4_trie;

CREATE TABLE CLICKHOUSE_DATABASE.table_ipv4_trie
(
    prefix String,
    val UInt32
)
ENGINE = TinyLog();

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie SELECT
    '255.255.255.255/' || toString(number) AS prefix,
    toUInt32(number) AS val
FROM VALUES('number UInt32', 5, 13, 24, 30);

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict_ipv4_trie
(
    prefix String,
    val UInt32
)
PRIMARY KEY prefix
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB currentDatabase() TABLE 'table_ipv4_trie'))
LIFETIME(MIN 10 MAX 100)
LAYOUT(IP_TRIE());

SELECT 0 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('0.0.0.0')));

SELECT 0 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('128.0.0.0')));

SELECT 0 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('192.0.0.0')));

SELECT 0 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('224.0.0.0')));

SELECT 0 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('240.0.0.0')));

SELECT 5 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('248.0.0.0')));

SELECT 5 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('252.0.0.0')));

SELECT 5 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('254.0.0.0')));

SELECT 5 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.0.0.0')));

SELECT 5 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.128.0.0')));

SELECT 5 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.192.0.0')));

SELECT 5 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.224.0.0')));

SELECT 5 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.240.0.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.248.0.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.252.0.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.254.0.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.0.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.128.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.192.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.224.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.240.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.248.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.252.0')));

SELECT 13 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.254.0')));

SELECT 24 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.255.0')));

SELECT 24 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.255.128')));

SELECT 24 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.255.192')));

SELECT 24 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.255.224')));

SELECT 24 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.255.240')));

SELECT 24 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.255.248')));

SELECT 30 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.255.252')));

SELECT 30 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.255.254')));

SELECT 30 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('255.255.255.255')));

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ipv4_trie;

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict_ipv4_trie
(
    prefix String,
    val UInt32
)
PRIMARY KEY prefix
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB currentDatabase() TABLE 'table_ipv4_trie'))
LIFETIME(MIN 10 MAX 100)
LAYOUT(IP_TRIE(ACCESS_TO_KEY_FROM_ATTRIBUTES 1));

SELECT '127.0.0.0/24' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.0.0.0')));

SELECT '127.0.0.1/32' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.0.0.1')));

SELECT '127.0.0.0/24' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.0.0.127')));

SELECT '127.0.0.0/16' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.0.255.127')));

SELECT '127.255.0.0/16' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.255.127.127')));

SELECT '127.255.128.0/24' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.255.128.9')));

SELECT '127.255.128.0/24' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.255.128.127')));

SELECT '127.255.128.10/32' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.255.128.10')));

SELECT '127.255.128.128/25' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.255.128.255')));

SELECT '127.255.255.128/32' = dictGetString('placeholder' || '.dict_ipv4_trie', 'prefix', tuple(IPv4StringToNum('127.255.255.128')));

SELECT 3 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.0.0.0')));

SELECT 4 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.0.0.1')));

SELECT 3 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.0.0.127')));

SELECT 2 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.0.255.127')));

SELECT 15 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.255.127.127')));

SELECT 16 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.255.128.9')));

SELECT 16 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.255.128.127')));

SELECT 18 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.255.128.10')));

SELECT 19 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.255.128.255')));

SELECT 20 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv4StringToNum('127.255.255.128')));

SELECT 3 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7f00:0')));

SELECT 4 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7f00:1')));

SELECT 3 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7f00:7f')));

SELECT 2 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7f00:ff7f')));

SELECT 15 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7fff:7f7f')));

SELECT 16 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7fff:8009')));

SELECT 16 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7fff:807f')));

SELECT 18 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7fff:800a')));

SELECT 19 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7fff:80ff')));

SELECT 20 = dictGetUInt32('placeholder' || '.dict_ipv4_trie', 'val', tuple(IPv6StringToNum('::ffff:7fff:ff80')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.0.0.127')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.0.255.127')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.255.127.127')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.255.128.9')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.255.128.127')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.255.128.10')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.255.128.255')));

SELECT 1 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('127.255.255.128')));

SELECT 0 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('128.127.127.127')));

SELECT 0 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('128.127.127.0')));

SELECT 0 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('255.127.127.0')));

SELECT 0 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('255.0.0.0')));

SELECT 0 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('0.0.0.0')));

SELECT 0 = dictHas('placeholder' || '.dict_ipv4_trie', tuple(IPv4StringToNum('1.1.1.1')));

CREATE TABLE CLICKHOUSE_DATABASE.table_ip_trie
(
    prefix String,
    val String
)
ENGINE = TinyLog();

INSERT INTO CLICKHOUSE_DATABASE.table_ip_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ip_trie SELECT
    'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff/' || toString((number + 1) * 13 % 129) AS prefix,
    toString((number + 1) * 13 % 129) AS val
FROM `system`.numbers
LIMIT 129;

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict_ip_trie
(
    prefix String,
    val String
)
PRIMARY KEY prefix
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB currentDatabase() TABLE 'table_ip_trie'))
LIFETIME(MIN 10 MAX 100)
LAYOUT(IP_TRIE(ACCESS_TO_KEY_FROM_ATTRIBUTES 1));

SELECT 'US' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('2620:0:870::')));

SELECT 'UK' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('2a02:6b8:1::')));

SELECT 'ZZ' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('2001:db8::')));

SELECT 'ZZ' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('2001:db8:ffff::')));

SELECT 1 = dictHas('placeholder' || '.dict_ip_trie', tuple(IPv6StringToNum('2001:db8:ffff::')));

SELECT 1 = dictHas('placeholder' || '.dict_ip_trie', tuple(IPv6StringToNum('2001:db8:ffff:ffff::')));

SELECT 1 = dictHas('placeholder' || '.dict_ip_trie', tuple(IPv6StringToNum('2001:db8:ffff:1::')));

SELECT '0' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('654f:3716::')));

SELECT 'JA' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('::ffff:654f:3716')));

SELECT 'JA' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('::ffff:101.79.55.22')));

SELECT 'JA' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('101.79.55.22')));

SELECT 1 = dictHas('placeholder' || '.dict_ip_trie', tuple(IPv4StringToNum('127.0.0.1')));

SELECT 1 = dictHas('placeholder' || '.dict_ip_trie', tuple(IPv6StringToNum('::ffff:127.0.0.1')));

SELECT '2620:0:870::/48' = dictGetString('placeholder' || '.dict_ip_trie', 'prefix', tuple(IPv6StringToNum('2620:0:870::')));

SELECT '2a02:6b8:1::/48' = dictGetString('placeholder' || '.dict_ip_trie', 'prefix', tuple(IPv6StringToNum('2a02:6b8:1::1')));

SELECT '2001:db8::/32' = dictGetString('placeholder' || '.dict_ip_trie', 'prefix', tuple(IPv6StringToNum('2001:db8::1')));

SELECT '::ffff:101.79.55.22/128' = dictGetString('placeholder' || '.dict_ip_trie', 'prefix', tuple(IPv6StringToNum('::ffff:654f:3716')));

SELECT '::ffff:101.79.55.22/128' = dictGetString('placeholder' || '.dict_ip_trie', 'prefix', tuple(IPv6StringToNum('::ffff:101.79.55.22')));

SELECT '0' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('::0')));

SELECT '1' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('8000::')));

SELECT '2' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('c000::')));

SELECT '3' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('e000::')));

SELECT '4' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('f000::')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('f800::')));

SELECT '6' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fc00::')));

SELECT '7' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fe00::')));

SELECT '8' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ff00::')));

SELECT '9' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ff80::')));

SELECT '10' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffc0::')));

SELECT '11' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffe0::')));

SELECT '12' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fff0::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fff8::')));

SELECT '14' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fffc::')));

SELECT '15' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fffe::')));

SELECT '16' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff::')));

SELECT '17' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:8000::')));

SELECT '18' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:c000::')));

SELECT '19' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:e000::')));

SELECT '20' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:f000::')));

SELECT '21' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:f800::')));

SELECT '22' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fc00::')));

SELECT '23' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fe00::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ff00::')));

SELECT '25' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ff80::')));

SELECT '26' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffc0::')));

SELECT '27' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffe0::')));

SELECT '28' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fff0::')));

SELECT '29' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fff8::')));

SELECT '30' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fffc::')));

SELECT '31' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fffe::')));

SELECT '32' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff::')));

SELECT '33' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:8000::')));

SELECT '34' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:c000::')));

SELECT '35' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:e000::')));

SELECT '36' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:f000::')));

SELECT '37' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:f800::')));

SELECT '38' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fc00::')));

SELECT '39' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fe00::')));

SELECT '40' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ff00::')));

SELECT '41' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ff80::')));

SELECT '42' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffc0::')));

SELECT '43' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffe0::')));

SELECT '44' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fff0::')));

SELECT '45' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fff8::')));

SELECT '46' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fffc::')));

SELECT '47' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fffe::')));

SELECT '48' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:8000::')));

SELECT '50' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:c000::')));

SELECT '51' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:e000::')));

SELECT '52' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:f000::')));

SELECT '53' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:f800::')));

SELECT '54' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fc00::')));

SELECT '55' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fe00::')));

SELECT '56' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ff00::')));

SELECT '57' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ff80::')));

SELECT '58' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffc0::')));

SELECT '59' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffe0::')));

SELECT '60' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fff0::')));

SELECT '61' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fff8::')));

SELECT '62' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fffc::')));

SELECT '63' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fffe::')));

SELECT '64' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff::')));

SELECT '65' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:8000::')));

SELECT '66' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:c000::')));

SELECT '67' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:e000::')));

SELECT '68' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:f000::')));

SELECT '69' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:f800::')));

SELECT '70' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fc00::')));

SELECT '71' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fe00::')));

SELECT '72' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ff00::')));

SELECT '73' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ff80::')));

SELECT '74' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffc0::')));

SELECT '75' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffe0::')));

SELECT '76' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fff0::')));

SELECT '77' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fff8::')));

SELECT '78' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fffc::')));

SELECT '79' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fffe::')));

SELECT '80' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff::')));

SELECT '81' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:8000::')));

SELECT '82' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:c000::')));

SELECT '83' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:e000::')));

SELECT '84' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:f000::')));

SELECT '85' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:f800::')));

SELECT '86' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fc00::')));

SELECT '87' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fe00::')));

SELECT '88' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ff00::')));

SELECT '89' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ff80::')));

SELECT '90' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffc0::')));

SELECT '91' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffe0::')));

SELECT '92' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fff0::')));

SELECT '93' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fff8::')));

SELECT '94' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fffc::')));

SELECT '95' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fffe::')));

SELECT '96' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff::')));

SELECT '97' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:8000:0')));

SELECT '98' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:c000:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:e000:0')));

SELECT '100' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:f000:0')));

SELECT '101' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:f800:0')));

SELECT '102' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fc00:0')));

SELECT '103' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fe00:0')));

SELECT '104' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ff00:0')));

SELECT '105' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ff80:0')));

SELECT '106' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffc0:0')));

SELECT '107' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffe0:0')));

SELECT '108' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fff0:0')));

SELECT '109' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fff8:0')));

SELECT '110' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fffc:0')));

SELECT '111' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fffe:0')));

SELECT '112' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:0')));

SELECT '113' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:8000')));

SELECT '114' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:c000')));

SELECT '115' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:e000')));

SELECT '116' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:f000')));

SELECT '117' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:f800')));

SELECT '118' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fc00')));

SELECT '119' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fe00')));

SELECT '120' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ff00')));

SELECT '121' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ff80')));

SELECT '122' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffc0')));

SELECT '123' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffe0')));

SELECT '124' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff0')));

SELECT '125' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff8')));

SELECT '126' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc')));

SELECT '127' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffe')));

SELECT '128' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')));

CREATE TABLE CLICKHOUSE_DATABASE.table_from_ip_trie_dict
(
    prefix String,
    val String
)
ENGINE = Dictionary(CLICKHOUSE_DATABASE.dict_ip_trie);

SELECT MIN(val = 'US')
FROM CLICKHOUSE_DATABASE.table_from_ip_trie_dict
WHERE prefix = '2620:0:870::/48';

SELECT 134 = COUNT(*)
FROM CLICKHOUSE_DATABASE.table_from_ip_trie_dict;

DROP TABLE IF EXISTS CLICKHOUSE_DATABASE.table_from_ip_trie_dict;

DROP DICTIONARY IF EXISTS CLICKHOUSE_DATABASE.dict_ip_trie;

DROP TABLE IF EXISTS CLICKHOUSE_DATABASE.table_ip_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ip_trie SELECT
    'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff/' || toString(number) AS prefix,
    toString(number) AS val
FROM VALUES('number UInt32', 5, 13, 24, 48, 49, 99, 127);

INSERT INTO CLICKHOUSE_DATABASE.table_ip_trie;

INSERT INTO CLICKHOUSE_DATABASE.table_ip_trie SELECT
    '255.255.255.255/' || toString(number) AS prefix,
    toString(number) AS val
FROM VALUES('number UInt32', 5, 13, 24, 30);

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict_ip_trie
(
    prefix String,
    val String
)
PRIMARY KEY prefix
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB currentDatabase() TABLE 'table_ip_trie'))
LIFETIME(MIN 10 MAX 100)
LAYOUT(IP_TRIE());

SELECT 0 = dictHas('placeholder' || '.dict_ip_trie', tuple(IPv6StringToNum('::ffff:1:1')));

SELECT '' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('654f:3716::')));

SELECT 0 = dictHas('placeholder' || '.dict_ip_trie', tuple(IPv6StringToNum('654f:3716::')));

SELECT 0 = dictHas('placeholder' || '.dict_ip_trie', tuple(IPv6StringToNum('654f:3716:ffff::')));

SELECT '' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('::0')));

SELECT '' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('8000::')));

SELECT '' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('c000::')));

SELECT '' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('e000::')));

SELECT '' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('f000::')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fc00::')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fe00::')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ff00::')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ff80::')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffc0::')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffe0::')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fff0::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fffc::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('fffe::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:8000::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:c000::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:e000::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:f000::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:f800::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fc00::')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fe00::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ff80::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffc0::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffe0::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fff0::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fff8::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fffc::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:fffe::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:8000::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:c000::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:e000::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:f000::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:f800::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fc00::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fe00::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ff00::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ff80::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffc0::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffe0::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fff0::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fff8::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fffc::')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:fffe::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:c000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:e000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:f000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:f800::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fc00::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fe00::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ff00::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ff80::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffc0::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffe0::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fff0::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fff8::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fffc::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:fffe::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:8000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:c000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:e000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:f000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:f800::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fc00::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fe00::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ff00::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ff80::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffc0::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffe0::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fff0::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fff8::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fffc::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:fffe::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:8000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:c000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:e000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:f000::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:f800::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fc00::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fe00::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ff00::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ff80::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffc0::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffe0::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fff0::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fff8::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fffc::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:fffe::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff::')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:8000:0')));

SELECT '49' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:c000:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:f000:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:f800:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fc00:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fe00:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ff00:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ff80:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffc0:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffe0:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fff0:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fff8:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fffc:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:fffe:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:8000')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:c000')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:e000')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:f000')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:f800')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fc00')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fe00')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ff00')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ff80')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffc0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffe0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff0')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fff8')));

SELECT '99' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffc')));

SELECT '127' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')));

SELECT '' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('0.0.0.0')));

SELECT '' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('128.0.0.0')));

SELECT '' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('240.0.0.0')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('248.0.0.0')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('252.0.0.0')));

SELECT '5' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.240.0.0')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.248.0.0')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.252.0.0')));

SELECT '13' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.255.254.0')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.255.255.0')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.255.255.128')));

SELECT '24' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.255.255.248')));

SELECT '30' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.255.255.252')));

SELECT '30' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.255.255.254')));

SELECT '30' = dictGetString('placeholder' || '.dict_ip_trie', 'val', tuple(IPv4StringToNum('255.255.255.255')));

DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE;