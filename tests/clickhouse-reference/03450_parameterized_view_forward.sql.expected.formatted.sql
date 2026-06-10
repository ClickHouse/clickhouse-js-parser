DROP TABLE IF EXISTS inner_view, outer_view_hardcoded_ok, outer_view_parameterized_ko;

CREATE VIEW inner_view
AS
SELECT 0 + 0 AS n;

CREATE VIEW outer_view_hardcoded_ok
AS
SELECT n * 2 AS c
FROM inner_view(inner_a = 1, inner_b = 2);

SELECT *
FROM outer_view_hardcoded_ok;

CREATE VIEW outer_view_parameterized_ko
AS
SELECT n * 2 AS c
FROM inner_view(inner_a = 0, inner_b = 0);

SELECT *
FROM outer_view_parameterized_ko(a = 1, b = 2);

DROP TABLE inner_view, outer_view_hardcoded_ok, outer_view_parameterized_ko;