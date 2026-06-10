SELECT singleValueOrNull(toNullable(''));

SELECT singleValueOrNull(toNullable('Hello'));

SELECT singleValueOrNull((
        SELECT 'Hello'
    ));

SELECT singleValueOrNull(toNullable(123));

SELECT '' IN (
        SELECT singleValueOrNull(*)
        FROM (
                SELECT toNullable('')
            )
    );

SELECT
    '',
    ['\0'],
    [],
    singleValueOrNull((
        SELECT '\0'
    )),
    [''];