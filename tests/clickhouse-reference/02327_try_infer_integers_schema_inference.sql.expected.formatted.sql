-- Tags: no-fasttest
SET input_format_try_infer_integers = '1';

SET input_format_try_infer_exponent_floats = '1';

DESCRIBE TABLE format(JSONEachRow, '{"x" : 123}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [123, 123]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"a" : [123, 123]}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"a" : [123, 123]}}\n{"x" : {"b" : [321, 321]}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : 123}\n{"x" : 123.123}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : 123}\n{"x" : 1e2}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : [123, 123]}\n{"x" : [321.321, 312]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"a" : [123, 123]}}\n{"x" : {"b" : [321.321, 123]}}');

DESCRIBE TABLE format(CSV, '123');

DESCRIBE TABLE format(CSV, '"[123, 123]"');

DESCRIBE TABLE format(CSV, '"{''a'' : [123, 123]}"');

DESCRIBE TABLE format(CSV, '"{''a'' : [123, 123]}"\n"{''b'' : [321, 321]}"');

DESCRIBE TABLE format(CSV, '123\n123.123');

DESCRIBE TABLE format(CSV, '122\n1e2');

DESCRIBE TABLE format(CSV, '"[123, 123]"\n"[321.321, 312]"');

DESCRIBE TABLE format(CSV, '"{''a'' : [123, 123]}"\n"{''b'' : [321.321, 123]}"');

DESCRIBE TABLE format(TSV, '123');

DESCRIBE TABLE format(TSV, '[123, 123]');

DESCRIBE TABLE format(TSV, '{''a'' : [123, 123]}');

DESCRIBE TABLE format(TSV, '{''a'' : [123, 123]}\n{''b'' : [321, 321]}');

DESCRIBE TABLE format(TSV, '123\n123.123');

DESCRIBE TABLE format(TSV, '122\n1e2');

DESCRIBE TABLE format(TSV, '[123, 123]\n[321.321, 312]');

DESCRIBE TABLE format(TSV, '{''a'' : [123, 123]}\n{''b'' : [321.321, 123]}');

DESCRIBE TABLE format(Values, '(123)');

DESCRIBE TABLE format(Values, '([123, 123])');

DESCRIBE TABLE format(Values, '({''a'' : [123, 123]})');

DESCRIBE TABLE format(Values, '({''a'' : [123, 123]}), ({''b'' : [321, 321]})');

DESCRIBE TABLE format(Values, '(123), (123.123)');

DESCRIBE TABLE format(Values, '(122), (1e2)');

DESCRIBE TABLE format(Values, '([123, 123])\n([321.321, 312])');

DESCRIBE TABLE format(Values, '({''a'' : [123, 123]}), ({''b'' : [321.321, 123]})');