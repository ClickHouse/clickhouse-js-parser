DROP TABLE IF EXISTS test_numbers__fuzz_29;

SET max_threads = '1', max_insert_threads = '1';

CREATE TABLE test_numbers__fuzz_29
(
    a Array(Nullable(FixedString(19)))
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS allow_nullable_key = '1';

INSERT INTO test_numbers__fuzz_29;

INSERT INTO test_numbers__fuzz_29;

INSERT INTO test_numbers__fuzz_29;

SELECT arraySort(groupArrayIntersect(*))
FROM test_numbers__fuzz_29
GROUP BY a
WITH ROLLUP
ORDER BY `ALL` ASC;

DROP TABLE test_numbers__fuzz_29;