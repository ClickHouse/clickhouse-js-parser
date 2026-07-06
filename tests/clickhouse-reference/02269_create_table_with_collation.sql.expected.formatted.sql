-- Tags: memory-engine
EXPLAIN SYNTAX
CREATE TABLE t
(
    x varchar(255) COLLATE binary NOT NULL
)
ENGINE = Memory();

SET compatibility_ignore_collation_in_create_table = false;

CREATE TABLE t_02267_collation
(
    x varchar(255) COLLATE utf8_unicode_ci NOT NULL
)
ENGINE = Memory(); -- {serverError NOT_IMPLEMENTED}

SET compatibility_ignore_collation_in_create_table = true;

DROP TABLE t_02267_collation;