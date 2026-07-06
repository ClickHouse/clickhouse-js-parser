SET force_primary_key = '1';

DROP TABLE IF EXISTS samples;

CREATE TABLE samples
(
    key UInt32,
    value UInt32
)
ENGINE = MergeTree()
PRIMARY KEY key
ORDER BY key;

INSERT INTO samples;

-- all etries, verify that index is used
SELECT count()
FROM samples
WHERE key IN (range(10));

-- some entries:
SELECT count()
FROM samples
WHERE key IN (arraySlice(range(100), 5, 10));

-- different type
SELECT count()
FROM samples
WHERE toUInt64(key) IN (range(100));

-- should be empty
SELECT count()
FROM samples
WHERE key IN (arraySlice(range(100), 10, 10));

-- not only ints:
SELECT 'a' IN (splitByChar('c', 'abcdef'));

-- non-constant expressions in the right side of IN now work with array-returning functions
SET force_primary_key = '0';

SET enable_analyzer = '1';

SELECT count()
FROM samples
WHERE 1 IN (range(samples.value));

SELECT count()
FROM samples
WHERE 1 IN (range(rand() % 1000 + 2));

-- index is not used
SELECT count()
FROM samples
WHERE value IN (range(3)); -- { serverError INDEX_NOT_USED }

-- wrong type
SELECT 123 IN (splitByChar('c', 'abcdef')); -- { serverError TYPE_MISMATCH }

DROP TABLE samples;