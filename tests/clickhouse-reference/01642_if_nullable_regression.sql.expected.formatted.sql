SELECT sumIf(dummy, dummy)
FROM remote('127.0.0.{1,2}', view(    SELECT CAST(NULL AS Nullable(UInt8)) AS dummy
    FROM `system`.one));

SELECT sumIf(dummy, 1)
FROM remote('127.0.0.{1,2}', view(    SELECT CAST(NULL AS Nullable(UInt8)) AS dummy
    FROM `system`.one));

-- Before #16610 it returns 0 while with this patch it will return NULL
SELECT sumIf(dummy, dummy)
FROM remote('127.0.0.{1,2}', view(    SELECT CAST(dummy AS Nullable(UInt8)) AS dummy
    FROM `system`.one));

SELECT sumIf(dummy, 1)
FROM remote('127.0.0.{1,2}', view(    SELECT CAST(dummy AS Nullable(UInt8)) AS dummy
    FROM `system`.one));

SELECT sumIf(n, 1)
FROM remote('127.0.0.{1,2}', view(    SELECT CAST(* AS Nullable(UInt8)) AS n
    FROM `system`.numbers
    LIMIT 10));