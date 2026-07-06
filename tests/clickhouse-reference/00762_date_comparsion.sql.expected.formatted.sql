SET send_logs_level = 'fatal';

SELECT today() < 2018 - 11 - 14; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toDate('2018-01-01') < '2018-11-14';

SELECT toDate('2018-01-01') < '2018-01-01';

SELECT toDate('2018-01-01') = '2018-01-01';

SELECT toDate('2018-01-01') != '2018-01-01';

SELECT toDate('2018-01-01') < toDate('2018-01-01');

SELECT toDate('2018-01-01') = toDate('2018-01-01');

SELECT toDate('2018-01-01') != toDate('2018-01-01');

SELECT toDate('2018-01-01') < 1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toDate('2018-01-01') = 1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toDate('2018-01-01') != 1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }