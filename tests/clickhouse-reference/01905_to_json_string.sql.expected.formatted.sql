-- Tags: no-fasttest
CREATE TEMPORARY TABLE t
ENGINE = Memory() AS
SELECT *
FROM generateRandom('\n    a Array(Int8),\n    b UInt32,\n    c Nullable(String),\n    d Decimal32(4),\n    e Nullable(Enum16(''h'' = 1, ''w'' = 5 , ''o'' = -200)),\n    f Float64,\n    g Tuple(Date, DateTime(''Asia/Istanbul''), DateTime64(3, ''Asia/Istanbul''), UUID),\n    h FixedString(2),\n    i Array(Nullable(UUID))\n', 10, 5, 3)
LIMIT 2;

SELECT * APPLY(toJSONString)
FROM t;

SELECT toJSONString(map('1234', '5678'));