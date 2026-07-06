-- Test that the string hash map works properly with keys containing zero
-- bytes.
-- Keys with no central '1' are mostly duplicates. The unique keys
-- in this group are '', '\0', ...., '\0 x 34', to a total of 35. All other
-- keys are unique.
SELECT count(*) = 18 * 18 * 17 + 35
FROM (
        SELECT key
        FROM (
                WITH 18 AS n

                SELECT repeat('\0', number % n) || repeat('1', intDiv(number, n) % n) || repeat('\0', intDiv(number, n * n) % n) AS key
                FROM numbers(18 * 18 * 18)
            )
        GROUP BY key
    );