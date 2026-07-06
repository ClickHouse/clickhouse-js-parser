SELECT value
FROM `system`.`settings`
WHERE name = 'allow_settings_after_format_in_insert';

SELECT value
FROM `system`.`settings`
WHERE name = 'allow_settings_after_format_in_insert'
SETTINGS compatibility = '22.3';

SET compatibility = '22.3';

SET compatibility = '22.4';

SET allow_settings_after_format_in_insert = '1';