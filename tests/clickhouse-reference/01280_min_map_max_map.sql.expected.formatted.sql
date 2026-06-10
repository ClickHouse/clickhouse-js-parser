SELECT
    minMap([toInt32(number % 10), number % 10 + 1], [number, 1]) AS m,
    toTypeName(m)
FROM numbers(1, 100);

SELECT minMap([1], [toInt32(number) - 50])
FROM numbers(1, 100);

SELECT minMap([CAST(1 AS Decimal(10, 2))], [CAST(toInt32(number) - 50 AS Decimal(10, 2))])
FROM numbers(1, 100);

SELECT
    maxMap([toInt32(number % 10), number % 10 + 1], [number, 1]) AS m,
    toTypeName(m)
FROM numbers(1, 100);

SELECT maxMap([1], [toInt32(number) - 50])
FROM numbers(1, 100);

SELECT maxMap([CAST(1 AS Decimal(10, 2))], [CAST(toInt32(number) - 50 AS Decimal(10, 2))])
FROM numbers(1, 100);

-- check different types for minMap
SELECT minMap(val, cnt)
FROM values('val Array(UUID), cnt Array(UUID)', (['01234567-89ab-cdef-0123-456789abcdef'], ['01111111-89ab-cdef-0123-456789abcdef']), (['01234567-89ab-cdef-0123-456789abcdef'], ['02222222-89ab-cdef-0123-456789abcdef']));

SELECT minMap(val, cnt)
FROM values('val Array(String), cnt Array(String)', (['1'], ['1']), (['1'], ['2']));

SELECT minMap(val, cnt)
FROM values('val Array(FixedString(1)), cnt Array(FixedString(1))', (['1'], ['1']), (['1'], ['2']));

SELECT minMap(val, cnt)
FROM values('val Array(UInt64), cnt Array(UInt64)', ([1], [1]), ([1], [2]));

SELECT minMap(val, cnt)
FROM values('val Array(Float64), cnt Array(Int8)', ([1], [1]), ([1], [2]));

SELECT minMap(val, cnt)
FROM values('val Array(Date), cnt Array(Int16)', ([1], [1]), ([1], [2]));

SELECT minMap(val, cnt)
FROM values('val Array(DateTime(''Asia/Istanbul'')), cnt Array(Int32)', ([1], [1]), ([1], [2]));

SELECT minMap(val, cnt)
FROM values('val Array(Decimal(10, 2)), cnt Array(Int16)', (['1.01'], [1]), (['1.01'], [2]));

SELECT minMap(val, cnt)
FROM values('val Array(Enum16(''a''=1)), cnt Array(Int16)', (['a'], [1]), (['a'], [2]));

-- check different types for maxMap
SELECT maxMap(val, cnt)
FROM values('val Array(UUID), cnt Array(UUID)', (['01234567-89ab-cdef-0123-456789abcdef'], ['01111111-89ab-cdef-0123-456789abcdef']), (['01234567-89ab-cdef-0123-456789abcdef'], ['02222222-89ab-cdef-0123-456789abcdef']));

SELECT maxMap(val, cnt)
FROM values('val Array(String), cnt Array(String)', (['1'], ['1']), (['1'], ['2']));

SELECT maxMap(val, cnt)
FROM values('val Array(FixedString(1)), cnt Array(FixedString(1))', (['1'], ['1']), (['1'], ['2']));

SELECT maxMap(val, cnt)
FROM values('val Array(UInt64), cnt Array(UInt64)', ([1], [1]), ([1], [2]));

SELECT maxMap(val, cnt)
FROM values('val Array(Float64), cnt Array(Int8)', ([1], [1]), ([1], [2]));

SELECT maxMap(val, cnt)
FROM values('val Array(Date), cnt Array(Int16)', ([1], [1]), ([1], [2]));

SELECT maxMap(val, cnt)
FROM values('val Array(DateTime(''Asia/Istanbul'')), cnt Array(Int32)', ([1], [1]), ([1], [2]));

SELECT maxMap(val, cnt)
FROM values('val Array(Decimal(10, 2)), cnt Array(Int16)', (['1.01'], [1]), (['1.01'], [2]));

SELECT maxMap(val, cnt)
FROM values('val Array(Enum16(''a''=1)), cnt Array(Int16)', (['a'], [1]), (['a'], [2]));

-- bugfix, minMap and maxMap should not remove values with zero and empty strings but this behavior should not affect sumMap
SELECT minMap(val, cnt)
FROM values('val Array(UInt64), cnt Array(UInt64)', ([1], [0]), ([2], [0]));

SELECT maxMap(val, cnt)
FROM values('val Array(UInt64), cnt Array(UInt64)', ([1], [0]), ([2], [0]));

SELECT minMap(val, cnt)
FROM values('val Array(String), cnt Array(String)', (['A'], ['']), (['B'], ['']));

SELECT maxMap(val, cnt)
FROM values('val Array(String), cnt Array(String)', (['A'], ['']), (['B'], ['']));

SELECT sumMap(val, cnt)
FROM values('val Array(UInt64), cnt Array(UInt64)', ([1], [0]), ([2], [0]));

-- check working with arrays and tuples as values
SELECT minMap([1, 1, 1], [[1, 2], [1], [1, 2, 3]]);

SELECT maxMap([1, 1, 1], [[1, 2], [1], [1, 2, 3]]);

SELECT minMap([1, 1, 1], [(1, 2), (1, 1), (1, 3)]);

SELECT maxMap([1, 1, 1], [(1, 2), (1, 1), (1, 3)]);