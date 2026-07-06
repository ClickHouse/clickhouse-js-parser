SELECT murmurHash2_32(123456);

SELECT murmurHash2_32(CAST(3 AS UInt8));

SELECT murmurHash2_32(CAST(1.2684 AS Float32));

SELECT murmurHash2_32(CAST(-154477 AS Int64));

SELECT murmurHash2_32('foo');

SELECT murmurHash2_32(CAST('bar' AS FixedString(3)));

SELECT murmurHash2_32(x)
FROM (
        SELECT CAST(1 AS Enum8('a' = 1, 'b' = 2)) AS x
    );

SELECT murmurHash2_32('');

SELECT murmurHash2_32('');

SELECT murmurHash2_32('\0');

SELECT murmurHash2_32('\0\0');

SELECT murmurHash2_32(1);

SELECT murmurHash2_32(toUInt16(2));

SELECT murmurHash2_32(2) = bitXor(toUInt32(1540483477 * bitXor(toUInt32(3 * 1540483477) AS a, bitShiftRight(a, 13))) AS b, bitShiftRight(b, 15));

SELECT murmurHash2_32('') = bitXor(toUInt32(1540483477 * bitXor(toUInt32(3 * 1540483477) AS a, bitShiftRight(a, 13))) AS b, bitShiftRight(b, 15));

SELECT murmurHash2_64('foo');

SELECT murmurHash2_64('');

SELECT murmurHash2_64(1);

SELECT murmurHash3_32('foo');

SELECT murmurHash3_32('');

SELECT murmurHash3_32(1);

SELECT murmurHash3_64('foo');

SELECT murmurHash3_64('');

SELECT murmurHash3_64(1);

SELECT gccMurmurHash('foo');

SELECT gccMurmurHash('');

SELECT gccMurmurHash(1);

SELECT hex(murmurHash3_128('foo'));

SELECT hex(murmurHash3_128(''));