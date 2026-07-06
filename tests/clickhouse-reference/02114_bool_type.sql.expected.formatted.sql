DROP TABLE IF EXISTS bool_test;

CREATE TABLE bool_test
(
    value Bool,
    f String
)
ENGINE = Memory();

-- value column shoud have type 'Bool'
SHOW CREATE TABLE bool_test;

INSERT INTO bool_test (value, f);

INSERT INTO bool_test (value, f) FORMAT JSONEachRow;

SELECT
    value,
    f
FROM bool_test
FORMAT JSONEachRow;

SELECT
    toUInt64(value),
    f
FROM bool_test;

SELECT
    value,
    f
FROM bool_test
WHERE value > 0;

SET bool_true_representation = 'True';

SET bool_false_representation = 'False';

INSERT INTO bool_test (value, f) FORMAT CSV;

SELECT
    value,
    f
FROM bool_test
ORDER BY value ASC
FORMAT TSV;

SET bool_true_representation = 'Yes';

SET bool_false_representation = 'No';

INSERT INTO bool_test (value, f) FORMAT CSV;

SET bool_true_representation = 'On';

SET bool_false_representation = 'Off';

INSERT INTO bool_test (value, f) FORMAT CSV;