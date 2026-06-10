-- Tags: no-parallel
-- Case 1: RENAME DATABASE
DROP DATABASE IF EXISTS `02661_db`;

DROP DATABASE IF EXISTS `02661_db1`;

SET param_old_db_name = '02661_db';

SET param_new_db_name = '02661_db1';

CREATE DATABASE old_db_name;

RENAME DATABASE old_db_name TO new_db_name;

SELECT name
FROM `system`.databases
WHERE name = 'placeholder';

-- Case 2: RENAME TABLE
DROP TABLE IF EXISTS `02661_t`;

DROP TABLE IF EXISTS `02661_t1`;

SET param_old_tbl_name = '02661_t';

SET param_new_tbl_name = '02661_t1';

CREATE TABLE new_db_name.old_tbl_name
(
    a UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

RENAME TABLE new_db_name.old_tbl_name TO new_db_name.new_tbl_name;

-- NOTE: no 'database = currentDatabase()' on purpose
SELECT name
FROM `system`.tables
WHERE name = 'placeholder';

-- Case 3: RENAME DICTIONARY
DROP DICTIONARY IF EXISTS `02661_d`;

DROP DICTIONARY IF EXISTS `02661_d1`;

SET param_old_dict_name = '02661_d';

SET param_new_dict_name = '02661_d1';

CREATE DICTIONARY new_db_name.old_dict_name
(
    id UInt64,
    val UInt8
)
PRIMARY KEY id
SOURCE(null())
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

RENAME DICTIONARY new_db_name.old_dict_name TO new_db_name.new_dict_name;

SELECT name
FROM `system`.dictionaries
WHERE name = 'placeholder';

EXCHANGE TABLE new_db_name.old_tbl_name AND new_db_name.new_tbl_name;

EXCHANGE DICTIONARY new_db_name.old_dict_name AND new_db_name.new_dict_name;

DROP DATABASE new_db_name;