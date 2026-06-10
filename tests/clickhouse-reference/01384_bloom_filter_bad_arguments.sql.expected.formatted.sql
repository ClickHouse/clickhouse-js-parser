DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a String,
    INDEX a a TYPE tokenbf_v1(0, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a; -- { serverError BAD_ARGUMENTS }

CREATE TABLE test
(
    a String,
    INDEX a a TYPE tokenbf_v1(2, 0, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a; -- { serverError BAD_ARGUMENTS }

CREATE TABLE test
(
    a String,
    INDEX a a TYPE tokenbf_v1(0, 1, 1) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a; -- { serverError BAD_ARGUMENTS }

CREATE TABLE test
(
    a String,
    INDEX a a TYPE tokenbf_v1(1, 0, 1) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a; -- { serverError BAD_ARGUMENTS }

CREATE TABLE test
(
    a String,
    INDEX a a TYPE tokenbf_v1(0.1, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a; -- { serverError BAD_ARGUMENTS }

CREATE TABLE test
(
    a String,
    INDEX a a TYPE tokenbf_v1(-1, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a; -- { serverError BAD_ARGUMENTS }

CREATE TABLE test
(
    a String,
    INDEX a a TYPE tokenbf_v1(4294967295, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a; -- { serverError BAD_ARGUMENTS }