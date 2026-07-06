DROP TABLE IF EXISTS or_expr_bug;

CREATE TABLE or_expr_bug
(
    a UInt64,
    b UInt64
)
ENGINE = Memory();

INSERT INTO or_expr_bug;

SELECT count(*)
FROM or_expr_bug
WHERE (a = 1
    OR a = 2
    OR a = 3)
    AND (b = 21
    OR b = 22
    OR b = 23);

DROP TABLE or_expr_bug;