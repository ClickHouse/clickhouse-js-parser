SELECT
    toTypeName((1,)),
    (1,);

EXPLAIN SYNTAX
SELECT (1,);

DROP TABLE IF EXISTS tuple_values;

CREATE TABLE tuple_values
(
    t Tuple(int)
)
ENGINE = Memory();

INSERT INTO tuple_values;

DROP TABLE tuple_values;