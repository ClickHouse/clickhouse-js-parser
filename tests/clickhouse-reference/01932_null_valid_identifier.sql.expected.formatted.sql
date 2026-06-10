SELECT `null`
FROM remote('127.0.0.2', view(    SELECT 1 AS `null`));

SELECT
    `nULl`,
    NULL
FROM remote('127.0.0.2', view(    SELECT 1 AS `nULl`));