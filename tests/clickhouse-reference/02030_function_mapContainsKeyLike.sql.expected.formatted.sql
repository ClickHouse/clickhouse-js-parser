DROP TABLE IF EXISTS map_containsKeyLike_test;

CREATE TABLE map_containsKeyLike_test
(
    id UInt32,
    map Map(String, String)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '2';

INSERT INTO map_containsKeyLike_test;

INSERT INTO map_containsKeyLike_test;

INSERT INTO map_containsKeyLike_test;

SELECT
    id,
    map
FROM map_containsKeyLike_test
WHERE mapContainsKeyLike(map, '1-%') = 1;

SELECT
    id,
    map
FROM map_containsKeyLike_test
WHERE mapContainsKeyLike(map, '3-%') = 0
ORDER BY id ASC;

DROP TABLE map_containsKeyLike_test;

SELECT mapContainsKeyLike(map('aa', 1, 'bb', 2), 'a%');

SELECT mapContainsKeyLike(map(toLowCardinality('aa'), 1, toLowCardinality('b'), 2), 'a%');

SELECT mapContainsKeyLike(map('aa', 1, 'bb', 2), materialize('a%'));

SELECT mapContainsKeyLike(materialize(map('aa', 1, 'bb', 2)), 'a%');

SELECT mapContainsKeyLike(materialize(map('aa', 1, 'bb', 2)), materialize('a%'));

SELECT mapContainsKeyLike(map('aa', NULL, 'bb', NULL), 'a%');

SELECT mapContainsKeyLike(map('aa', NULL, 'bb', NULL), 'q%');

SELECT mapExtractKeyLike(map('aa', NULL, 'bb', NULL), 'a%');

SELECT mapExtractKeyLike(map('aa', NULL, 'bb', NULL), 'q%');