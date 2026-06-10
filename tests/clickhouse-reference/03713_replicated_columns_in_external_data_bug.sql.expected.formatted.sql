SET enable_analyzer = '1';

SELECT *
FROM remote('127.0.0.{1,2,3}', numbers(100))
WHERE number GLOBAL IN (
        SELECT number::Dynamic
        FROM
            numbers(100)
        ARRAY JOIN range(number % 10)
    )
LIMIT 100
FORMAT Null
SETTINGS enable_lazy_columns_replication = '1';