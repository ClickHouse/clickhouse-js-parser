SET enable_analyzer = '1';

-- { echo }
EXPLAIN SYNTAX
SELECT
    negate(1),
    negate(-1),
    -(-1),
    -(-1),
    -1 IN (-1);

EXPLAIN SYNTAX
SELECT
    negate(1.),
    negate(-1.),
    -(-1.),
    -(-1.),
    -1. IN (-1.);

EXPLAIN SYNTAX
SELECT
    negate(-9223372036854775808),
    -(-9223372036854775808),
    -(-9223372036854775808);

EXPLAIN SYNTAX
SELECT
    negate(0),
    negate(0),
    -(0),
    -(0),
    0 IN (0);

EXPLAIN SYNTAX
SELECT
    negate(0.),
    negate(-0.),
    -(-0.),
    -(-0.),
    -0. IN (-0.);