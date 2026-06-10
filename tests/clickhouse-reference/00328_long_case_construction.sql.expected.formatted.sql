-- Tags: long, no-msan
/* Trivial case */
SELECT multiIf(1, 2, 3, 4, 5);

SELECT multiIf(1, 'A', 2, 'BC', 'DEF');

SELECT multiIf(1, toFixedString('A', 16), 2, toFixedString('BC', 16), toFixedString('DEF', 16));

SELECT multiIf(1, [1, 2], 2, [3, 4], [5, 6]);

SELECT multiIf(1, ['A', 'B'], 2, ['C', 'D'], ['E', 'F']);

/* No CASE expression. Numeric clauses */
SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt64(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toUInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat64(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt8(1), number % 3 = 0, toFloat64(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt64(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toUInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat64(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt16(1), number % 3 = 0, toFloat64(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt64(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toUInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat64(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt32(1), number % 3 = 0, toFloat64(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt64(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toInt64(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt64(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toUInt64(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat64(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt8(1), number % 3 = 0, toFloat64(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt64(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toUInt64(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat64(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt16(1), number % 3 = 0, toFloat64(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt64(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toUInt64(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat64(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt32(1), number % 3 = 0, toFloat64(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt8(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt16(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt32(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toUInt64(1), number % 3 = 0, toUInt64(2), toUInt64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toUInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat64(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat32(1), number % 3 = 0, toFloat64(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt8(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt8(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt8(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt8(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt8(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt8(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt8(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt8(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt16(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt16(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt16(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt16(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt16(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt16(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt16(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt16(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toUInt32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat32(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat32(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat32(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat32(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat32(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat32(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat32(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat32(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat64(2), toInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat64(2), toInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat64(2), toInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat64(2), toUInt8(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat64(2), toUInt16(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat64(2), toUInt32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat64(2), toFloat32(3))
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, toFloat64(1), number % 3 = 0, toFloat64(2), toFloat64(3))
FROM `system`.numbers
LIMIT 10;

/* No CASE expression. Numeric array clauses. */
SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt8(1), toInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt16(1), toInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt32(1), toInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toInt64(1), toInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt8(1), toUInt8(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt16(1), toUInt16(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toInt64(2), toInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt64(3), toInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt32(1), toUInt32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toUInt64(1), toUInt64(2)], number % 3 = 0, [toUInt64(2), toUInt64(3)], [toUInt64(3), toUInt64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat32(1), toFloat32(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt8(2), toInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt16(2), toInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toInt32(2), toInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt8(2), toUInt8(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt16(2), toUInt16(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toUInt32(2), toUInt32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat32(2), toFloat32(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt8(3), toInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt16(3), toInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toInt32(3), toInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt8(3), toUInt8(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt16(3), toUInt16(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toUInt32(3), toUInt32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat32(3), toFloat32(3)])
FROM `system`.numbers
LIMIT 10;

SELECT multiIf(number % 2 = 0, [toFloat64(1), toFloat64(2)], number % 3 = 0, [toFloat64(2), toFloat64(3)], [toFloat64(3), toFloat64(3)])
FROM `system`.numbers
LIMIT 10;

/* No CASE expression. String clauses. */
DROP TABLE IF EXISTS multi_if_check;

CREATE TABLE multi_if_check
(
    col1 UInt64,
    col2 String,
    col3 String,
    col4 String
)
ENGINE = TinyLog();

INSERT INTO multi_if_check (col1, col2, col3, col4);

INSERT INTO multi_if_check (col1, col2, col3, col4);

INSERT INTO multi_if_check (col1, col2, col3, col4);

INSERT INTO multi_if_check (col1, col2, col3, col4);

INSERT INTO multi_if_check (col1, col2, col3, col4);

INSERT INTO multi_if_check (col1, col2, col3, col4);

INSERT INTO multi_if_check (col1, col2, col3, col4);

INSERT INTO multi_if_check (col1, col2, col3, col4);

INSERT INTO multi_if_check (col1, col2, col3, col4);

INSERT INTO multi_if_check (col1, col2, col3, col4);

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, col3, col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, col1 % 3 = 0, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, col3, col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, col2, 1, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, col3, col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), col1 % 3 = 0, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, col3, col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString(col2, 16), 1, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, col3, col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), col1 % 3 = 0, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, col3, col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, toFixedString('foo', 16), 1, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, col3, col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', col1 % 3 = 0, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, col3, col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, 'foo', 1, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, col3, col4)
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, col2, col1 % 3 = 0, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(1, col2, 1, col3, col4)
FROM multi_if_check;

SELECT multiIf(1, col2, 1, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, col2, 1, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, col2, 1, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(1, col2, 1, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(1, col2, 1, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, col2, 1, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, col2, 1, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, col2, 1, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(1, col2, 1, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, col2, 1, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, col2, 1, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, col2, 1, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(1, col2, 1, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, col2, 1, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, col2, 1, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, col3, col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), col1 % 3 = 0, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, col3, col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString(col2, 16), 1, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, col3, col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), col1 % 3 = 0, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, col3, col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, toFixedString('foo', 16), 1, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, col3, col4)
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', col1 % 3 = 0, 'bar', 'baz')
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, col3, col4)
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, col3, toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, col3, toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, col3, 'baz')
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, toFixedString(col3, 16), col4)
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, toFixedString(col3, 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, toFixedString(col3, 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, toFixedString(col3, 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, toFixedString('bar', 16), col4)
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, toFixedString('bar', 16), toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, toFixedString('bar', 16), toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, toFixedString('bar', 16), 'baz')
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, 'bar', col4)
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, 'bar', toFixedString(col4, 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, 'bar', toFixedString('baz', 16))
FROM multi_if_check;

SELECT multiIf(1, 'foo', 1, 'bar', 'baz')
FROM multi_if_check;

/* No CASE expression. String array clauses. */
CREATE TABLE multi_if_check
(
    col1 UInt64,
    col2 String,
    col3 String,
    col4 String,
    col5 String,
    col6 String,
    col7 String
)
ENGINE = TinyLog();

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

INSERT INTO multi_if_check (col1, col2, col3, col4, col5, col6, col7);

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], col1 % 3 = 0, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, col3], 1, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], col1 % 3 = 0, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, [col2, 'bar'], 1, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], col1 % 3 = 0, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', col3], 1, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], col1 % 3 = 0, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(col1 % 2 = 0, ['foo', 'bar'], 1, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], col1 % 3 = 0, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, col3], 1, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], col1 % 3 = 0, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, [col2, 'bar'], 1, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], col1 % 3 = 0, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', col3], 1, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], col1 % 3 = 0, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, [col4, col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, [col4, col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, [col4, col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, [col4, col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, [col4, 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, [col4, 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, [col4, 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, [col4, 'bar'], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, ['foo', col5], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, ['foo', col5], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, ['foo', col5], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, ['foo', col5], ['foo', 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, ['foo', 'bar'], [col6, col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, ['foo', 'bar'], [col6, 'bar'])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, ['foo', 'bar'], ['foo', col7])
FROM multi_if_check;

SELECT multiIf(1, ['foo', 'bar'], 1, ['foo', 'bar'], ['foo', 'bar'])
FROM multi_if_check;

/* CASE expression. Numeric clauses. */
CREATE TABLE multi_if_check
(
    col1 UInt64
)
ENGINE = TinyLog();

INSERT INTO multi_if_check (col1) SELECT toUInt64((number * 37 + 13) % 3) AS col1
FROM `system`.numbers
LIMIT 10;

SELECT caseWithExpression(col1, 0, 1, 1, 2, 3)
FROM multi_if_check;

/* CASE expression. String clauses. */
SELECT caseWithExpression(col1, 1, 'A', 2, 'AB', 'ABC')
FROM multi_if_check;