CREATE TEMPORARY TABLE test
(
    _row_exists UInt32
)
ENGINE = MergeTree()
ORDER BY tuple(); -- {serverError ILLEGAL_COLUMN}

CREATE TEMPORARY TABLE test
(
    d Dynamic
)
ENGINE = Log(); -- {serverError ILLEGAL_COLUMN}