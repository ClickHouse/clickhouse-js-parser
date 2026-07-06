DROP TABLE IF EXISTS multiword_types;

DROP TABLE IF EXISTS unsigned_types;

CREATE TABLE multiword_types
(
    a DOUBLE,
    b DOUBLE PRECISION,
    c CHAR DEFAULT 'str',
    d CHAR VARYING,
    e CHAR LARGE OBJECT COMMENT 'comment',
    f CHARACTER VARYING(123),
    g CHARACTER LARGE OBJECT,
    h NCHAR VARYING(456) DEFAULT toString(a) COMMENT 'comment',
    i NCHAR LARGE OBJECT,
    j BINARY LARGE OBJECT,
    k BINARY VARYING,
    l NATIONAL CHAR,
    m NATIONAL CHARACTER,
    n NATIONAL CHARACTER LARGE OBJECT,
    o NATIONAL CHARACTER VARYING,
    p NATIONAL CHAR VARYING
)
ENGINE = Memory();

SHOW CREATE TABLE multiword_types;

INSERT INTO multiword_types (a);

SELECT toTypeName((*,))
FROM multiword_types
SETTINGS enable_named_columns_in_function_tuple = '0';

CREATE TABLE unsigned_types
(
    a TINYINT SIGNED,
    b INT1 SIGNED,
    c SMALLINT SIGNED,
    d INT SIGNED,
    e INTEGER SIGNED,
    f BIGINT SIGNED,
    g TINYINT UNSIGNED,
    h INT1 UNSIGNED,
    i SMALLINT UNSIGNED,
    j INT UNSIGNED,
    k INTEGER UNSIGNED,
    l BIGINT UNSIGNED
)
ENGINE = Memory();

SHOW CREATE TABLE unsigned_types;

INSERT INTO unsigned_types (a);

SELECT toTypeName((*,))
FROM unsigned_types
SETTINGS enable_named_columns_in_function_tuple = '0';

SELECT
    CAST('42' AS DOUBLE PRECISION),
    CAST(42 AS NATIONAL CHARACTER VARYING),
    CAST(-1 AS TINYINT UNSIGNED),
    CAST(65535, ' sMaLlInT  signed ');

DROP TABLE multiword_types;

DROP TABLE unsigned_types;