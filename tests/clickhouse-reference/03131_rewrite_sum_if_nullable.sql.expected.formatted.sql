-- https://github.com/ClickHouse/ClickHouse/issues/62890
-- { echoOn }
SELECT sum(if(materialize(0), toNullable(1), 0));

SELECT sum(if(materialize(0), toNullable(1), materialize(0)));

SELECT sum(if(materialize(0), materialize(toNullable(1)), materialize(0)));

SELECT sum(if(materialize(0), materialize(1), materialize(0)));

SELECT sum(if(dummy, 0, toNullable(0)));

SELECT sum(if(dummy, materialize(0), toNullable(0)));

SELECT sum(if(dummy, materialize(0), materialize(toNullable(0))));

SELECT sum(if(s = '', v, 0)) AS b
FROM VALUES('v Nullable(Int64), s String', (1, 'x'));

SELECT sumOrNull(if(materialize(0), toNullable(1), 0));

SELECT sumOrNull(if(materialize(0), 1, 0));

SELECT sum(if(materialize(0), toNullable(1), 0))
SETTINGS aggregate_functions_null_for_empty = '1';

SELECT sum(if(materialize(0), 1, 0))
SETTINGS aggregate_functions_null_for_empty = '1';

SELECT sumOrNull(if(materialize(1), toNullable(1), 10));

SELECT sumOrNull(if(materialize(1), 1, 10));

SELECT sum(if(materialize(1), toNullable(1), 10))
SETTINGS aggregate_functions_null_for_empty = '1';

SELECT sum(if(materialize(1), 1, 10))
SETTINGS aggregate_functions_null_for_empty = '1';