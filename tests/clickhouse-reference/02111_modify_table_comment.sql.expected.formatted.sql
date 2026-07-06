-- Tags: no-parallel
DROP DATABASE IF EXISTS `02111_modify_table_comment`;

CREATE DATABASE `02111_modify_table_comment`;

USE `02111_modify_table_comment`;

CREATE TABLE t
(
    n Int8
)
ENGINE = MergeTree()
ORDER BY n
COMMENT 'this is a MergeTree table';

SHOW CREATE TABLE t;

ALTER TABLE t MODIFY COMMENT 'MergeTree Table';

CREATE TABLE t_merge AS t
ENGINE = Merge('02111_modify_table_comment', 't')
COMMENT 'this is a Merge table';

SHOW CREATE TABLE t_merge;

ALTER TABLE t_merge MODIFY COMMENT 'Merge Table';

DROP DATABASE `02111_modify_table_comment`;