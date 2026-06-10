SELECT (1 ? ('abc' AS s) : 'def') = s;

SELECT (1 ? toFixedString('abc' AS s, 3) : 'def') = s;

SELECT (1 ? toFixedString('abc' AS s, 3) : toFixedString('def', 3)) = s;

SELECT (1 ? ('abc' AS s) : toFixedString('def', 3)) = s;

SELECT (1 ? (today() AS t) : yesterday()) = t;

SELECT (1 ? (now() AS n) : now() - 1) = n;

SELECT (1 ? (toUInt8(0) AS i) : toUInt8(1)) = i;

SELECT (1 ? (toUInt16(0) AS i) : toUInt8(1)) = i;

SELECT (1 ? (toUInt32(0) AS i) : toUInt8(1)) = i;

SELECT (1 ? (toUInt64(0) AS i) : toUInt8(1)) = i;

SELECT (1 ? (toInt8(0) AS i) : toUInt8(1)) = i;

SELECT (1 ? (toInt16(0) AS i) : toUInt8(1)) = i;

SELECT (1 ? (toInt32(0) AS i) : toUInt8(1)) = i;

SELECT (1 ? (toInt64(0) AS i) : toUInt8(1)) = i;

SELECT (1 ? (toUInt8(0) AS i) : toUInt16(1)) = i;

SELECT (1 ? (toUInt16(0) AS i) : toUInt16(1)) = i;

SELECT (1 ? (toUInt32(0) AS i) : toUInt16(1)) = i;

SELECT (1 ? (toUInt64(0) AS i) : toUInt16(1)) = i;

SELECT (1 ? (toInt8(0) AS i) : toUInt16(1)) = i;

SELECT (1 ? (toInt16(0) AS i) : toUInt16(1)) = i;

SELECT (1 ? (toInt32(0) AS i) : toUInt16(1)) = i;

SELECT (1 ? (toInt64(0) AS i) : toUInt16(1)) = i;

SELECT (1 ? (toUInt8(0) AS i) : toUInt32(1)) = i;

SELECT (1 ? (toUInt16(0) AS i) : toUInt32(1)) = i;

SELECT (1 ? (toUInt32(0) AS i) : toUInt32(1)) = i;

SELECT (1 ? (toUInt64(0) AS i) : toUInt32(1)) = i;

SELECT (1 ? (toInt8(0) AS i) : toUInt32(1)) = i;

SELECT (1 ? (toInt16(0) AS i) : toUInt32(1)) = i;

SELECT (1 ? (toInt32(0) AS i) : toUInt32(1)) = i;

SELECT (1 ? (toInt64(0) AS i) : toUInt32(1)) = i;

SELECT (1 ? (toUInt8(0) AS i) : toUInt64(1)) = i;

SELECT (1 ? (toUInt16(0) AS i) : toUInt64(1)) = i;

SELECT (1 ? (toUInt32(0) AS i) : toUInt64(1)) = i;

SELECT (1 ? (toUInt64(0) AS i) : toUInt64(1)) = i;

--select (1 ? (toInt8(0) as i) : toUInt64(1)) = i;
--select (1 ? (toInt16(0) as i) : toUInt64(1)) = i;
--select (1 ? (toInt32(0) as i) : toUInt64(1)) = i;
--select (1 ? (toInt64(0) as i) : toUInt64(1)) = i;
SELECT (1 ? (toUInt8(0) AS i) : toInt8(1)) = i;

SELECT (1 ? (toUInt16(0) AS i) : toInt8(1)) = i;

SELECT (1 ? (toUInt32(0) AS i) : toInt8(1)) = i;

--select (1 ? (toUInt64(0) as i) : toInt8(1)) = i;
SELECT (1 ? (toInt8(0) AS i) : toInt8(1)) = i;

SELECT (1 ? (toInt16(0) AS i) : toInt8(1)) = i;

SELECT (1 ? (toInt32(0) AS i) : toInt8(1)) = i;

SELECT (1 ? (toInt64(0) AS i) : toInt8(1)) = i;

SELECT (1 ? (toUInt8(0) AS i) : toInt16(1)) = i;

SELECT (1 ? (toUInt16(0) AS i) : toInt16(1)) = i;

SELECT (1 ? (toUInt32(0) AS i) : toInt16(1)) = i;

--select (1 ? (toUInt64(0) as i) : toInt16(1)) = i;
SELECT (1 ? (toInt8(0) AS i) : toInt16(1)) = i;

SELECT (1 ? (toInt16(0) AS i) : toInt16(1)) = i;

SELECT (1 ? (toInt32(0) AS i) : toInt16(1)) = i;

SELECT (1 ? (toInt64(0) AS i) : toInt16(1)) = i;

SELECT (1 ? (toUInt8(0) AS i) : toInt32(1)) = i;

SELECT (1 ? (toUInt16(0) AS i) : toInt32(1)) = i;

SELECT (1 ? (toUInt32(0) AS i) : toInt32(1)) = i;

--select (1 ? (toUInt64(0) as i) : toInt32(1)) = i;
SELECT (1 ? (toInt8(0) AS i) : toInt32(1)) = i;

SELECT (1 ? (toInt16(0) AS i) : toInt32(1)) = i;

SELECT (1 ? (toInt32(0) AS i) : toInt32(1)) = i;

SELECT (1 ? (toInt64(0) AS i) : toInt32(1)) = i;

SELECT (1 ? (toUInt8(0) AS i) : toInt64(1)) = i;

SELECT (1 ? (toUInt16(0) AS i) : toInt64(1)) = i;

SELECT (1 ? (toUInt32(0) AS i) : toInt64(1)) = i;

--select (1 ? (toUInt64(0) as i) : toInt64(1)) = i;
SELECT (1 ? (toInt8(0) AS i) : toInt64(1)) = i;

SELECT (1 ? (toInt16(0) AS i) : toInt64(1)) = i;

SELECT (1 ? (toInt32(0) AS i) : toInt64(1)) = i;

SELECT (1 ? (toInt64(0) AS i) : toInt64(1)) = i;