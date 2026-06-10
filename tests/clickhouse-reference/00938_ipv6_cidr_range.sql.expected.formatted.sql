SELECT IPv6CIDRToRange(1, 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT IPv6CIDRToRange('1234', 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT IPv6CIDRToRange(toFixedString('1234', 10), 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT IPv6CIDRToRange(toFixedString('1234', 16), toUInt16(1)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

DROP TABLE IF EXISTS ipv6_range;

CREATE TABLE ipv6_range
(
    ip IPv6,
    cidr UInt8
)
ENGINE = Memory();

INSERT INTO ipv6_range (ip, cidr);

WITH IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), 32) AS ip_range

SELECT COUNT(*)
FROM ipv6_range
WHERE ip >= tupleElement(ip_range, 1)
    AND ip <= tupleElement(ip_range, 2);

WITH IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), 25) AS ip_range

SELECT COUNT(*)
FROM ipv6_range
WHERE ip >= tupleElement(ip_range, 1)
    AND ip <= tupleElement(ip_range, 2);

WITH IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), 26) AS ip_range

SELECT COUNT(*)
FROM ipv6_range
WHERE ip >= tupleElement(ip_range, 1)
    AND ip <= tupleElement(ip_range, 2);

WITH IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), 64) AS ip_range

SELECT COUNT(*)
FROM ipv6_range
WHERE ip >= tupleElement(ip_range, 1)
    AND ip <= tupleElement(ip_range, 2);

WITH IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), 0) AS ip_range

SELECT COUNT(*)
FROM ipv6_range
WHERE ip >= tupleElement(ip_range, 1)
    AND ip <= tupleElement(ip_range, 2);

SELECT
    IPv6NumToString(ip),
    cidr,
    IPv6CIDRToRange(ip, cidr)
FROM ipv6_range;

DROP TABLE ipv6_range;

SELECT IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), 0);

SELECT IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), 128);

SELECT IPv6CIDRToRange(IPv6StringToNum('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'), 64);

SELECT IPv6CIDRToRange(IPv6StringToNum('0000:0000:0000:0000:0000:0000:0000:0000'), 8);

SELECT IPv6CIDRToRange(IPv6StringToNum('ffff:0000:0000:0000:0000:0000:0000:0000'), 4);

SELECT IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), 128) = IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), 200);

SELECT IPv6CIDRToRange(IPv6StringToNum('2001:0db8:0000:85a3:0000:0000:ac1f:8001'), toUInt8(128 - number))
FROM numbers(2);