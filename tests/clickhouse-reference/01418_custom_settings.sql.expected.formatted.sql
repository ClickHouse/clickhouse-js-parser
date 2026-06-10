DROP SETTINGS PROFILE IF EXISTS s1_01418, s2_01418;

SELECT '--- assigning ---';

SET custom_a = '5';

SET custom_b = '-177';

SET custom_c = 98.11;

SET custom_d = 'abc def';

SELECT
    getSetting('custom_a') AS v,
    toTypeName(v);

SELECT
    getSetting('custom_b') AS v,
    toTypeName(v);

SELECT
    getSetting('custom_c') AS v,
    toTypeName(v);

SELECT
    getSetting('custom_d') AS v,
    toTypeName(v);

SELECT
    name,
    value
FROM `system`.`settings`
WHERE name LIKE 'custom_%'
ORDER BY name ASC;

SET custom_a = 'changed';

SET custom_b = NULL;

SET custom_c = '50000';

SET custom_d = 1.11;

SELECT
    getSetting('custom_e') AS v,
    toTypeName(v); -- { serverError UNKNOWN_SETTING } -- Setting not found.

SET custom_e = '404';

SET invalid_custom = '8'; -- { serverError UNKNOWN_SETTING } -- Setting is neither a builtin nor started with one of the registered prefixes for user-defined settings.

SELECT
    getSetting('custom_e') AS v,
    toTypeName(v)
SETTINGS custom_e = -0.333;

SELECT
    name,
    value
FROM `system`.`settings`
WHERE name = 'custom_e'
SETTINGS custom_e = -0.333;

SELECT
    name,
    value
FROM `system`.`settings`
WHERE name = 'custom_e';

SELECT
    getSetting('custom_f') AS v,
    toTypeName(v)
SETTINGS custom_f = 'word';

SELECT
    name,
    value
FROM `system`.`settings`
WHERE name = 'custom_f'
SETTINGS custom_f = 'word';

SELECT
    getSetting('custom_f') AS v,
    toTypeName(v); -- { serverError UNKNOWN_SETTING } -- Setting not found.

SELECT COUNT()
FROM `system`.`settings`
WHERE name = 'custom_f';

SET custom_compound.identifier.v1 = 'test';

SELECT
    getSetting('custom_compound.identifier.v1') AS v,
    toTypeName(v);

SELECT
    name,
    value
FROM `system`.`settings`
WHERE name = 'custom_compound.identifier.v1';

CREATE SETTINGS PROFILE s1_01418 SETTINGS custom_compound.identifier.v2=100;

SHOW CREATE SETTINGS PROFILE s1_01418;

DROP SETTINGS PROFILE s1_01418;

SELECT
    getSetting('custom_null') AS v,
    toTypeName(v)
SETTINGS custom_null = NULL;

SELECT
    name,
    value
FROM `system`.`settings`
WHERE name = 'custom_null'
SETTINGS custom_null = NULL;

SET custom_null = NULL;

SELECT
    getSetting('custom_null') AS v,
    toTypeName(v);

SELECT
    name,
    value
FROM `system`.`settings`
WHERE name = 'custom_null';

CREATE SETTINGS PROFILE s2_01418 SETTINGS custom_null=NULL;

SHOW CREATE SETTINGS PROFILE s2_01418;

DROP SETTINGS PROFILE s2_01418;