SET output_format_pretty_fallback_to_vertical = '0';

-- Testing integer formats
SELECT printf('%%d: %d', 123);

SELECT printf('%%d: %d', -123);

SELECT printf('%%d: %d', 0);

SELECT printf('%%d: %d', 9223372036854775807);

SELECT printf('%%i: %i', 123);

SELECT printf('%%u: %u', 123);

SELECT printf('%%o: %o', 123);

SELECT printf('%%x: %x', 123);

-- Testing floating point formats
SELECT printf('%%f: %f', 0.);

SELECT printf('%%f: %f', 123.456);

SELECT printf('%%f: %f', -123.456);

SELECT printf('%%e: %e', 123.456);

SELECT printf('%%g: %g', 123.456);

SELECT printf('%%a: %a', 123.456);

-- Testing character formats
SELECT printf('%%s: %s', 'abc');

SELECT printf('%%s: %s', '\n\t')
FORMAT PrettyCompact;

SELECT printf('%%s: %s', '');

-- Testing the %% specifier
SELECT printf('%%%%: %%');

-- Testing integer formats with precision
SELECT printf('%%.5d: %.5d', 123);

-- Testing floating point formats with precision
SELECT printf('%%.2f: %.2f', 123.456);

SELECT printf('%%.2e: %.2e', 123.456);

SELECT printf('%%.2g: %.2g', 123.456);

-- Testing character formats with precision
SELECT printf('%%.2s: %.2s', 'abc');

SELECT printf('%%X: %X', 123.123); -- { serverError BAD_ARGUMENTS }

SELECT printf('%%A: %A', 'abc'); -- { serverError BAD_ARGUMENTS }

SELECT printf('%%s: %s', 100); -- { serverError BAD_ARGUMENTS }

SELECT printf('%%n: %n', 100); -- { serverError BAD_ARGUMENTS }

SELECT printf('%%f: %f', 0); -- { serverError BAD_ARGUMENTS }