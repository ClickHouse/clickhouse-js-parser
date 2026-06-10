DROP TABLE IF EXISTS tuple;

CREATE TABLE tuple
(
    t Tuple(Date, UInt32, UInt64)
)
ENGINE = Memory();

INSERT INTO tuple;

SET input_format_values_interpret_expressions = '0';

INSERT INTO tuple;

SELECT *
FROM tuple
ORDER BY t ASC;

DROP TABLE tuple;