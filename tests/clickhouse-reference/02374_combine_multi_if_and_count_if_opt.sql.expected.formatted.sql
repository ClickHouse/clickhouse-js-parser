DROP TABLE IF EXISTS m;

CREATE TABLE m
(
    a int
)
ENGINE = Log();

INSERT INTO m;

SET enable_analyzer = true, optimize_rewrite_sum_if_to_count_if = '1';

EXPLAIN QUERY TREE
SELECT sum(multiIf(a = 1, 1, 0))
FROM m;

DROP TABLE m;