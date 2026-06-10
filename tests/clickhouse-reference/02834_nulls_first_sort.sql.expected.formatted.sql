DROP TABLE IF EXISTS nulls_first_sort_test;

CREATE TABLE nulls_first_sort_test
(
    a Nullable(Int32),
    b Nullable(Int32),
    c Nullable(Int32)
)
ENGINE = Memory();

INSERT INTO nulls_first_sort_test;

SELECT *
FROM nulls_first_sort_test
ORDER BY
    a ASC NULLS FIRST,
    b ASC NULLS FIRST,
    c ASC NULLS FIRST
LIMIT 5;

DROP TABLE nulls_first_sort_test;