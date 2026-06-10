SET send_logs_level = 'fatal';

DROP TABLE IF EXISTS map_comb;

CREATE TABLE map_comb
(
    a int,
    statusMap Map(UInt16, UInt32)
)
ENGINE = Log();

INSERT INTO map_comb;

SELECT *
FROM map_comb
ORDER BY
    a ASC,
    statusMap ASC;

SELECT
    toTypeName(res),
    sumMap(statusMap) AS res
FROM map_comb;

SELECT
    toTypeName(res),
    sumWithOverflowMap(statusMap) AS res
FROM map_comb;

SELECT
    toTypeName(res),
    sumMapMerge(s) AS res
FROM (
        SELECT sumMapState(statusMap) AS s
        FROM map_comb
    );

SELECT minMap(statusMap)
FROM map_comb;

SELECT maxMap(statusMap)
FROM map_comb;

SELECT
    toTypeName(res),
    avgMap(statusMap) AS res
FROM map_comb;

SELECT countMap(statusMap)
FROM map_comb;

SELECT
    a,
    sumMap(statusMap)
FROM map_comb
GROUP BY a
ORDER BY a ASC;

DROP TABLE map_comb;

-- check different types
SELECT minMap(val)
FROM values('val Map(UUID, Int32)', map('01234567-89ab-cdef-0123-456789abcdef', 1), map('01234567-89ab-cdef-0123-456789abcdef', 2));

SELECT minMap(val)
FROM values('val Map(String, String)', map('1', '1'), map('1', '2'));

SELECT minMap(val)
FROM values('val Map(FixedString(1), FixedString(1))', map('1', '1'), map('1', '2'));

SELECT minMap(val)
FROM values('val Map(UInt64, UInt64)', map(1, 1), map(1, 2));

SELECT minMap(val)
FROM values('val Map(Date, Int16)', map(1, 1), map(1, 2));

SELECT minMap(val)
FROM values('val Map(DateTime(''Asia/Istanbul''), Int32)', map(1, 1), map(1, 2));

SELECT minMap(val)
FROM values('val Map(Enum16(''a''=1), Int16)', map('a', 1), map('a', 2));

SELECT maxMap(val)
FROM values('val Map(String, String)', map('1', '1'), map('1', '2'));

SELECT minMap(val)
FROM values('val Map(Int128, Int128)', map(1, 1), map(1, 2));

SELECT minMap(val)
FROM values('val Map(Int256, Int256)', map(1, 1), map(1, 2));

SELECT minMap(val)
FROM values('val Map(UInt128, UInt128)', map(1, 1), map(1, 2));

SELECT minMap(val)
FROM values('val Map(UInt256, UInt256)', map(1, 1), map(1, 2));

SELECT sumMap(map(1, 2), 1, 2); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT sumMap(map(1, 2), map(1, 3)); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- array and tuple arguments
SELECT avgMap([1, 1, 1], [2, 2, 2]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT minMap((1, 1)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT minMap(([1, 1, 1], 1)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT minMap([1, 1, 1], 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT minMap([1, 1, 1]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT minMap([1, 1, 1]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

DROP TABLE IF EXISTS sum_map_decimal;

CREATE TABLE sum_map_decimal
(
    statusMap Map(UInt16, Decimal32(5))
)
ENGINE = Log();

INSERT INTO sum_map_decimal;

SELECT sumMap(statusMap)
FROM sum_map_decimal;

SELECT sumWithOverflowMap(statusMap)
FROM sum_map_decimal;

DROP TABLE sum_map_decimal;