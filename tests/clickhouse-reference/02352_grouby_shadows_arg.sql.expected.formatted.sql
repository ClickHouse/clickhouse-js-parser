-- { echoOn }
SELECT toString(dummy) AS dummy
FROM remote('127.{1,1}', 'system.one')
GROUP BY dummy;

SELECT toString(dummy + 1) AS dummy
FROM remote('127.{1,1}', 'system.one')
GROUP BY dummy;

SELECT toString((toInt8(dummy) + 2) * (toInt8(dummy) + 2)) AS dummy
FROM remote('127.{1,1}', `system`.one)
GROUP BY dummy;

SELECT round(number % 3) AS number
FROM remote('127.{1,1}', numbers(20))
GROUP BY number
ORDER BY number ASC;