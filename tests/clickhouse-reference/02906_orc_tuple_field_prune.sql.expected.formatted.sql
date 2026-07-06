-- Tags: no-fasttest
SET engine_file_truncate_on_insert = '1';

SET flatten_nested = '0';

INSERT INTO FUNCTION file(currentDatabase() || '_02906.orc', 'ORC') SELECT
    number::Int64 AS int64_column,
    number::String AS string_column,
    number::Float64 AS float64_column,
    CAST(if(number % 10 = 0, tuple(NULL, NULL, NULL), tuple(number::String, number::Float64, number::Int64)) AS Tuple(a Nullable(String), b Nullable(Float64), c Nullable(Int64))) AS tuple_column,
    CAST(if(number % 10 = 0, array(tuple(NULL, NULL, NULL)), array(tuple(number::String, number::Float64, number::Int64))) AS Array(Tuple(a Nullable(String), b Nullable(Float64), c Nullable(Int64)))) AS array_tuple_column,
    CAST(if(number % 10 = 0, map(number::String, tuple(NULL, NULL, NULL)), map(number::String, tuple(number::String, number::Float64, number::Int64))) AS Map(String, Tuple(a Nullable(String), b Nullable(Float64), c Nullable(Int64)))) AS map_tuple_column
FROM numbers(100);

DESCRIBE TABLE file(currentDatabase() || '_02906.orc');

-- { echoOn }
-- Test primitive types
SELECT
    int64_column,
    string_column,
    float64_column
FROM file(currentDatabase() || '_02906.orc')
WHERE int64_column % 15 = 0;

-- Test tuple type with names
SELECT tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, tuple_column Tuple(a Nullable(String), b Nullable(Float64), c Nullable(Int64))')
WHERE int64_column % 15 = 0;

SELECT tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, tuple_column Tuple(c Nullable(Int64))')
WHERE int64_column % 15 = 0;

SELECT tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, tuple_column Tuple(c Nullable(Int64), d Nullable(String))')
WHERE int64_column % 15 = 0;

-- Test tuple type without names
SELECT tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, tuple_column Tuple(Nullable(String), Nullable(Float64), Nullable(Int64))')
WHERE int64_column % 15 = 0;

SELECT tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, tuple_column Tuple(Nullable(String), Nullable(Float64))')
WHERE int64_column % 15 = 0;

-- Test tuple nested in array
SELECT array_tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, array_tuple_column Array(Tuple(a Nullable(String), b Nullable(Float64), c Nullable(Int64)))')
WHERE int64_column % 15 = 0;

SELECT array_tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, array_tuple_column Array(Tuple(b Nullable(Float64), c Nullable(Int64)))')
WHERE int64_column % 15 = 0;

SELECT array_tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, array_tuple_column Array(Tuple(b Nullable(Float64), c Nullable(Int64), d Nullable(String)))')
WHERE int64_column % 15 = 0;

-- Test tuple nested in map
SELECT map_tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, map_tuple_column Map(String, Tuple(a Nullable(String), b Nullable(Float64), c Nullable(Int64)))')
WHERE int64_column % 15 = 0;

SELECT map_tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, map_tuple_column Map(String, Tuple(b Nullable(Float64), c Nullable(Int64)))')
WHERE int64_column % 15 = 0;

SELECT map_tuple_column
FROM file(currentDatabase() || '_02906.orc', 'ORC', 'int64_column Int64, map_tuple_column Map(String, Tuple(b Nullable(Float64), c Nullable(Int64), d Nullable(String)))')
WHERE int64_column % 15 = 0; -- { echoOff }