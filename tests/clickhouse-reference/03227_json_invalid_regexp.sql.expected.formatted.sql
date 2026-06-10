SET enable_json_type = '1';

CREATE TABLE test
(
    json JSON(SKIP REGEXP '[]')
)
ENGINE = Memory(); -- {serverError CANNOT_COMPILE_REGEXP}

CREATE TABLE test
(
    json JSON(SKIP REGEXP '+')
)
ENGINE = Memory(); -- {serverError CANNOT_COMPILE_REGEXP};