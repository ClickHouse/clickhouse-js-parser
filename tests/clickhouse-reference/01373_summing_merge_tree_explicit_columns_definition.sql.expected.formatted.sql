DROP TABLE IF EXISTS tt_error_1373;

CREATE TABLE tt_error_1373
(
    a Int64,
    d Int64,
    val Int64
)
ENGINE = SummingMergeTree((a, val))
ORDER BY d
PARTITION BY a; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tt_error_1373
(
    a Int64,
    d Int64,
    val Int64
)
ENGINE = SummingMergeTree((a, val))
ORDER BY d
PARTITION BY a % 5; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tt_error_1373
(
    a Int64,
    d Int64,
    val Int64
)
ENGINE = SummingMergeTree((d, val))
ORDER BY d
PARTITION BY a; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tt_error_1373
(
    a Int64,
    d Int64,
    val Int64
)
ENGINE = SummingMergeTree((d, val))
ORDER BY d % 5
PARTITION BY a; -- { serverError BAD_ARGUMENTS }