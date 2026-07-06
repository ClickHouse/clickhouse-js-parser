SELECT 1
FROM numbers(3)
ORDER BY [1, ()] ASC
LIMIT 1
SETTINGS
    allow_suspicious_types_in_order_by = '1',
    use_variant_as_common_type = '1';