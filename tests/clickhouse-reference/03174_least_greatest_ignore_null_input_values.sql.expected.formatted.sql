SET least_greatest_legacy_null_behavior = DEFAULT;

SELECT
    greatest(NULL),
    least(NULL);

SELECT
    greatest(1, NULL),
    least(1, NULL);

SELECT
    greatest(NULL, 1),
    least(NULL, 1);

SELECT
    greatest(NULL, 1.1),
    least(NULL, 1.1);

SELECT
    greatest(1.1, NULL),
    least(1.1, NULL);

SELECT
    greatest(NULL, 'a'),
    least(NULL, 'a');

SELECT
    greatest('a', NULL),
    least('a', NULL);

SELECT
    greatest(materialize(NULL)),
    least(materialize(NULL));

SELECT
    greatest(materialize(1), NULL),
    least(materialize(1), NULL);

SELECT
    greatest(materialize(NULL), 1),
    least(materialize(NULL), 1);

SELECT
    greatest(materialize(NULL), 1.1),
    least(materialize(NULL), 1.1);

SELECT
    greatest(materialize(1.1), NULL),
    least(materialize(1.1), NULL);

SELECT
    greatest(materialize(NULL), 'a'),
    least(materialize(NULL), 'a');

SELECT
    greatest(materialize('a'), NULL),
    least(materialize('a'), NULL);

SELECT
    greatest(toNullable(1), 2),
    least(toNullable(1), 2);

SELECT
    greatest(toLowCardinality(1), NULL),
    least(toLowCardinality(1), NULL);

SET least_greatest_legacy_null_behavior = true;