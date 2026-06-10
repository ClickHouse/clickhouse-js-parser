SELECT maxMap([number % 3, number % 4 - 1], [number, NULL])
FROM numbers(3)
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT maxMap([number % 3, number % 4 - 1], [number, NULL])
FROM numbers(3)
GROUP BY number
WITH ROLLUP
ORDER BY number ASC;

SELECT maxMap([number % 3, number % 4 - 1], [number, NULL])
FROM numbers(3)
GROUP BY number
WITH CUBE
ORDER BY number ASC;

SELECT minMap([number % 3, number % 4 - 1], [number, NULL])
FROM numbers(3)
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT minMap([number % 3, number % 4 - 1], [number, NULL])
FROM numbers(3)
GROUP BY number
WITH ROLLUP
ORDER BY number ASC;

SELECT minMap([number % 3, number % 4 - 1], [number, NULL])
FROM numbers(3)
GROUP BY number
WITH CUBE
ORDER BY number ASC;

SELECT sumMap([number % 3, number % 4 - 1], [number, NULL])
FROM numbers(3)
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT sumMap([number % 3, number % 4 - 1], [number, NULL])
FROM numbers(3)
GROUP BY number
WITH ROLLUP
ORDER BY number ASC;

SELECT sumMap([number % 3, number % 4 - 1], [number, NULL])
FROM numbers(3)
GROUP BY number
WITH CUBE
ORDER BY number ASC;

SELECT maxMap([number % 3, number % 4 - 1], [number::Float64, NULL])
FROM numbers(3)
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT maxMap([number % 3, number % 4 - 1], [number::Float64, NULL])
FROM numbers(3)
GROUP BY number
WITH ROLLUP
ORDER BY number ASC;

SELECT maxMap([number % 3, number % 4 - 1], [number::Float64, NULL])
FROM numbers(3)
GROUP BY number
WITH CUBE
ORDER BY number ASC;

SELECT minMap([number % 3, number % 4 - 1], [number::Float64, NULL])
FROM numbers(3)
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT minMap([number % 3, number % 4 - 1], [number::Float64, NULL])
FROM numbers(3)
GROUP BY number
WITH ROLLUP
ORDER BY number ASC;

SELECT minMap([number % 3, number % 4 - 1], [number::Float64, NULL])
FROM numbers(3)
GROUP BY number
WITH CUBE
ORDER BY number ASC;

SELECT sumMap([number % 3, number % 4 - 1], [number::Float64, NULL])
FROM numbers(3)
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT sumMap([number % 3, number % 4 - 1], [number::Float64, NULL])
FROM numbers(3)
GROUP BY number
WITH ROLLUP
ORDER BY number ASC;

SELECT sumMap([number % 3, number % 4 - 1], [number::Float64, NULL])
FROM numbers(3)
GROUP BY number
WITH CUBE
ORDER BY number ASC;

SELECT maxMap([number % 3, number % 4 - 1], [number::UInt256, NULL])
FROM numbers(3)
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT maxMap([number % 3, number % 4 - 1], [number::UInt256, NULL])
FROM numbers(3)
GROUP BY number
WITH ROLLUP
ORDER BY number ASC;

SELECT maxMap([number % 3, number % 4 - 1], [number::UInt256, NULL])
FROM numbers(3)
GROUP BY number
WITH CUBE
ORDER BY number ASC;

SELECT minMap([number % 3, number % 4 - 1], [number::UInt256, NULL])
FROM numbers(3)
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT minMap([number % 3, number % 4 - 1], [number::UInt256, NULL])
FROM numbers(3)
GROUP BY number
WITH ROLLUP
ORDER BY number ASC;

SELECT minMap([number % 3, number % 4 - 1], [number::UInt256, NULL])
FROM numbers(3)
GROUP BY number
WITH CUBE
ORDER BY number ASC;

SELECT sumMap([number % 3, number % 4 - 1], [number::UInt256, NULL])
FROM numbers(3)
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT sumMap([number % 3, number % 4 - 1], [number::UInt256, NULL])
FROM numbers(3)
GROUP BY number
WITH ROLLUP
ORDER BY number ASC;

SELECT sumMap([number % 3, number % 4 - 1], [number::UInt256, NULL])
FROM numbers(3)
GROUP BY number
WITH CUBE
ORDER BY number ASC;