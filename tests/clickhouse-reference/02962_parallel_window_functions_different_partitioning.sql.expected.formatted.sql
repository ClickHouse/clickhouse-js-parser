CREATE TABLE empsalary
(
    depname LowCardinality(String),
    empno UInt64,
    salary Int32,
    enroll_date Date
)
ENGINE = Memory();

INSERT INTO empsalary;

-- 1 window function
SELECT
    depname,
    sum(salary) OVER (PARTITION BY depname ORDER BY empno ASC) AS depsalary
FROM empsalary
ORDER BY depsalary ASC;

-- 2 window functions with different window,
-- but result should be the same for depsalary
SELECT
    depname,
    sum(salary) OVER (PARTITION BY depname ORDER BY empno ASC) AS depsalary,
    min(salary) OVER (PARTITION BY depname, empno ORDER BY enroll_date ASC) AS depminsalary
FROM empsalary
ORDER BY depsalary ASC;