SELECT bitHammingDistance(1, 5);

SELECT bitHammingDistance(100, 100000);

SELECT bitHammingDistance(-1, 1);

DROP TABLE IF EXISTS defaults;

CREATE TABLE defaults
(
    n1 UInt8,
    n2 UInt16,
    n3 UInt32,
    n4 UInt64
)
ENGINE = Memory();

INSERT INTO defaults;

SELECT bitHammingDistance(4, n1)
FROM defaults;

SELECT bitHammingDistance(n2, 100)
FROM defaults;

SELECT bitHammingDistance(n3, n4)
FROM defaults;

DROP TABLE defaults;

DROP TABLE IF EXISTS test_string;

CREATE TABLE test_string
(
    s1 String,
    s2 String,
    s3 FixedString(10),
    s4 FixedString(10)
)
ENGINE = Memory();

INSERT INTO test_string;

SELECT bitHammingDistance('hello', 'hello');

SELECT bitHammingDistance('hello', 'hellow');

SELECT bitHammingDistance(toFixedString('hello', 6), toFixedString('hellow', 6));

SELECT bitHammingDistance(s1, s2)
FROM test_string;

SELECT bitHammingDistance(s3, s4)
FROM test_string;

SELECT bitHammingDistance('hello', s2)
FROM test_string;

SELECT bitHammingDistance(s4, toFixedString('hello', 10))
FROM test_string;

DROP TABLE test_string;