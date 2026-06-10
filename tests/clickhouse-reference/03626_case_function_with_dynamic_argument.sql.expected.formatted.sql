DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Dynamic
)
ENGINE = Memory();

INSERT INTO t0 (c0);

SELECT caseWithExpression(1, c0, 1, NULL)
FROM t0;

DROP TABLE t0;