SELECT bitCount(CAST(-1 AS UInt128));

SELECT bitCount(CAST(-1 AS UInt256));

SELECT bitCount(CAST(-1 AS Int128));

SELECT bitCount(CAST(-1 AS Int256));

SELECT bitCount(CAST(-1 AS UInt128) - 1);

SELECT bitCount(CAST(-1 AS UInt256) - 2);

SELECT bitCount(CAST(-1 AS Int128) - 3);

SELECT bitCount(CAST(-1 AS Int256) - 4);

SELECT bitCount(CAST(18446744073709551615 AS Int256));

SELECT toTypeName(bitCount(CAST('1' AS UInt128)));

SELECT toTypeName(bitCount(CAST('1' AS UInt256)));

SELECT toTypeName(bitCount(CAST('1' AS Int128)));

SELECT toTypeName(bitCount(CAST('1' AS Int256)));