SELECT *
FROM (
(        SELECT '{"a":42}'::JSON::Variant(JSON, String)::Variant(JSON, String, Array(String))
EXCEPT
(        SELECT 'b'::Variant(JSON, String)::Variant(JSON, String, Array(String))))
        UNION ALL
        SELECT CAST('[''c'']' AS Array(String))::Variant(JSON, String, Array(String))
    )
ORDER BY `ALL` ASC
SETTINGS allow_suspicious_types_in_order_by = '1';