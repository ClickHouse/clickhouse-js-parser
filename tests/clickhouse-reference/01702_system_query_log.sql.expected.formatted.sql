-- Tags: no-parallel
-- fire all kinds of queries and then check if those are present in the system.query_log
SET log_comment = 'system.query_log logging test';

DROP DATABASE IF EXISTS sqllt SYNC;

DROP USER IF EXISTS sqllt_user;

DROP ROLE IF EXISTS sqllt_role;

DROP ROW POLICY IF EXISTS sqllt_policy ON sqllt.table, sqllt_policy ON sqllt.view, sqllt_policy ON sqllt.dictionary;

DROP ROW POLICY IF EXISTS sqllt_row_policy ON sqllt.table, sqllt_row_policy ON sqllt.view, sqllt_row_policy ON sqllt.dictionary;

DROP QUOTA IF EXISTS sqllt_quota;

DROP SETTINGS PROFILE IF EXISTS sqllt_settings_profile;

CREATE DATABASE sqllt;

CREATE TABLE sqllt.table
(
    i UInt8,
    s String
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple();

CREATE VIEW sqllt.view
AS
SELECT
    i,
    s
FROM sqllt.table;

CREATE DICTIONARY sqllt.dictionary
(
    key UInt64,
    value UInt64
)
PRIMARY KEY key
SOURCE(clickhouse(DB 'sqllt' TABLE 'table' HOST 'localhost' PORT 9001))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

CREATE USER sqllt_user IDENTIFIED BY 'password';

CREATE ROLE sqllt_role;

CREATE ROW POLICY sqllt_policy ON sqllt.table, sqllt_policy ON sqllt.view, sqllt_policy ON sqllt.dictionary AS PERMISSIVE TO ALL;

CREATE ROW POLICY sqllt_row_policy ON sqllt.table, sqllt_row_policy ON sqllt.view, sqllt_row_policy ON sqllt.dictionary AS PERMISSIVE TO ALL;

CREATE QUOTA sqllt_quota KEYED BY user_name TO sqllt_role;

CREATE SETTINGS PROFILE sqllt_settings_profile SETTINGS interactive_delay=200000;

GRANT sqllt_role TO sqllt_user;

SET log_profile_events = false;

SET DEFAULT ROLE sqllt_role TO sqllt_user;

ALTER TABLE sqllt.table ADD COLUMN new_col UInt32 DEFAULT 123456789;

ALTER TABLE sqllt.table COMMENT COLUMN new_col 'dummy column with a comment';

ALTER TABLE sqllt.table CLEAR COLUMN new_col;

ALTER TABLE sqllt.table MODIFY COLUMN new_col DateTime DEFAULT '2015-05-18 07:40:13';

ALTER TABLE sqllt.table MODIFY COLUMN new_col REMOVE COMMENT;

ALTER TABLE sqllt.table RENAME COLUMN new_col TO the_new_col;

ALTER TABLE sqllt.table DROP COLUMN the_new_col;

ALTER TABLE sqllt.table UPDATE i = i + 1 WHERE 1;

ALTER TABLE sqllt.table DELETE WHERE i > 65535;

SYSTEM FLUSH LOGS query_log;

SYSTEM STOP MERGES sqllt.table;

SYSTEM START MERGES sqllt.table;

SYSTEM STOP TTL MERGES sqllt.table;

SYSTEM START TTL MERGES sqllt.table;

SYSTEM STOP MOVES sqllt.table;

SYSTEM START MOVES sqllt.table;

SYSTEM STOP FETCHES sqllt.table;

SYSTEM START FETCHES sqllt.table;

SYSTEM STOP REPLICATED SENDS sqllt.table;

SYSTEM START REPLICATED SENDS sqllt.table;

SHOW CREATE TABLE sqllt.table FORMAT Null;

SHOW CREATE DICTIONARY sqllt.dictionary FORMAT Null;

SHOW DATABASES LIKE 'sqllt' FORMAT Null;

SHOW TABLES FROM sqllt FORMAT Null;

SHOW DICTIONARIES FROM sqllt FORMAT Null;

SHOW GRANTS FORMAT Null;

SHOW GRANTS FOR sqllt_user FORMAT Null;

SHOW CREATE USER sqllt_user FORMAT Null;

SHOW CREATE ROLE sqllt_role FORMAT Null;

SHOW CREATE ROW POLICY sqllt_policy FORMAT Null;

SHOW CREATE ROW POLICY sqllt_row_policy FORMAT Null;

SHOW CREATE QUOTA sqllt_quota FORMAT Null;

SHOW CREATE SETTINGS PROFILE sqllt_settings_profile FORMAT Null;

GRANT SELECT ON sqllt.table TO sqllt_user;

GRANT DROP ON sqllt.view TO sqllt_user;

REVOKE SELECT ON sqllt.table FROM sqllt_user;

REVOKE DROP ON sqllt.view FROM sqllt_user;

DESCRIBE TABLE sqllt.table FORMAT Null;

CHECK TABLE sqllt.table FORMAT Null;

DETACH TABLE sqllt.table;

ATTACH TABLE sqllt.table;

RENAME TABLE sqllt.table TO sqllt.table_new;

RENAME TABLE sqllt.table_new TO sqllt.table;

TRUNCATE TABLE sqllt.table;

DROP TABLE sqllt.table SYNC;

SET log_comment = '';

-- Try to filter out all possible previous junk events by excluding old log entries,
SELECT
    query_kind,
    query
FROM `system`.query_log
WHERE log_comment LIKE '%system.query_log%'
    AND type = 'QueryStart'
    AND event_date >= yesterday()
    AND current_database = currentDatabase()
    AND is_internal = 0
ORDER BY event_time_microseconds ASC;

DROP DATABASE IF EXISTS sqllt;