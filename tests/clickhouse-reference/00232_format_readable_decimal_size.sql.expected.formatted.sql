WITH round(exp(number), 6) AS x,

x > 18446744073709551615 ? 18446744073709551615 : toUInt64(x) AS y,

x > 2147483647 ? 2147483647 : toInt32(x) AS z

SELECT
    formatReadableDecimalSize(x),
    formatReadableDecimalSize(y),
    formatReadableDecimalSize(z)
FROM `system`.numbers
LIMIT 70;