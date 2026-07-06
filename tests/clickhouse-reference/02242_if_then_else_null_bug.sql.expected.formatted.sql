SELECT if(materialize(1) > 0, CAST(NULL AS Nullable(Int64)), materialize(toInt32(1)));

SELECT if(materialize(1) > 0, materialize(toInt32(1)), CAST(NULL AS Nullable(Int64)));

SELECT if(materialize(1) > 0, CAST(NULL AS Nullable(Decimal(18, 4))), materialize(CAST(2 AS Nullable(Decimal(9, 4)))));

SELECT if(materialize(1) > 0, materialize(CAST(2 AS Nullable(Decimal(9, 4)))), CAST(NULL AS Nullable(Decimal(18, 4))));