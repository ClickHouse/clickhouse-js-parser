SELECT 1 / CAST(NULL AS Nullable(Decimal(7, 2)));

SELECT materialize(1) / CAST(NULL AS Nullable(Decimal(7, 2)));

SELECT 1 / CAST(materialize(NULL) AS Nullable(Decimal(7, 2)));

SELECT materialize(1) / CAST(materialize(NULL) AS Nullable(Decimal(7, 2)));

SELECT 1 / CAST(1 AS Nullable(Decimal(7, 2)));

SELECT materialize(1) / CAST(1 AS Nullable(Decimal(7, 2)));

SELECT 1 / CAST(materialize(1) AS Nullable(Decimal(7, 2)));

SELECT materialize(1) / CAST(materialize(1) AS Nullable(Decimal(7, 2)));

SELECT intDiv(1, CAST(NULL AS Nullable(Decimal(7, 2))));

SELECT intDiv(materialize(1), CAST(NULL AS Nullable(Decimal(7, 2))));

SELECT intDiv(1, CAST(materialize(NULL) AS Nullable(Decimal(7, 2))));

SELECT intDiv(materialize(1), CAST(materialize(NULL) AS Nullable(Decimal(7, 2))));

SELECT intDiv(1, CAST(1 AS Nullable(Decimal(7, 2))));

SELECT intDiv(materialize(1), CAST(1 AS Nullable(Decimal(7, 2))));

SELECT intDiv(1, CAST(materialize(1) AS Nullable(Decimal(7, 2))));

SELECT intDiv(materialize(1), CAST(materialize(1) AS Nullable(Decimal(7, 2))));

SELECT toDecimal32(1, 2) / CAST(NULL AS Nullable(UInt32));

SELECT materialize(toDecimal32(1, 2)) / CAST(NULL AS Nullable(UInt32));

SELECT toDecimal32(1, 2) / CAST(materialize(NULL) AS Nullable(UInt32));

SELECT materialize(toDecimal32(1, 2)) / CAST(materialize(NULL) AS Nullable(UInt32));

SELECT toDecimal32(1, 2) / CAST(1 AS Nullable(UInt32));

SELECT materialize(toDecimal32(1, 2)) / CAST(1 AS Nullable(UInt32));

SELECT toDecimal32(1, 2) / CAST(materialize(1) AS Nullable(UInt32));

SELECT materialize(toDecimal32(1, 2)) / CAST(materialize(1) AS Nullable(UInt32));

SELECT intDiv(1, CAST(NULL AS Nullable(UInt32)));

SELECT intDiv(materialize(1), CAST(NULL AS Nullable(UInt32)));

SELECT intDiv(1, CAST(materialize(NULL) AS Nullable(UInt32)));

SELECT intDiv(materialize(1), CAST(materialize(NULL) AS Nullable(UInt32)));

SELECT intDiv(1, CAST(1 AS Nullable(UInt32)));

SELECT intDiv(materialize(1), CAST(1 AS Nullable(UInt32)));

SELECT intDiv(1, CAST(materialize(1) AS Nullable(UInt32)));

SELECT intDiv(materialize(1), CAST(materialize(1) AS Nullable(UInt32)));

SELECT 1 % CAST(NULL AS Nullable(UInt32));

SELECT materialize(1) % CAST(NULL AS Nullable(UInt32));

SELECT 1 % CAST(materialize(NULL) AS Nullable(UInt32));

SELECT materialize(1) % CAST(materialize(NULL) AS Nullable(UInt32));

SELECT 1 % CAST(1 AS Nullable(UInt32));

SELECT materialize(1) % CAST(1 AS Nullable(UInt32));

SELECT 1 % CAST(materialize(1) AS Nullable(UInt32));

SELECT materialize(1) % CAST(materialize(1) AS Nullable(UInt32));

SELECT intDiv(1, CAST(NULL AS Nullable(Float32)));

SELECT intDiv(materialize(1), CAST(NULL AS Nullable(Float32)));

SELECT intDiv(1, CAST(materialize(NULL) AS Nullable(Float32)));

SELECT intDiv(materialize(1), CAST(materialize(NULL) AS Nullable(Float32)));

SELECT intDiv(1, CAST(1 AS Nullable(Float32)));

SELECT intDiv(materialize(1), CAST(1 AS Nullable(Float32)));

SELECT intDiv(1, CAST(materialize(1) AS Nullable(Float32)));

SELECT intDiv(materialize(1), CAST(materialize(1) AS Nullable(Float32)));

SELECT 1 % CAST(NULL AS Nullable(Float32));

SELECT materialize(1) % CAST(NULL AS Nullable(Float32));

SELECT 1 % CAST(materialize(NULL) AS Nullable(Float32));

SELECT materialize(1) % CAST(materialize(NULL) AS Nullable(Float32));

SELECT 1 % CAST(1 AS Nullable(Float32));

SELECT materialize(1) % CAST(1 AS Nullable(Float32));

SELECT 1 % CAST(materialize(1) AS Nullable(Float32));

SELECT materialize(1) % CAST(materialize(1) AS Nullable(Float32));

DROP TABLE IF EXISTS nullable_division;

CREATE TABLE nullable_division
(
    x UInt32,
    y Nullable(UInt32),
    a Decimal(7, 2),
    b Nullable(Decimal(7, 2))
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO nullable_division;

SELECT if(y = 0, 0, intDiv(x, y))
FROM nullable_division;

SELECT if(y = 0, 0, x % y)
FROM nullable_division;

SELECT if(y = 0, 0, intDiv(a, y))
FROM nullable_division;

SELECT if(y = 0, 0, a / y)
FROM nullable_division;

SELECT if(b = 0, 0, intDiv(a, b))
FROM nullable_division;

SELECT if(b = 0, 0, a / b)
FROM nullable_division;

SELECT if(b = 0, 0, intDiv(x, b))
FROM nullable_division;

SELECT if(b = 0, 0, x / b)
FROM nullable_division;

DROP TABLE nullable_division;