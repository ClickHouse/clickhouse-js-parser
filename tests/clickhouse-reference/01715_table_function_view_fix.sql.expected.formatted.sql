SELECT sumIf(dummy, dummy)
FROM remote('127.0.0.{1,2}', numbers(2, 100), view(    SELECT CAST(NULL AS Nullable(UInt8)) AS dummy
    FROM `system`.one)); -- { serverError UNKNOWN_FUNCTION }