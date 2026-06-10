-- Tags: no-parallel, log-engine
SET enable_json_type = '1';

SET enable_dynamic_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    d Dynamic
)
ENGINE = Log(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d Dynamic
)
ENGINE = TinyLog(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d Array(Map(String, Dynamic))
)
ENGINE = Log(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d Array(Map(String, Dynamic))
)
ENGINE = TinyLog(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d JSON
)
ENGINE = Log(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d JSON
)
ENGINE = TinyLog(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d Array(Map(String, JSON))
)
ENGINE = Log(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d Array(Map(String, JSON))
)
ENGINE = TinyLog(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d Variant(Int32)
)
ENGINE = Log(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d Variant(Int32)
)
ENGINE = TinyLog(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d Array(Map(String, Variant(Int32)))
)
ENGINE = Log(); -- {serverError ILLEGAL_COLUMN}

CREATE TABLE test
(
    d Array(Map(String, Variant(Int32)))
)
ENGINE = TinyLog(); -- {serverError ILLEGAL_COLUMN}