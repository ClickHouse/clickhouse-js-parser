DROP TABLE IF EXISTS test_table_ipv4;

CREATE TABLE test_table_ipv4
(
    ip String,
    ipv4 IPv4
)
ENGINE = TinyLog();

INSERT INTO test_table_ipv4; --{error CANNOT_PARSE_IPV4}

SET input_format_ipv4_default_on_conversion_error = '1';

SELECT
    ip,
    ipv4
FROM test_table_ipv4;

SET input_format_ipv4_default_on_conversion_error = '0';

DROP TABLE test_table_ipv4;

DROP TABLE IF EXISTS test_table_ipv4_materialized;

CREATE TABLE test_table_ipv4_materialized
(
    ip String,
    ipv6 IPv4 MATERIALIZED toIPv4(ip)
)
ENGINE = TinyLog();

INSERT INTO test_table_ipv4_materialized (ip); --{serverError CANNOT_PARSE_IPV4}

SET cast_ipv4_ipv6_default_on_conversion_error = '1';

SELECT
    ip,
    ipv6
FROM test_table_ipv4_materialized;

SET cast_ipv4_ipv6_default_on_conversion_error = '0';

DROP TABLE test_table_ipv4_materialized;

DROP TABLE IF EXISTS test_table_ipv6;

CREATE TABLE test_table_ipv6
(
    ip String,
    ipv6 IPv6
)
ENGINE = TinyLog();

INSERT INTO test_table_ipv6; --{error CANNOT_PARSE_IPV6}

SET input_format_ipv6_default_on_conversion_error = '1';

SELECT
    ip,
    ipv6
FROM test_table_ipv6;

SET input_format_ipv6_default_on_conversion_error = '0';

DROP TABLE test_table_ipv6;

DROP TABLE IF EXISTS test_table_ipv6_materialized;

CREATE TABLE test_table_ipv6_materialized
(
    ip String,
    ipv6 IPv6 MATERIALIZED toIPv6(ip)
)
ENGINE = TinyLog();

INSERT INTO test_table_ipv6_materialized (ip); --{serverError CANNOT_PARSE_IPV6}

SELECT
    ip,
    ipv6
FROM test_table_ipv6_materialized;

DROP TABLE test_table_ipv6_materialized;