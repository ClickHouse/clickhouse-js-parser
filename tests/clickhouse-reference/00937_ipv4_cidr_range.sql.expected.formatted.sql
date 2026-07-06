DROP TABLE IF EXISTS ipv4_range;

CREATE TABLE ipv4_range
(
    ip IPv4,
    cidr UInt8
)
ENGINE = Memory();

INSERT INTO ipv4_range (ip, cidr);

WITH IPv4CIDRToRange(toIPv4('192.168.0.0'), 8) AS ip_range

SELECT COUNT(*)
FROM ipv4_range
WHERE ip >= tupleElement(ip_range, 1)
    AND ip <= tupleElement(ip_range, 2);

WITH IPv4CIDRToRange(toIPv4('192.168.0.0'), 13) AS ip_range

SELECT COUNT(*)
FROM ipv4_range
WHERE ip >= tupleElement(ip_range, 1)
    AND ip <= tupleElement(ip_range, 2);

WITH IPv4CIDRToRange(toIPv4('192.168.0.0'), 16) AS ip_range

SELECT COUNT(*)
FROM ipv4_range
WHERE ip >= tupleElement(ip_range, 1)
    AND ip <= tupleElement(ip_range, 2);

WITH IPv4CIDRToRange(toIPv4('192.168.0.0'), 0) AS ip_range

SELECT COUNT(*)
FROM ipv4_range
WHERE ip >= tupleElement(ip_range, 1)
    AND ip <= tupleElement(ip_range, 2);

WITH IPv4CIDRToRange(ip, cidr) AS ip_range

SELECT
    ip,
    cidr,
    IPv4NumToString(tupleElement(ip_range, 1)),
    ip_range
FROM ipv4_range;

DROP TABLE ipv4_range;

SELECT IPv4CIDRToRange(toIPv4('192.168.5.2'), 0);

SELECT IPv4CIDRToRange(toIPv4('255.255.255.255'), 8);

SELECT IPv4CIDRToRange(toIPv4('192.168.5.2'), 32);

SELECT IPv4CIDRToRange(toIPv4('0.0.0.0'), 8);

SELECT IPv4CIDRToRange(toIPv4('255.0.0.0'), 4);

SELECT IPv4CIDRToRange(toIPv4('255.0.0.0'), toUInt8(4 + number))
FROM numbers(2);