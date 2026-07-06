DROP TABLE IF EXISTS test_wide_nested;

CREATE TABLE test_wide_nested
(
    id Int,
    `info.id` Array(Int),
    `info.name` Array(String),
    `info.age` Array(Int)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0';

SET mutations_sync = '1';

INSERT INTO test_wide_nested SELECT
    number,
    [number, number + 1],
    ['aa', 'bb'],
    [number, number * 2]
FROM numbers(5);

ALTER TABLE test_wide_nested UPDATE `info.id` = [100, 200] WHERE id = 1;

SELECT *
FROM test_wide_nested
WHERE id = 1
ORDER BY id ASC;

ALTER TABLE test_wide_nested UPDATE `info.id` = [100, 200, 300], `info.age` = [10, 20, 30], `info.name` = ['a', 'b', 'c'] WHERE id = 2;

SELECT *
FROM test_wide_nested;

ALTER TABLE test_wide_nested UPDATE `info.id` = [100, 200, 300], `info.age` = `info.id`, `info.name` = ['a', 'b', 'c'] WHERE id = 2;

ALTER TABLE test_wide_nested UPDATE `info.id` = [100, 200], `info.age` = [68, 72] WHERE id = 3;

ALTER TABLE test_wide_nested UPDATE `info.id` = `info.age` WHERE id = 3;

ALTER TABLE test_wide_nested UPDATE `info.id` = [100, 200], `info.age` = [10, 20, 30], `info.name` = ['a', 'b', 'c'] WHERE id = 0; -- { serverError UNFINISHED }

KILL MUTATION WHERE table = 'test_wide_nested'
AND database = currentDatabase() ASYNC FORMAT Null;

DROP TABLE test_wide_nested;

ALTER TABLE test_wide_nested ADD COLUMN `info2.id` Array(Int);

ALTER TABLE test_wide_nested ADD COLUMN `info2.name` Array(String);

ALTER TABLE test_wide_nested UPDATE `info2.id` = `info.id`, `info2.name` = `info.name` WHERE 1;

ALTER TABLE test_wide_nested UPDATE `info.id` = [100, 200, 300], `info.age` = [10, 20, 30] WHERE id = 1; -- { serverError UNFINISHED }

DROP TABLE IF EXISTS test_wide_not_nested;

CREATE TABLE test_wide_not_nested
(
    id Int,
    `info.id` Int,
    `info.name` String,
    `info.age` Int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO test_wide_not_nested SELECT
    number,
    number,
    'aa',
    number * 2
FROM numbers(5);

ALTER TABLE test_wide_not_nested UPDATE `info.name` = 'bb' WHERE id = 1;

SELECT *
FROM test_wide_not_nested
ORDER BY id ASC;

DROP TABLE test_wide_not_nested;