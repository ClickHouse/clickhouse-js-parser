DROP TABLE IF EXISTS t_00575;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE t_00575
(
    d Date
)
ENGINE = MergeTree(d, d, 8192);

INSERT INTO t_00575;

SELECT count()
FROM t_00575
WHERE toDayOfWeek(d) IN (2);

DROP TABLE t_00575;