-- https://antonz.org/sql-fetch/
CREATE TEMPORARY TABLE employees
(
    id UInt64,
    name String,
    department String,
    salary UInt64
);

INSERT INTO employees;

-- Determinism
SET max_threads = '1', parallelize_output_from_storages = '0';

SELECT
    transform(name, ['Henry', 'Irene', 'Dave', 'Cindy'], ['Henry or Irene', 'Henry or Irene', 'Dave or Cindy', 'Dave or Cindy']) AS name,
    department,
    salary
FROM (
        SELECT *
        FROM employees
        ORDER BY
            id ASC,
            name ASC,
            department ASC,
            salary ASC
    )
ORDER BY salary DESC
LIMIT 5
FORMAT PrettyCompactNoEscapes;

SELECT
    transform(name, ['Henry', 'Irene', 'Dave', 'Cindy'], ['Henry or Irene', 'Henry or Irene', 'Dave or Cindy', 'Dave or Cindy']) AS name,
    department,
    salary
FROM (
        SELECT *
        FROM employees
        ORDER BY
            id ASC,
            name ASC,
            department ASC,
            salary ASC
    )
ORDER BY salary DESC
LIMIT 5
FORMAT PrettyCompactNoEscapes;

SELECT
    transform(name, ['Henry', 'Irene', 'Dave', 'Cindy'], ['Henry or Irene', 'Henry or Irene', 'Dave or Cindy', 'Dave or Cindy']) AS name,
    department,
    salary
FROM (
        SELECT *
        FROM employees
        ORDER BY
            id ASC,
            name ASC,
            department ASC,
            salary ASC
    )
ORDER BY salary DESC
LIMIT 5 WITH TIES
FORMAT PrettyCompactNoEscapes;

SELECT
    transform(name, ['Henry', 'Irene', 'Dave', 'Cindy'], ['Henry or Irene', 'Henry or Irene', 'Dave or Cindy', 'Dave or Cindy']) AS name,
    department,
    salary
FROM (
        SELECT *
        FROM employees
        ORDER BY
            id ASC,
            name ASC,
            department ASC,
            salary ASC
    )
ORDER BY salary DESC
LIMIT 5
OFFSET 3
FORMAT PrettyCompactNoEscapes;

SELECT
    transform(name, ['Henry', 'Irene', 'Dave', 'Cindy'], ['Henry or Irene', 'Henry or Irene', 'Dave or Cindy', 'Dave or Cindy']) AS name,
    department,
    salary
FROM (
        SELECT *
        FROM employees
        ORDER BY
            id ASC,
            name ASC,
            department ASC,
            salary ASC
    )
ORDER BY salary DESC
LIMIT 5
OFFSET 3
FORMAT PrettyCompactNoEscapes;