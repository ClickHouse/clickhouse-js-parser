SET allow_experimental_dynamic_type = '1';

SET allow_suspicious_types_in_group_by = '1';

SET cast_keep_nullable = '1';

SELECT
    toFixedString('str', 3),
    3,
    CAST(if(1 = 0, toInt8(3), NULL) AS Int32) AS x
FROM numbers(10)
GROUP BY GROUPING SETS ((CAST(toInt32(1) AS Int32)), ('str', 3), (CAST(toFixedString('str', 3) AS Dynamic)), (CAST(toFixedString(toFixedString('str', 3), 3) AS Dynamic)));