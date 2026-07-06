DROP TABLE IF EXISTS lc_nullable_string;

CREATE TABLE lc_nullable_string
(
    c1 LowCardinality(Nullable(String)) DEFAULT CAST(NULL AS LowCardinality(Nullable(String)))
)
ENGINE = Memory();

INSERT INTO lc_nullable_string (c1);

INSERT INTO lc_nullable_string (c1);

SELECT *
FROM lc_nullable_string
ORDER BY c1 ASC;

DROP TABLE lc_nullable_string;