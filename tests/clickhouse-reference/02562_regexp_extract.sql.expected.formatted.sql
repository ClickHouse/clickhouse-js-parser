-- { echoOn }
SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', 1);

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)');

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', 2);

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', 0);

SELECT regexpExtract('100-200', '(\\d+).*', 1);

SELECT regexpExtract('100-200', '([a-z])', 1);

SELECT regexpExtract(NULL, '([a-z])', 1);

SELECT regexpExtract('100-200', NULL, 1);

SELECT regexpExtract('100-200', '([a-z])', NULL);

SELECT REGEXP_EXTRACT('100-200', '(\\d+)-(\\d+)', 1);

SELECT REGEXP_EXTRACT('100-200', '(\\d+)-(\\d+)');

SELECT REGEXP_EXTRACT('100-200', '(\\d+)-(\\d+)', 0);

SELECT regexpExtract('0123456789', '(\\d+)(\\d+)', 0);

SELECT regexpExtract('0123456789', '(\\d+)(\\d+)', 1);

SELECT regexpExtract('0123456789', '(\\d+)(\\d+)', 2);

SELECT regexpExtract(materialize('100-200'), '(\\d+)-(\\d+)');

SELECT regexpExtract(materialize('100-200'), '(\\d+)-(\\d+)', 1);

SELECT regexpExtract(materialize('100-200'), '(\\d+)-(\\d+)', 2);

SELECT regexpExtract(materialize('100-200'), '(\\d+).*', 1);

SELECT regexpExtract(materialize('100-200'), '([a-z])', 1);

SELECT regexpExtract(materialize(NULL), '([a-z])', 1);

SELECT regexpExtract(materialize('100-200'), NULL, 1);

SELECT regexpExtract(materialize('100-200'), '([a-z])', NULL);

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', materialize(1));

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', materialize(2));

SELECT regexpExtract('100-200', '(\\d+).*', materialize(1));

SELECT regexpExtract('100-200', '([a-z])', materialize(1));

SELECT regexpExtract(NULL, '([a-z])', materialize(1));

SELECT regexpExtract('100-200', NULL, materialize(1));

SELECT regexpExtract('100-200', '([a-z])', materialize(NULL));

SELECT regexpExtract(materialize('100-200'), '(\\d+)-(\\d+)', materialize(1));

SELECT regexpExtract(materialize('100-200'), '(\\d+)-(\\d+)', materialize(2));

SELECT regexpExtract(materialize('100-200'), '(\\d+).*', materialize(1));

SELECT regexpExtract(materialize('100-200'), '([a-z])', materialize(1));

SELECT regexpExtract(materialize(NULL), '([a-z])', materialize(1));

SELECT regexpExtract(materialize('100-200'), NULL, materialize(1));

SELECT regexpExtract(materialize('100-200'), '([a-z])', materialize(NULL));

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', number)
FROM numbers(3);

SELECT regexpExtract(materialize('100-200'), '(\\d+)-(\\d+)', number)
FROM numbers(3);

SELECT regexpExtract(number::String || '-' || (2 * number)::String, '(\\d+)-(\\d+)', 1)
FROM numbers(3);

SELECT regexpExtract(number::String || '-' || (2 * number)::String, '(\\d+)-(\\d+)', number % 3)
FROM numbers(5);

SELECT regexpExtract('100-200100-200', '(\\d+)-(\\d+)(\\d+)-(\\d+)', materialize(3));

SELECT regexpExtract('100-200'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', 1, 2); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT regexpExtract(CAST('100-200' AS FixedString(10)), '(\\d+)-(\\d+)', 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT regexpExtract('100-200', CAST('(\\d+)-(\\d+)' AS FixedString(20)), 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', 'a'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT regexpExtract(100, '(\\d+)-(\\d+)', 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT regexpExtract('100-200', 1, 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT regexpExtract('100-200', materialize('(\\d+)-(\\d+)'), 1); -- { serverError ILLEGAL_COLUMN }

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', 3); -- { serverError INDEX_OF_POSITIONAL_ARGUMENT_IS_OUT_OF_RANGE }

SELECT regexpExtract('100-200', '(\\d+)-(\\d+)', -1); -- { serverError INDEX_OF_POSITIONAL_ARGUMENT_IS_OUT_OF_RANGE }

SELECT regexpExtract('100-200', '\\d+-\\d+', 0);

SELECT regexpExtract('100-200', '\\d+-\\d+', 1); -- { serverError INDEX_OF_POSITIONAL_ARGUMENT_IS_OUT_OF_RANGE }
-- { echoOff }