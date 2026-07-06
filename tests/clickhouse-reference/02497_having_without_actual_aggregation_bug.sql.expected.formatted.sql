SET enable_analyzer = '1';

SELECT number
FROM numbers_mt(10)
HAVING number >= 9;

SELECT count()
FROM numbers_mt(100)
HAVING count() > 1;

SELECT queryID() AS t
FROM numbers(10)
WITH TOTALS
HAVING t = initialQueryID(); -- { serverError NOT_IMPLEMENTED }

SELECT count()
FROM (
        SELECT queryID() AS t
        FROM remote('127.0.0.{1..3}', numbers(10))
        WITH TOTALS
        HAVING t = initialQueryID()
    )
SETTINGS prefer_localhost_replica = '1'; -- { serverError NOT_IMPLEMENTED }