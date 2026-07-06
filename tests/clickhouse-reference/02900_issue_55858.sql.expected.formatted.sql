SET precise_float_parsing = '1';

SELECT CAST('2023-01-01' AS Float64); -- { serverError CANNOT_PARSE_TEXT }

SELECT CAST('2023-01-01' AS Float32); -- { serverError CANNOT_PARSE_TEXT }

SELECT toFloat32('2023-01-01'); -- { serverError CANNOT_PARSE_TEXT }

SELECT toFloat64('2023-01-01'); -- { serverError CANNOT_PARSE_TEXT }

SELECT toFloat32OrZero('2023-01-01');

SELECT toFloat64OrZero('2023-01-01');

SELECT toFloat32OrNull('2023-01-01');

SELECT toFloat64OrNull('2023-01-01');