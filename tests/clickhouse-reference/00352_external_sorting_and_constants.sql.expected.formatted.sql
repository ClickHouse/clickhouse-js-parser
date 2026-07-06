SELECT
    number,
    'Hello' AS k
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 1000000
    )
ORDER BY number ASC
LIMIT 100
OFFSET 999990
SETTINGS
    max_bytes_before_external_sort = '1000000',
    max_bytes_ratio_before_external_sort = '0';

SELECT
    number,
    'Hello' AS k
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 1000000
    )
ORDER BY
    number ASC,
    k ASC
LIMIT 100
OFFSET 999990
SETTINGS
    max_bytes_before_external_sort = '1000000',
    max_bytes_ratio_before_external_sort = '0';

SELECT
    number,
    'Hello' AS k
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 1000000
    )
ORDER BY
    k ASC,
    number ASC,
    k ASC
LIMIT 100
OFFSET 999990
SETTINGS
    max_bytes_before_external_sort = '1000000',
    max_bytes_ratio_before_external_sort = '0';

SELECT
    number,
    'Hello' AS k
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 1000000
    )
ORDER BY
    number ASC,
    k ASC,
    number ASC
LIMIT 100
OFFSET 999990
SETTINGS
    max_bytes_before_external_sort = '1000000',
    max_bytes_ratio_before_external_sort = '0';