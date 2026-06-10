SET send_logs_level = 'fatal';

SELECT lcase('FOO');

SELECT ucase('foo');

SELECT LOWER('Foo');

SELECT UPPER('Foo');

SELECT REPLACE('bar', 'r', 'z');

SELECT REGEXP_REPLACE('bar', '.', 'z');

SELECT substring('foo', 1, 2);

SELECT Substr('foo', 2);

SELECT mid('foo', 3);

SELECT IF(3 > 2, 1, 0);

SELECT substring('foo', 1 + 1);

SELECT substring('foo', 2, 1);

SELECT left('foo', 2);

SELECT LEFT('foo', 123);

SELECT RIGHT('bar', 1);

SELECT right('bar', 123);

SELECT trimLeft('') || trimRight('') || trimBoth('');

SELECT trimLeft('   foo');

SELECT trimRight('   foo   ');

SELECT trimRight('xxfooxx', 'x');

SELECT trimLeft('abbafooabba', 'ab');

SELECT trimBoth('abbafooabbafooabba', 'ab');

SELECT trimLeft('\\|[[[}}}*foo*', '*[]{}|\\');

SELECT dateDiff('month', toDate('2018-12-18'), toDate('2018-01-01'));

SELECT dateDiff('quarter', toDate('2018-12-18'), toDate('2018-01-01'));

SELECT plus(toDate('2018-01-01'), toIntervalYear(3));

SELECT minus(toDateTime('2018-12-18 01:02:03'), toIntervalMonth(5));

SELECT plus(toDate('2018-01-01'), toIntervalMonth(3));