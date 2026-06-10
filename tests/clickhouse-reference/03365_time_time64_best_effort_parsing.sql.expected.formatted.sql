SET enable_time_time64_type = '1', date_time_input_format = 'best_effort';

SELECT CAST('[''2010-10-10 23:10:33'']' AS Array(DateTime));

SELECT CAST('[''123:10:33'']' AS Array(Time));

SELECT toString(['10:33'])::Array(Time);

SELECT CAST('[''123:10:33.123'']' AS Array(Time64));