DESCRIBE TABLE format(CSV, '1E20\n1.1E20') SETTINGS input_format_try_infer_exponent_floats = '0';

DESCRIBE TABLE format(CSV, '1E20\n1.1E20') SETTINGS input_format_try_infer_exponent_floats = '1';

-- This setting should not take affect on JSON formats
DESCRIBE TABLE format(JSONEachRow, '{"x" : 1.1e20}') SETTINGS input_format_try_infer_exponent_floats = '0';