SELECT if(equals(materialize('abc'), 'aws.lambda.duration'), if(toFloat64(materialize('x86_74')) < 50., 0, 1), 0)
SETTINGS short_circuit_function_evaluation = 'enable';

SELECT if(equals(materialize('abc'), 'aws.lambda.duration'), if(toFloat64(materialize('x86_74')) < 50., 0, 1), 0)
SETTINGS short_circuit_function_evaluation = 'force_enable';