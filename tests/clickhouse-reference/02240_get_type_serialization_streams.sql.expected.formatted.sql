SELECT getTypeSerializationStreams('Array(Int8)');

SELECT getTypeSerializationStreams('Map(String, Int64)');

SELECT getTypeSerializationStreams('Tuple(String, Int64, Float64)');

SELECT getTypeSerializationStreams('LowCardinality(String)');

SELECT getTypeSerializationStreams('Nullable(String)');

SELECT getTypeSerializationStreams([1, 2, 3]);

SELECT getTypeSerializationStreams(map('a', 1, 'b', 2));

SELECT getTypeSerializationStreams(tuple('a', 1, 'b', 2));