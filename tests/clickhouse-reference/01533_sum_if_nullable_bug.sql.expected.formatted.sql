DROP TABLE IF EXISTS T;

CREATE TABLE T
(
    a Nullable(Int64)
)
ENGINE = Memory();

INSERT INTO T;

SELECT sumIf(42, a % 2 = 0)
FROM T;

SELECT sumIf(42, a % 2 = 0)
FROM remote('127.0.0.{1,2}', currentDatabase(), T);

SELECT sumIf(42, toNullable(1))
FROM T;

SELECT sumIf(42, toNullable(1))
FROM remote('127.0.0.{1,2}', currentDatabase(), T);