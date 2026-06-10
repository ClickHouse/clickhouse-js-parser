CREATE TABLE t
(
    x Array(ab)
)
ENGINE = Memory(); -- { serverError UNKNOWN_TYPE }

CREATE TABLE t
(
    x ab
)
ENGINE = Memory(); -- { serverError UNKNOWN_TYPE }

CREATE TABLE t
(
    x Int64
)
ENGINE = Memory();