SELECT CAST(materialize(CAST(NULL AS Nullable(Enum('A' = 1, 'B' = 2)))) AS Nullable(String));

SELECT CAST(CAST(NULL AS Nullable(Enum('A' = 1, 'B' = 2))) AS Nullable(String));

SELECT CAST(materialize(CAST(1 AS Nullable(Enum('A' = 1, 'B' = 2)))) AS Nullable(String));

SELECT CAST(CAST(1 AS Nullable(Enum('A' = 1, 'B' = 2))) AS Nullable(String));