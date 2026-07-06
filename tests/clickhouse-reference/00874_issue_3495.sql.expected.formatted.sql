DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    a Int8,
    val Float32
)
ENGINE = Memory();

INSERT INTO t;

SET enable_optimize_predicate_expression = '0';

SELECT *
FROM (
        SELECT
            a,
            t1.val AS val1,
            t2.val AS val2
        FROM
            t AS t1
        ANY LEFT JOIN t AS t2
            USING (a)
    )
ORDER BY val1 ASC;

SET enable_optimize_predicate_expression = '1';

DROP TABLE t;