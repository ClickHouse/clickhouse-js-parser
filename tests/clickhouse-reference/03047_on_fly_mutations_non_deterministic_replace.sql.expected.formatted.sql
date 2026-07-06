DROP TABLE IF EXISTS t_lightweight_mut_5;

SET apply_mutations_on_fly = '1';

SET mutations_execute_subqueries_on_initiator = '1';

SET mutations_execute_nondeterministic_on_initiator = '1';

-- SELECT sum(...)
CREATE TABLE t_lightweight_mut_5
(
    id UInt64,
    v UInt64
)
ENGINE = MergeTree()
ORDER BY id;

SYSTEM STOP MERGES t_lightweight_mut_5;

INSERT INTO t_lightweight_mut_5;

ALTER TABLE t_lightweight_mut_5 UPDATE v = (
    SELECT sum(number)
    FROM numbers(100)
) WHERE 1;

SELECT
    id,
    v
FROM t_lightweight_mut_5
ORDER BY id ASC;

SELECT command
FROM `system`.mutations
WHERE database = currentDatabase()
    AND table = 't_lightweight_mut_5'
    AND NOT is_done
ORDER BY command ASC;

DROP TABLE t_lightweight_mut_5;

-- SELECT groupArray(...)
CREATE TABLE t_lightweight_mut_5
(
    id UInt64,
    v Array(UInt64)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t_lightweight_mut_5;

ALTER TABLE t_lightweight_mut_5 UPDATE v = (
    SELECT groupArray(number)
    FROM numbers(10)
) WHERE 1;

ALTER TABLE t_lightweight_mut_5 UPDATE v = (
    SELECT groupArray(number)
    FROM numbers(10000)
) WHERE 1;

SELECT
    id,
    length(v)
FROM t_lightweight_mut_5
ORDER BY id ASC; -- { serverError BAD_ARGUMENTS }

SYSTEM START MERGES t_lightweight_mut_5;

-- Force to wait previous mutations
ALTER TABLE t_lightweight_mut_5 UPDATE v = v WHERE 1 SETTINGS mutations_sync = '2';

-- SELECT uniqExactState(...)
CREATE TABLE t_lightweight_mut_5
(
    id UInt64,
    v AggregateFunction(uniqExact, UInt64)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t_lightweight_mut_5;

ALTER TABLE t_lightweight_mut_5 UPDATE v = (
    SELECT uniqExactState(number)
    FROM numbers(5)
) WHERE 1;

SELECT
    id,
    finalizeAggregation(v)
FROM t_lightweight_mut_5
ORDER BY id ASC;

-- now()
CREATE TABLE t_lightweight_mut_5
(
    id UInt64,
    v DateTime
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t_lightweight_mut_5;

ALTER TABLE t_lightweight_mut_5 UPDATE v = now() WHERE 1;

SELECT
    id,
    v >= now() - toIntervalMinute(10)
    AND v <= now()
FROM t_lightweight_mut_5;

SELECT replaceRegexpOne(command, '(\\d{10})', 'timestamp')
FROM `system`.mutations
WHERE database = currentDatabase()
    AND table = 't_lightweight_mut_5'
    AND NOT is_done
ORDER BY command ASC;

INSERT INTO t_lightweight_mut_5;

ALTER TABLE t_lightweight_mut_5 UPDATE v = filesystemCapacity(materialize('default')) WHERE 1;

SELECT *
FROM t_lightweight_mut_5
ORDER BY id ASC; -- { serverError BAD_ARGUMENTS }

SELECT *
FROM t_lightweight_mut_5
ORDER BY id ASC
SETTINGS apply_mutations_on_fly = '0';

-- Check that function in subquery is not rewritten.
ALTER TABLE t_lightweight_mut_5 UPDATE v = (
    SELECT sum(number)
    FROM numbers(1000)
    WHERE number > randConstant()
) WHERE 1 SETTINGS mutations_execute_subqueries_on_initiator = '0';

-- DELETE WHERE now()
CREATE TABLE t_lightweight_mut_5
(
    id UInt64,
    d DateTime
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t_lightweight_mut_5;

ALTER TABLE t_lightweight_mut_5 DELETE WHERE d < now();

SELECT *
FROM t_lightweight_mut_5
ORDER BY id ASC
SETTINGS apply_mutations_on_fly = '1';