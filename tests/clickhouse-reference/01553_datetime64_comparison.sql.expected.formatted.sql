CREATE TABLE datetime64_cmp
(
    dt6 DateTime64(6, 'UTC'),
    dt3 DateTime64(3, 'UTC')
)
ENGINE = Memory();

INSERT INTO datetime64_cmp;

-- Compare equal and unequal values of different precicion/scale
SELECT
    dt6,
    dt3,
    dt6 > dt3,
    dt6 >= dt3,
    dt6 = dt3,
    dt6 <= dt3,
    dt6 < dt3,
    dt6 != dt3
FROM datetime64_cmp
ORDER BY
    dt6 ASC,
    dt3 ASC;