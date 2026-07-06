-- Tags: no-parallel
CREATE TABLE ttl_01280_error
(
    a Int,
    b Int,
    x Int64,
    y Int64,
    d DateTime
)
ENGINE = MergeTree()
ORDER BY (a, b)
TTL d + toIntervalSecond(1) GROUP BY x SET y = max(y); -- { serverError BAD_TTL_EXPRESSION}

CREATE TABLE ttl_01280_error
(
    a Int,
    b Int,
    x Int64,
    y Int64,
    d DateTime
)
ENGINE = MergeTree()
ORDER BY (a, b)
TTL d + toIntervalSecond(1) GROUP BY b SET y = max(y); -- { serverError BAD_TTL_EXPRESSION}

CREATE TABLE ttl_01280_error
(
    a Int,
    b Int,
    x Int64,
    y Int64,
    d DateTime
)
ENGINE = MergeTree()
ORDER BY (a, b)
TTL d + toIntervalSecond(1) GROUP BY a, b, x SET y = max(y); -- { serverError BAD_TTL_EXPRESSION}

CREATE TABLE ttl_01280_error
(
    a Int,
    b Int,
    x Int64,
    y Int64,
    d DateTime
)
ENGINE = MergeTree()
ORDER BY (a, b)
TTL d + toIntervalSecond(1) GROUP BY a, b SET y = max(y), y = max(y); -- { serverError BAD_TTL_EXPRESSION}