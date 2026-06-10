---SettingFieldNumber
SELECT changed
FROM `system`.`settings`
WHERE name = 'mysql_max_rows_to_insert';

SET mysql_max_rows_to_insert = '123123';

SET mysql_max_rows_to_insert = '65536';

---SettingAutoWrapper 
SELECT changed
FROM `system`.`settings`
WHERE name = 'insert_quorum';

SET insert_quorum = '123123';

SET insert_quorum = '0';

---SettingFieldMaxThreads 
SELECT changed
FROM `system`.`settings`
WHERE name = 'max_alter_threads';

SET max_alter_threads = '123123';

SET max_alter_threads = '0';

---SettingFieldTimespanUnit
SELECT changed
FROM `system`.`settings`
WHERE name = 'drain_timeout';

SET drain_timeout = '123123';

SET drain_timeout = '3';

---SettingFieldChar
SELECT changed
FROM `system`.`settings`
WHERE name = 'format_csv_delimiter';

SET format_csv_delimiter = ',';

---SettingFieldURI
SELECT changed
FROM `system`.`settings`
WHERE name = 'format_avro_schema_registry_url';

SET format_avro_schema_registry_url = 'https://github.com/ClickHouse/ClickHouse/tree/master/src/Core';

SET format_avro_schema_registry_url = '';

--- SettingFieldEnum
SELECT changed
FROM `system`.`settings`
WHERE name = 'output_format_orc_compression_method';

SET output_format_orc_compression_method = 'none';

SET output_format_orc_compression_method = 'lz4';

--- SettingFieldMultiEnum
SELECT changed
FROM `system`.`settings`
WHERE name = 'join_algorithm';

SET join_algorithm = 'auto,direct';

SET join_algorithm = 'default';