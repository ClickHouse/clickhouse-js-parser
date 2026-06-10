DROP TABLE IF EXISTS `03161_table`;

CREATE TABLE `03161_table`
(
    id UInt32,
    f UInt8
)
ENGINE = Memory();

INSERT INTO `03161_table`;

SELECT '-- Expected plan with analyzer:';

EXPLAIN SYNTAX
SELECT id
FROM `03161_table`
WHERE f
    AND (NOT f
    OR f)
SETTINGS
    convert_query_to_cnf = '1',
    optimize_using_constraints = '1',
    enable_analyzer = '1';

SELECT id
FROM `03161_table`
WHERE f
    AND (NOT f
    OR f)
SETTINGS
    convert_query_to_cnf = '1',
    optimize_using_constraints = '1',
    enable_analyzer = '1';

EXPLAIN SYNTAX
SELECT id
FROM `03161_table`
WHERE f
    AND (NOT f
    OR f)
SETTINGS
    convert_query_to_cnf = '1',
    optimize_using_constraints = '1',
    enable_analyzer = '0';

SELECT id
FROM `03161_table`
WHERE f
    AND (NOT f
    OR f)
SETTINGS
    convert_query_to_cnf = '1',
    optimize_using_constraints = '1',
    enable_analyzer = '0';

-- Checking reproducer from GitHub issue
-- https://github.com/ClickHouse/ClickHouse/issues/57400
DROP TABLE IF EXISTS `03161_reproducer`;

CREATE TABLE `03161_reproducer`
(
    c0 UInt8,
    c1 UInt8,
    c2 UInt8,
    c3 UInt8,
    c4 UInt8,
    c5 UInt8,
    c6 UInt8,
    c7 UInt8,
    c8 UInt8,
    c9 UInt8
)
ENGINE = Memory();

INSERT INTO `03161_reproducer`;

SELECT count()
FROM `03161_reproducer`
WHERE NOT c2
    AND c2
    AND NOT c1
    OR NOT c2
    AND c3
    AND NOT c5
    OR NOT c7
    AND NOT c8
    OR c9
    AND c6
    AND c8
    AND NOT c8
    AND NOT c7
SETTINGS
    convert_query_to_cnf = '1',
    optimize_using_constraints = '1',
    enable_analyzer = '1';

SELECT count()
FROM `03161_reproducer`
WHERE NOT c2
    AND c2
    AND NOT c1
    OR NOT c2
    AND c3
    AND NOT c5
    OR NOT c7
    AND NOT c8
    OR c9
    AND c6
    AND c8
    AND NOT c8
    AND NOT c7
SETTINGS
    convert_query_to_cnf = '1',
    optimize_using_constraints = '1',
    enable_analyzer = '0';