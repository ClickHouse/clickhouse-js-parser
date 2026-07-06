SELECT `DIV` AS `MOD`
FROM (
        SELECT 1 AS `DIV`
    )
FORMAT TSVWithNames;

SELECT `DIV` AS `MOD`
FROM (
        SELECT 1 AS `DIV`
    )
FORMAT TSVWithNames;

SELECT `DIV` % 1
FROM (
        SELECT 1 AS `DIV`
    )
FORMAT TSVWithNames;

SELECT 1 DIV `MOD` AS `DIV`
FROM (
        SELECT 1 AS `MOD`
    )
FORMAT TSVWithNames;