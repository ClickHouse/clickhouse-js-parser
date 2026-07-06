SET allow_experimental_dynamic_type = '1';

SET allow_suspicious_types_in_group_by = '1';

SET allow_suspicious_types_in_order_by = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    d Dynamic(max_types = 2)
)
ENGINE = Memory();

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

SELECT uniqExact(d)
FROM test;

SELECT
    count(),
    d
FROM test
GROUP BY d
ORDER BY d ASC;

DROP TABLE test;