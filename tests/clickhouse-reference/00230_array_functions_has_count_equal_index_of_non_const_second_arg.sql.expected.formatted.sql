SELECT has([0 AS x], x);

SELECT has([0 AS x], materialize(x));

SELECT has(materialize([0 AS x]), x);

SELECT has(materialize([0 AS x]), materialize(x));

SELECT has([toString(0) AS x], x);

SELECT has([toString(0) AS x], materialize(x));

SELECT has(materialize([toString(0) AS x]), x);

SELECT has(materialize([toString(0) AS x]), materialize(x));

SELECT has([toUInt64(0)], number)
FROM `system`.numbers
LIMIT 10;

SELECT has([toUInt64(0)], toUInt64(number % 3))
FROM `system`.numbers
LIMIT 10;

SELECT has(materialize([toUInt64(0)]), number)
FROM `system`.numbers
LIMIT 10;

SELECT has(materialize([toUInt64(0)]), toUInt64(number % 3))
FROM `system`.numbers
LIMIT 10;

SELECT has([toString(0)], toString(number))
FROM `system`.numbers
LIMIT 10;

SELECT has([toString(0)], toString(number % 3))
FROM `system`.numbers
LIMIT 10;

SELECT has(materialize([toString(0)]), toString(number))
FROM `system`.numbers
LIMIT 10;

SELECT has(materialize([toString(0)]), toString(number % 3))
FROM `system`.numbers
LIMIT 10;

SELECT 3 = countEqual([0 AS x, 1, x, x], x);

SELECT 3 = countEqual([0 AS x, 1, x, x], materialize(x));

SELECT 3 = countEqual(materialize([0 AS x, 1, x, x]), x);

SELECT 3 = countEqual(materialize([0 AS x, 1, x, x]), materialize(x));

SELECT 3 = countEqual([0 AS x, 1, x, x], x)
FROM `system`.numbers
LIMIT 10;

SELECT 3 = countEqual([0 AS x, 1, x, x], materialize(x))
FROM `system`.numbers
LIMIT 10;

SELECT 3 = countEqual(materialize([0 AS x, 1, x, x]), x)
FROM `system`.numbers
LIMIT 10;

SELECT 3 = countEqual(materialize([0 AS x, 1, x, x]), materialize(x))
FROM `system`.numbers
LIMIT 10;

SELECT 4 = indexOf([0, 1, 2, 3 AS x], x);

SELECT 4 = indexOf([0, 1, 2, 3 AS x], materialize(x));

SELECT 4 = indexOf(materialize([0, 1, 2, 3 AS x]), x);

SELECT 4 = indexOf(materialize([0, 1, 2, 3 AS x]), materialize(x));

SELECT 4 = indexOf([0, 1, 2, 3 AS x], x)
FROM `system`.numbers
LIMIT 10;

SELECT 4 = indexOf([0, 1, 2, 3 AS x], materialize(x))
FROM `system`.numbers
LIMIT 10;

SELECT 4 = indexOf(materialize([0, 1, 2, 3 AS x]), x)
FROM `system`.numbers
LIMIT 10;

SELECT 4 = indexOf(materialize([0, 1, 2, 3 AS x]), materialize(x))
FROM `system`.numbers
LIMIT 10;