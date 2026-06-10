SET transform_null_in = '1';

SELECT NULL::Nullable(String) IN (
        SELECT 'abc'
    );

SELECT (NULL::Nullable(String), 42) IN (
        SELECT
            'abc',
            42
    );

SELECT (NULL::Nullable(String), NULL::Nullable(UInt32)) IN (
        SELECT
            'abc',
            42
    );

SELECT (number % 2 ? NULL : 'abc') IN (
        SELECT 'abc'
    )
FROM numbers(2);

SELECT (number % 2 ? NULL : 'abc', materialize(42)) IN (
        SELECT
            'abc',
            42
    )
FROM numbers(2);

SELECT (number % 2 = 0 ? NULL : 'abc', number < 2 ? NULL : 42) IN (
        SELECT
            'abc',
            42
    )
FROM numbers(4);