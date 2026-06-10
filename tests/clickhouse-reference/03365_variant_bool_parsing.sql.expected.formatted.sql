SET enable_variant_type = '1';

SELECT
    't'::Variant(String, Bool) AS v,
    variantType(v);

SELECT
    'on'::Variant(String, Bool) AS v,
    variantType(v);

SELECT
    'f'::Variant(String, Bool) AS v,
    variantType(v);

SELECT
    'off'::Variant(String, Bool) AS v,
    variantType(v);

SELECT
    'true'::Variant(String, Bool) AS v,
    variantType(v);

SELECT
    'false'::Variant(String, Bool) AS v,
    variantType(v);

SET allow_special_bool_values_inside_variant = '1';

SET allow_special_bool_values_inside_variant = '0';

SET cast_string_to_variant_use_inference = '0';