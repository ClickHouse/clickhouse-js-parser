SELECT '-- Test against Boolean Setting';

SET optimize_on_insert = true;

SELECT getSetting('optimize_on_insert');

SET max_threads = '4';

SELECT getSetting('max_threads');