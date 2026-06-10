SELECT '{"skip_abc" : 42}'::JSON(SKIP REGEXP 'skip')
SETTINGS type_json_use_partial_match_to_skip_paths_by_regexp = '0';

SELECT '{"skip_abc" : 42}'::JSON(SKIP REGEXP 'skip')
SETTINGS type_json_use_partial_match_to_skip_paths_by_regexp = '1';

SELECT '{"skip_abc" : 42}'::JSON(SKIP REGEXP 'skip.*')
SETTINGS type_json_use_partial_match_to_skip_paths_by_regexp = '0';

SELECT '{"skip_abc" : 42}'::JSON(SKIP REGEXP 'skip.*')
SETTINGS type_json_use_partial_match_to_skip_paths_by_regexp = '1';