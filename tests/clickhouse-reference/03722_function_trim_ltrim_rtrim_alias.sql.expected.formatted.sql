-- { echoOn }
SELECT
    trimLeft('   leading   '),
    trimLeft('   leading   ');

SELECT
    trimLeft('xxleadingxx', 'x'),
    trimLeft('xxleadingxx', 'x');

SELECT
    trimRight('   trailing   '),
    trimRight('   trailing   ');

SELECT
    trimRight('xxtrailingxx', 'x'),
    trimRight('xxtrailingxx', 'x');

SELECT
    trimBoth('   both   '),
    trimBoth('   both   ');

SELECT
    trimBoth('$$both$$', '$'),
    trimBoth('$$both$$', '$');

SELECT
    trimBoth('$$both$$', '$'),
    trimBoth('$$both$$', '$');

SELECT
    trimLeft('$$both$$', '$'),
    trimLeft('$$both$$', '$');

SELECT
    trimRight('$$both$$', '$'),
    trimRight('$$both$$', '$');

SELECT
    'xx',
    trimBoth('xx', '');

SELECT
    'xx',
    trimLeft('xx', '');

SELECT
    'xx',
    trimRight('xx', '');

SELECT
    trimBoth('$$both$$', concat('$', '$')),
    trimBoth('$$both$$', '$$');

SELECT
    trimLeft('\t  abc', '\t '),
    trimLeft('\t  abc', '\t ');

SELECT
    trimRight('abc\t  ', '\t '),
    trimRight('abc\t  ', '\t ');

SELECT
    trimBoth('  x  '),
    trimBoth('  x  ');

SELECT
    trimLeft('  x  '),
    trimLeft('  x  ');

SELECT
    trimRight('  x  '),
    trimRight('  x  ');