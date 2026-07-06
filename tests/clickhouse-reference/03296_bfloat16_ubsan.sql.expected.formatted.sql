SET allow_experimental_bfloat16_type = '1';

SELECT CAST('65535' AS BFloat16)::Int16; -- The result is implementation defined on overflow.