SET allow_experimental_variant_type = '1';

SET allow_suspicious_variant_types = '0';

SELECT 'true'::Bool::Variant(UInt32, Bool);