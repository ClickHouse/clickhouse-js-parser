WITH toIPv4('127.0.0.10') AS ip

SELECT
    ip = CAST('2130706442' AS UInt32),
    ip = CAST('0' AS UInt32),
    ip < CAST('2130706443' AS UInt32),
    ip > CAST('2130706441' AS UInt32),
    ip <= CAST('2130706442' AS UInt32),
    ip >= CAST('2130706442' AS UInt32),
    ip != CAST('2130706442' AS UInt32);