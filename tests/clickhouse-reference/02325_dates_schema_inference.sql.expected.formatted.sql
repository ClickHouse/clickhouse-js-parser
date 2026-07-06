-- Tags: no-fasttest
SET input_format_try_infer_dates = '1';

SET input_format_try_infer_datetimes = '1';

DESCRIBE TABLE format(JSONEachRow, '{"x" : "2020-01-01"}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : "2020-01-01 00:00:00.00000"}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : "2020-01-01 00:00:00"}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["2020-01-01", "2020-01-02"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["2020-01-01", "2020-01-01 00:00:00"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["2020-01-01 00:00:00", "2020-01-01 00:00:00"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"date1" : "2020-01-01 00:00:00", "date2" : "2020-01-01"}}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["2020-01-01 00:00:00", "2020-01-01"]}\n{"x" : ["2020-01-01"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["2020-01-01 00:00:00"]}\n{"x" : ["2020-01-01"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : "2020-01-01 00:00:00"}\n{"x" : "2020-01-01"}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["2020-01-01 00:00:00", "Some string"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : "2020-01-01 00:00:00"}\n{"x" : "Some string"}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : ["2020-01-01 00:00:00", "2020-01-01"]}\n{"x" : ["2020-01-01", "Some string"]}');

DESCRIBE TABLE format(JSONEachRow, '{"x" : {"key1" : [["2020-01-01 00:00:00"]], "key2" : [["2020-01-01"]]}}\n{"x" : {"key1" : [["2020-01-01"]], "key2" : [["Some string"]]}}');

DESCRIBE TABLE format(CSV, '"2020-01-01"');

DESCRIBE TABLE format(CSV, '"2020-01-01 00:00:00.00000"');

DESCRIBE TABLE format(CSV, '"2020-01-01 00:00:00"');

DESCRIBE TABLE format(CSV, '"[''2020-01-01'', ''2020-01-02'']"');

DESCRIBE TABLE format(CSV, '"[''2020-01-01'', ''2020-01-01 00:00:00'']"');

DESCRIBE TABLE format(CSV, '"[''2020-01-01 00:00:00'', ''2020-01-01 00:00:00'']"');

DESCRIBE TABLE format(CSV, '"{''date1'' : ''2020-01-01 00:00:00'', ''date2'' : ''2020-01-01''}"');

DESCRIBE TABLE format(CSV, '"[''2020-01-01 00:00:00'', ''2020-01-01'']"\n"[''2020-01-01'']"');

DESCRIBE TABLE format(CSV, '"[''2020-01-01 00:00:00'']"\n"[''2020-01-01'']"');

DESCRIBE TABLE format(CSV, '"2020-01-01 00:00:00"\n"2020-01-01"');

DESCRIBE TABLE format(CSV, '"[''2020-01-01 00:00:00'', ''Some string'']"');

DESCRIBE TABLE format(CSV, '"2020-01-01 00:00:00"\n"Some string"');

DESCRIBE TABLE format(CSV, '"[''2020-01-01 00:00:00'', ''2020-01-01'']"\n"[''2020-01-01'', ''Some string'']"');

DESCRIBE TABLE format(CSV, '"{''key1'' : [[''2020-01-01 00:00:00'']], ''key2'' : [[''2020-01-01'']]}"\n"{''key1'' : [[''2020-01-01'']], ''key2'' : [[''Some string'']]}"');

DESCRIBE TABLE format(TSV, '2020-01-01');

DESCRIBE TABLE format(TSV, '2020-01-01 00:00:00.00000');

DESCRIBE TABLE format(TSV, '2020-01-01 00:00:00');

DESCRIBE TABLE format(TSV, '[''2020-01-01'', ''2020-01-02'']');

DESCRIBE TABLE format(TSV, '[''2020-01-01'', ''2020-01-01 00:00:00'']');

DESCRIBE TABLE format(TSV, '[''2020-01-01 00:00:00'', ''2020-01-01 00:00:00'']');

DESCRIBE TABLE format(TSV, '{''date1'' : ''2020-01-01 00:00:00'', ''date2'' : ''2020-01-01''}');

DESCRIBE TABLE format(TSV, '[''2020-01-01 00:00:00'', ''2020-01-01'']\n[''2020-01-01'']');

DESCRIBE TABLE format(TSV, '[''2020-01-01 00:00:00'']\n[''2020-01-01'']');

DESCRIBE TABLE format(TSV, '2020-01-01 00:00:00\n2020-01-01');

DESCRIBE TABLE format(TSV, '[''2020-01-01 00:00:00'', ''Some string'']');

DESCRIBE TABLE format(TSV, '2020-01-01 00:00:00\nSome string');

DESCRIBE TABLE format(TSV, '[''2020-01-01 00:00:00'', ''2020-01-01'']\n[''2020-01-01'', ''Some string'']');

DESCRIBE TABLE format(TSV, '{''key1'' : [[''2020-01-01 00:00:00'']], ''key2'' : [[''2020-01-01'']]}\n{''key1'' : [[''2020-01-01'']], ''key2'' : [[''Some string'']]}');

DESCRIBE TABLE format(Values, '(''2020-01-01'')');

DESCRIBE TABLE format(Values, '(''2020-01-01 00:00:00.00000'')');

DESCRIBE TABLE format(Values, '(''2020-01-01 00:00:00'')');

DESCRIBE TABLE format(Values, '([''2020-01-01'', ''2020-01-02''])');

DESCRIBE TABLE format(Values, '([''2020-01-01'', ''2020-01-01 00:00:00''])');

DESCRIBE TABLE format(Values, '([''2020-01-01 00:00:00'', ''2020-01-01 00:00:00''])');

DESCRIBE TABLE format(Values, '({''date1'' : ''2020-01-01 00:00:00'', ''date2'' : ''2020-01-01''})');

DESCRIBE TABLE format(Values, '([''2020-01-01 00:00:00'', ''2020-01-01''])\n([''2020-01-01''])');

DESCRIBE TABLE format(Values, '([''2020-01-01 00:00:00'']), ([''2020-01-01''])');

DESCRIBE TABLE format(Values, '(''2020-01-01 00:00:00'')\n(''2020-01-01'')');

DESCRIBE TABLE format(Values, '([''2020-01-01 00:00:00'', ''Some string''])');

DESCRIBE TABLE format(Values, '(''2020-01-01 00:00:00'')\n(''Some string'')');

DESCRIBE TABLE format(Values, '([''2020-01-01 00:00:00'', ''2020-01-01''])\n([''2020-01-01'', ''Some string''])');

DESCRIBE TABLE format(Values, '({''key1'' : [[''2020-01-01 00:00:00'']], ''key2'' : [[''2020-01-01'']]})\n({''key1'' : [[''2020-01-01'']], ''key2'' : [[''Some string'']]})');