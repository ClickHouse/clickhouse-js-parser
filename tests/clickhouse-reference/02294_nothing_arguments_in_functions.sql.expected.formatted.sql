SET enable_named_columns_in_function_tuple = '0';

SELECT arrayMap((x -> 2 * x), []);

SELECT toTypeName(arrayMap((x -> 2 * x), []));

SELECT arrayMap(((x, y) -> x + y), [], []);

SELECT toTypeName(arrayMap(((x, y) -> x + y), [], []));

SELECT arrayMap(((x, y) -> x + y), [], CAST([] AS Array(Int32)));

SELECT toTypeName(arrayMap(((x, y) -> x + y), [], CAST([] AS Array(Int32))));

SELECT arrayFilter((x -> 2 * x < 0), []);

SELECT toTypeName(arrayFilter((x -> 2 * x < 0), []));

SELECT toTypeName(arrayMap((x -> CAST(x AS String)), []));

SELECT toTypeName(arrayMap((x -> toInt32(x)), []));

SELECT toColumnTypeName(arrayMap((x -> toInt32(x)), []));

SELECT toTypeName(arrayMap((x -> [x]), []));

SELECT toColumnTypeName(arrayMap((x -> [x]), []));

SELECT toTypeName(arrayMap((x -> map(1, x)), []));

SELECT toColumnTypeName(arrayMap((x -> map(1, x)), []));

SELECT toTypeName(arrayMap((x -> tuple(x)), []));

SELECT toColumnTypeName(arrayMap((x -> tuple(1, x)), []));

SELECT toTypeName(toInt32(assumeNotNull(materialize(NULL))));

SELECT toColumnTypeName(toInt32(assumeNotNull(materialize(NULL))));

SELECT toTypeName(assumeNotNull(materialize(NULL)));

SELECT toColumnTypeName(assumeNotNull(materialize(NULL)));

SELECT toTypeName([assumeNotNull(materialize(NULL))]);

SELECT toColumnTypeName([assumeNotNull(materialize(NULL))]);

SELECT toTypeName(map(1, assumeNotNull(materialize(NULL))));

SELECT toColumnTypeName(map(1, assumeNotNull(materialize(NULL))));

SELECT toTypeName(tuple(1, assumeNotNull(materialize(NULL))));

SELECT toColumnTypeName(tuple(1, assumeNotNull(materialize(NULL))));

SELECT toTypeName(assumeNotNull(materialize(NULL)) * 2);

SELECT toColumnTypeName(assumeNotNull(materialize(NULL)) * 2);