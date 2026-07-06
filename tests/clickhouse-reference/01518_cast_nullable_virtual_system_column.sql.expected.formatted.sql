-- NOTE: database = currentDatabase() is not mandatory
SELECT database
FROM `system`.tables
WHERE database LIKE '%'
FORMAT Null;

SELECT database AS db
FROM `system`.tables
WHERE db LIKE '%'
FORMAT Null;

SELECT CAST(database AS String) AS db
FROM `system`.tables
WHERE db LIKE '%'
FORMAT Null;

SELECT CAST('a string' AS Nullable(String)) AS str
WHERE str LIKE '%'
FORMAT Null;

SELECT CAST(database AS Nullable(String)) AS ndb
FROM `system`.tables
WHERE ndb LIKE '%'
FORMAT Null;