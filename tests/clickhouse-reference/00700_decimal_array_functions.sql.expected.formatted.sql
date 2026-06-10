SELECT
    arrayDifference([toDecimal32(0., 4), toDecimal32(1., 4)]) AS x,
    toTypeName(x);

SELECT
    arrayDifference([toDecimal64(0., 8), toDecimal64(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arrayDifference([toDecimal128(0., 8), toDecimal128(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arraySum([toDecimal32(0., 4), toDecimal32(1., 4)]) AS x,
    toTypeName(x);

SELECT
    arraySum([toDecimal64(0., 8), toDecimal64(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arraySum([toDecimal128(0., 8), toDecimal128(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arrayCumSum([toDecimal32(1., 4), toDecimal32(1., 4)]) AS x,
    toTypeName(x);

SELECT
    arrayCumSum([toDecimal64(1., 8), toDecimal64(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arrayCumSum([toDecimal128(1., 8), toDecimal128(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arrayCumSumNonNegative([toDecimal32(1., 4), toDecimal32(1., 4)]) AS x,
    toTypeName(x);

SELECT
    arrayCumSumNonNegative([toDecimal64(1., 8), toDecimal64(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arrayCumSumNonNegative([toDecimal128(1., 8), toDecimal128(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arrayCompact([toDecimal32(1., 4), toDecimal32(1., 4)]) AS x,
    toTypeName(x);

SELECT
    arrayCompact([toDecimal64(1., 8), toDecimal64(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arrayCompact([toDecimal128(1., 8), toDecimal128(1., 8)]) AS x,
    toTypeName(x);

SELECT
    arrayRemove([toDecimal32(1., 4), toDecimal32(2., 4), toDecimal32(3., 4)], toDecimal32(1., 4)) AS x,
    toTypeName(x);

SELECT
    arrayRemove([toDecimal64(1., 8), toDecimal64(2., 8), toDecimal64(3., 8)], toDecimal64(1., 8)) AS x,
    toTypeName(x);

SELECT
    arrayRemove([toDecimal128(1., 8), toDecimal128(2., 8), toDecimal128(3., 8)], toDecimal128(1., 8)) AS x,
    toTypeName(x);