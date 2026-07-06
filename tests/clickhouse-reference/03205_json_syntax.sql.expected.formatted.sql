-- Tags: no-fasttest
SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON
)
ENGINE = Memory();

DROP TABLE test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 10)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(max_dynamic_types = 10)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(a UInt32)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(aaaaa UInt32)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(`a b c d` UInt32)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(`a.b.c` UInt32)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(`aaaa.b.cccc` UInt32)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(`some path.path some` UInt32)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(`a.b.c` Tuple(d UInt32, e UInt32))
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(SKIP a)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(SKIP aaaa)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(SKIP `a b c d`)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(SKIP a.b.c)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(SKIP aaaa.b.cccc)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(SKIP `some path`.`path some`)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(SKIP REGEXP '.*a.*')
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 10, max_dynamic_types = 10, `a.b.c` UInt32, `b.c.d` String, SKIP g.d.a, SKIP o.g.a, SKIP REGEXP '.*u.*', SKIP REGEXP 'abc')
)
ENGINE = Memory();