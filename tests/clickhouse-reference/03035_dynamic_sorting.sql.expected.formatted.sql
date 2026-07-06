SET allow_experimental_dynamic_type = '1';

SET allow_suspicious_types_in_order_by = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    d1 Dynamic(max_types = 2),
    d2 Dynamic(max_types = 2)
)
ENGINE = Memory();

INSERT INTO test;

SELECT
    d1,
    dynamicType(d1),
    isDynamicElementInSharedData(d1)
FROM test
ORDER BY d1 ASC NULLS FIRST;

SELECT
    d1,
    dynamicType(d1),
    isDynamicElementInSharedData(d1)
FROM test
ORDER BY d1 ASC NULLS LAST;

SELECT
    d2,
    dynamicType(d2),
    isDynamicElementInSharedData(d2)
FROM test
ORDER BY d2 ASC NULLS FIRST;

SELECT
    d2,
    dynamicType(d2),
    isDynamicElementInSharedData(d2)
FROM test
ORDER BY d2 ASC NULLS LAST;

SELECT
    d1,
    d2,
    dynamicType(d1),
    isDynamicElementInSharedData(d1),
    dynamicType(d2),
    isDynamicElementInSharedData(d2)
FROM test
ORDER BY
    d1 ASC,
    d2 ASC NULLS FIRST;

SELECT
    d1,
    d2,
    dynamicType(d1),
    isDynamicElementInSharedData(d1),
    dynamicType(d2),
    isDynamicElementInSharedData(d2)
FROM test
ORDER BY
    d1 ASC,
    d2 ASC NULLS LAST;

SELECT
    d1,
    d2,
    dynamicType(d1),
    isDynamicElementInSharedData(d1),
    dynamicType(d2),
    isDynamicElementInSharedData(d2)
FROM test
ORDER BY
    d2 ASC,
    d1 ASC NULLS FIRST;

SELECT
    d1,
    d2,
    dynamicType(d1),
    isDynamicElementInSharedData(d1),
    dynamicType(d2),
    isDynamicElementInSharedData(d2)
FROM test
ORDER BY
    d2 ASC,
    d1 ASC NULLS LAST;

DROP TABLE test;