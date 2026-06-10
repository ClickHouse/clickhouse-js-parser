SET enable_analyzer = '1';

CREATE VIEW `03271_parametrized_v`
AS
SELECT number AS n
FROM numbers(0);

CREATE VIEW `03271_parametrized_v_expl` (n UInt64)
AS
SELECT number AS n
FROM numbers(0);

-- Should return no columns
SHOW COLUMNS FROM `03271_parametrized_v`;

-- Should return one column 'n' of type 'UInt64'
SHOW COLUMNS FROM `03271_parametrized_v_expl`;

SELECT *
FROM `system`.`columns`
WHERE table = '03271_parametrized_v'
    AND database = currentDatabase();

SELECT *
FROM `system`.`columns`
WHERE table = '03271_parametrized_v_expl'
    AND database = currentDatabase();

-- Mismatched schema: should return error on query tree building
CREATE VIEW `03271_parametrized_v_expl_mismatch` (n UInt64, s String)
AS
SELECT number AS n
FROM numbers(0);

SELECT *
FROM `03271_parametrized_v_expl_mismatch`(upper_bound = 3); -- { serverError TYPE_MISMATCH }

EXPLAIN AST
SELECT *
FROM `03271_parametrized_v_expl_mismatch`(upper_bound = 3);

EXPLAIN QUERY TREE
SELECT *
FROM `03271_parametrized_v_expl_mismatch`(upper_bound = 3); -- { serverError TYPE_MISMATCH }

SELECT *
FROM `03271_parametrized_v_expl`(upper_bound = 3);

DROP VIEW `03271_parametrized_v`;

DROP VIEW `03271_parametrized_v_expl`;

DROP VIEW `03271_parametrized_v_expl_mismatch`;