SET allow_experimental_variant_type = '1';

SET allow_experimental_dynamic_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY d; -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY tuple(d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY array(d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY map('str', d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
PRIMARY KEY d
ORDER BY tuple(); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY d; -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple(d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY array(d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY map('str', d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = MergeTree()
ORDER BY d; -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple(d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = MergeTree()
ORDER BY array(d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = MergeTree()
ORDER BY map('str', d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = MergeTree()
PRIMARY KEY d
ORDER BY tuple(); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY d; -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple(d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY array(d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY map('str', d); -- {serverError DATA_TYPE_CANNOT_BE_USED_IN_KEY}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test SELECT *
FROM numbers(5);

SET enable_analyzer = '1';

SET allow_suspicious_types_in_group_by = '1';

SET allow_suspicious_types_in_order_by = '0';

SELECT *
FROM test
ORDER BY d ASC; -- {serverError ILLEGAL_COLUMN}

SELECT *
FROM test
ORDER BY tuple(d) ASC; -- {serverError ILLEGAL_COLUMN}

SELECT *
FROM test
ORDER BY array(d) ASC; -- {serverError ILLEGAL_COLUMN}

SELECT *
FROM test
ORDER BY map('str', d) ASC; -- {serverError ILLEGAL_COLUMN}

SET allow_suspicious_types_in_group_by = '0';

SET allow_suspicious_types_in_order_by = '1';

SELECT *
FROM test
GROUP BY d; -- {serverError ILLEGAL_COLUMN}

SELECT *
FROM test
GROUP BY tuple(d); -- {serverError ILLEGAL_COLUMN}

SELECT array(d)
FROM test
GROUP BY array(d); -- {serverError ILLEGAL_COLUMN}

SELECT map('str', d)
FROM test
GROUP BY map('str', d); -- {serverError ILLEGAL_COLUMN}

SELECT *
FROM test
GROUP BY GROUPING SETS ((d), ('str')); -- {serverError ILLEGAL_COLUMN}

SELECT *
FROM test
GROUP BY d
ORDER BY `all` ASC;

SELECT *
FROM test
GROUP BY tuple(d)
ORDER BY `all` ASC;

SELECT array(d)
FROM test
GROUP BY array(d)
ORDER BY `all` ASC;

SELECT map('str', d)
FROM test
GROUP BY map('str', d)
ORDER BY `all` ASC;

SELECT *
FROM test
GROUP BY GROUPING SETS ((d), ('str'))
ORDER BY `all` ASC;

SET enable_analyzer = '0';

DROP TABLE test;

CREATE TABLE test
(
    d Variant(UInt64)
)
ENGINE = Memory();