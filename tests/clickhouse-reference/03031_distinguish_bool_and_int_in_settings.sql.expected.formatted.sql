-- Custom settings must remember their types - whether it's a boolean or an integer.
-- Different ways to set a boolean.
SET custom_f1 = false;

SET custom_f2 = false;

SET custom_f3 = false;

SET custom_n0 = '0';

SET custom_n1 = '1';

SET custom_t1 = true;

SET custom_t2 = true;

SET custom_t3 = true;

SELECT '-- Custom settings from system.settings';

SELECT
    name,
    value,
    type
FROM `system`.`settings`
WHERE startsWith(name, 'custom_')
ORDER BY name ASC;

SELECT
    'custom_f1' AS name,
    getSetting(name) AS value,
    toTypeName(value);

SELECT
    'custom_f2' AS name,
    getSetting(name) AS value,
    toTypeName(value);

SELECT
    'custom_f3' AS name,
    getSetting(name) AS value,
    toTypeName(value);

SELECT
    'custom_n0' AS name,
    getSetting(name) AS value,
    toTypeName(value);

SELECT
    'custom_n1' AS name,
    getSetting(name) AS value,
    toTypeName(value);

SELECT
    'custom_t1' AS name,
    getSetting(name) AS value,
    toTypeName(value);

SELECT
    'custom_t2' AS name,
    getSetting(name) AS value,
    toTypeName(value);

SELECT
    'custom_t3' AS name,
    getSetting(name) AS value,
    toTypeName(value);

SET async_insert = false;

SELECT
    name,
    value,
    type
FROM `system`.`settings`
WHERE name = 'async_insert';

SELECT
    'async_insert' AS name,
    getSetting(name) AS value,
    toTypeName(value);

SET async_insert = '0';

SET async_insert = '1';

SET async_insert = true;