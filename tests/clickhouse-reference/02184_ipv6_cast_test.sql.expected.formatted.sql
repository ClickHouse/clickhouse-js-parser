DROP TABLE IF EXISTS ipv6_test26473;

CREATE TABLE ipv6_test26473
(
    ip String,
    ipv6 IPv6 MATERIALIZED toIPv6(ip),
    is_ipv6 Boolean MATERIALIZED isIPv6String(ip),
    cblock IPv6 MATERIALIZED cutIPv6(ipv6, 10, 1),
    cblock1 IPv6 MATERIALIZED toIPv6(cutIPv6(ipv6, 10, 1))
)
ENGINE = Memory();

INSERT INTO ipv6_test26473;

SELECT
    ip,
    ipv6,
    cblock,
    cblock1,
    is_ipv6,
    cutIPv6(ipv6, 10, 1)
FROM ipv6_test26473;

DROP TABLE ipv6_test26473;