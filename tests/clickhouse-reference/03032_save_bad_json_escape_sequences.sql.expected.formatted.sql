SET input_format_json_throw_on_bad_escape_sequence = '0';

SELECT *
FROM format(JSONEachRow, '\n{"key" : "\\u"}\n{"key" : "\\ud"}\n{"key" : "\\ud8"}\n{"key" : "\\ud80"}\n{"key" : "\\ud800"}\n{"key" : "\\ud800\\"}\n{"key" : "\\ud800\\u"}\n{"key" : "\\ud800\\u1"}\n{"key" : "\\ud800\\u12"}\n{"key" : "\\ud800\\u123"}\n{"key" : "\\ud800\\u1234"}\n');