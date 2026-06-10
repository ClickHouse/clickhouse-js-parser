SET short_circuit_function_evaluation = 'enable';

SET convert_query_to_cnf = '0';

SELECT if(number > 0, intDiv(number + 100, number), throwIf(number))
FROM numbers(10);

SELECT multiIf(number = 0, 0, number = 1, intDiv(1, number), number = 2, intDiv(1, number - 1), number = 3, intDiv(1, number - 2), intDiv(1, number - 3))
FROM numbers(10);

SELECT number != 0
    AND intDiv(1, number) = 0
    AND number != 2
    AND intDiv(1, number - 2) = 0
FROM numbers(10);

SELECT number = 0
    OR intDiv(1, number) != 0
    OR number = 2
    OR intDiv(1, number - 2) != 0
FROM numbers(10);

SELECT count()
FROM (
        SELECT if(number >= 0, number, sleep(1))
        FROM numbers(10000000)
    );

SELECT if(number % 5 = 0, toInt8OrZero(toString(number)), toInt8OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toInt8OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toInt8OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toInt8OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt8OrZero(toString(number)), toUInt8OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt8OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toUInt8OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toUInt8OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toInt32OrZero(toString(number)), toInt32OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toInt32OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toInt32OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toInt32OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt32OrZero(toString(number)), toUInt32OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt32OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toUInt32OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toUInt32OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toInt64OrZero(toString(number)), toInt64OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toInt64OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toInt64OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toInt64OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt64OrZero(toString(number)), toUInt64OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt64OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toUInt64OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toUInt64OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toInt128OrZero(toString(number)), toInt128OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toInt128OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toInt128OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toInt128OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt128OrZero(toString(number)), toUInt128OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt128OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toUInt128OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toUInt128OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toInt256OrZero(toString(number)), toInt256OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toInt256OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toInt256OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toInt256OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt256OrZero(toString(number)), toUInt256OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toUInt256OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toUInt256OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toUInt256OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toFloat32OrZero(toString(number)), toFloat32OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toFloat32OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toFloat32OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toFloat32OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toFloat64OrZero(toString(number)), toFloat64OrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toFloat64OrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toFloat64OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toFloat64OrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, repeat(toString(number), 2), repeat(toString(number + 1), 2))
FROM numbers(20);

SELECT if(number % 5 = 0, repeat(toString(number), 2), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, repeat(toString(number), 2))
FROM numbers(20);

SELECT if(number % 5, NULL, repeat(toString(number), 2))
FROM numbers(20);

SELECT if(number % 5 = 0, toFixedString(toString(number + 10), 2), toFixedString(toString(number + 11), 2))
FROM numbers(20);

SELECT if(number % 5 = 0, toFixedString(toString(number + 10), 2), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toFixedString(toString(number + 10), 2))
FROM numbers(20);

SELECT if(number % 5, NULL, toFixedString(toString(number + 10), 2))
FROM numbers(20);

SELECT if(number % 5 = 0, toDateOrZero(toString(number)), toDateOrZero(toString(number + 1)))
FROM numbers(20);

SELECT if(number % 5 = 0, toDateOrZero(toString(number)), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toDateOrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5, NULL, toDateOrZero(toString(number)))
FROM numbers(20);

SELECT if(number % 5 = 0, toDateTimeOrZero(toString(number * 10000), 'UTC'), toDateTimeOrZero(toString((number + 1) * 10000), 'UTC'))
FROM numbers(20);

SELECT if(number % 5 = 0, toDateTimeOrZero(toString(number * 10000), 'UTC'), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toDateTimeOrZero(toString(number * 10000), 'UTC'))
FROM numbers(20);

SELECT if(number % 5, NULL, toDateTimeOrZero(toString(number * 10000), 'UTC'))
FROM numbers(20);

SELECT if(number % 5 = 0, toDecimal32OrZero(toString(number), 5), toDecimal32OrZero(toString(number + 1), 5))
FROM numbers(20);

SELECT if(number % 5 = 0, toDecimal32OrZero(toString(number), 5), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toDecimal32OrZero(toString(number), 5))
FROM numbers(20);

SELECT if(number % 5, NULL, toDecimal32OrZero(toString(number), 5))
FROM numbers(20);

SELECT if(number % 5 = 0, toDecimal64OrZero(toString(number), 5), toDecimal64OrZero(toString(number + 1), 5))
FROM numbers(20);

SELECT if(number % 5 = 0, toDecimal64OrZero(toString(number), 5), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toDecimal64OrZero(toString(number), 5))
FROM numbers(20);

SELECT if(number % 5, NULL, toDecimal64OrZero(toString(number), 5))
FROM numbers(20);

SELECT if(number % 5 = 0, toDecimal128OrZero(toString(number), 5), toDecimal128OrZero(toString(number + 1), 5))
FROM numbers(20);

SELECT if(number % 5 = 0, toDecimal128OrZero(toString(number), 5), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toDecimal128OrZero(toString(number), 5))
FROM numbers(20);

SELECT if(number % 5, NULL, toDecimal128OrZero(toString(number), 5))
FROM numbers(20);

SELECT if(number % 5 = 0, toDecimal256OrZero(toString(number), 5), toDecimal256OrZero(toString(number + 1), 5))
FROM numbers(20);

SELECT if(number % 5 = 0, toDecimal256OrZero(toString(number), 5), NULL)
FROM numbers(20);

SELECT if(number % 5 = 0, NULL, toDecimal256OrZero(toString(number), 5))
FROM numbers(20);

SELECT if(number % 5, NULL, toDecimal256OrZero(toString(number), 5))
FROM numbers(20);

SELECT if(number % 5 = 0, range(number), range(number + 1))
FROM numbers(20);

SELECT if(number % 5 = 0, replicate(toString(number), range(number)), replicate(toString(number), range(number + 1)))
FROM numbers(20);

SELECT number > 0
    AND 5
    AND intDiv(100, number)
FROM numbers(5);

SELECT number > 0
    AND NULL
    AND intDiv(100, number)
FROM numbers(5);

SELECT number = 0
    OR 5
    OR intDiv(100, number)
FROM numbers(5);

SELECT multiIf(number % 2 != 0, intDiv(10, number % 2), 5, intDiv(10, 1 - number % 2), intDiv(10, number))
FROM numbers(5);

SELECT if(number != 0, 5 * (1 + intDiv(100, number)), toInt32(exp(log(throwIf(number) + 10))))
FROM numbers(5);

SELECT if(number % 2, 5 * (1 + intDiv(100, number + 1)), 3 + 10 * intDiv(100, intDiv(100, number + 1)))
FROM numbers(10);

SELECT sum(number)
FROM numbers(10)
WHERE number != 0
    AND 3 % number
    AND number != 1
    AND intDiv(1, number - 1) > 0;

SELECT multiIf(0, 1, intDiv(number % 2, 1), 2, 0, 3, 1, number + 10, 2)
FROM numbers(10);

SELECT toTypeName(toString(number))
FROM numbers(5);

SELECT toColumnTypeName(toString(number))
FROM numbers(5);

SELECT toTypeName(toInt64OrZero(toString(number)))
FROM numbers(5);

SELECT toColumnTypeName(toInt64OrZero(toString(number)))
FROM numbers(5);

SELECT toTypeName(toDecimal32OrZero(toString(number), 5))
FROM numbers(5);

SELECT toColumnTypeName(toDecimal32OrZero(toString(number), 5))
FROM numbers(5);

SELECT if(if(number > 0, intDiv(42, number), 0), intDiv(42, number), 8)
FROM numbers(5);

SELECT
    if(number > 0, intDiv(42, number), 0),
    if(number = 0, 0, intDiv(42, number))
FROM numbers(5);

SELECT NULL
    OR isNull(intDiv(number, 1))
FROM numbers(5);

SET compile_expressions = '1';

SELECT if(number > 0, intDiv(42, number), 1)
FROM numbers(5);

SELECT if(number > 0, 42 / toDecimal32(number, 2), 0)
FROM numbers(5);

SELECT if(number = 0, 0, toDecimal32(42, 2) / number)
FROM numbers(5);

SELECT if(isNull(x), NULL, 42 / x)
FROM (
        SELECT CAST(materialize(NULL) AS Nullable(Decimal32(2))) AS x
    );

SELECT if(isNull(x), NULL, x / 0)
FROM (
        SELECT CAST(materialize(NULL) AS Nullable(Decimal32(2))) AS x
    );

SELECT if(isNull(x), NULL, intDiv(42, x))
FROM (
        SELECT CAST(materialize(NULL) AS Nullable(Int64)) AS x
    );

SELECT number % 2
    AND toLowCardinality(number)
FROM numbers(5);

SELECT number % 2
    OR toLowCardinality(number)
FROM numbers(5);

SELECT if(toLowCardinality(number) % 2, number, number + 1)
FROM numbers(10);

SELECT multiIf(toLowCardinality(number) % 2, number, number + 1)
FROM numbers(10);