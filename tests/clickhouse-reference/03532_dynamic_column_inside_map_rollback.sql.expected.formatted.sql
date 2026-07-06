SELECT c0
FROM format(CSV, 'c0 Map(Dynamic, String)', '\n"{}"\n"{[''a'', ''b''] : ''a'', ''''a'' : 1}"\n')
SETTINGS input_format_allow_errors_num = '1';