DROP TABLE IF EXISTS map_containsValueLike_test;

CREATE TABLE map_containsValueLike_test
(
    id UInt32,
    map Map(String, String)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '2';

INSERT INTO map_containsValueLike_test;

INSERT INTO map_containsValueLike_test;

INSERT INTO map_containsValueLike_test;

SELECT
    id,
    map
FROM map_containsValueLike_test
WHERE mapContainsValueLike(map, '1-%') = 1;

SELECT
    id,
    map
FROM map_containsValueLike_test
WHERE mapContainsValueLike(map, '3-%') = 0
ORDER BY id ASC;

DROP TABLE map_containsValueLike_test;

SELECT mapContainsValueLike(map('aa', '1', 'bb', '2'), '1%');

SELECT mapContainsValueLike(map('aa', toLowCardinality('1'), 'b', toLowCardinality('2')), '1%');

SELECT mapContainsValueLike(map('aa', '1', 'bb', '2'), materialize('1%'));

SELECT mapContainsValueLike(materialize(map('aa', '1', 'bb', '2')), '1%');

SELECT mapContainsValueLike(materialize(map('aa', '1', 'bb', '2')), materialize('1%'));

SELECT mapContainsValueLike(map('aa', 'cc', 'bb', 'dd'), 'd%');

SELECT mapContainsValueLike(map('aa', 'cc', 'bb', 'dd'), 'q%');

SELECT mapExtractValueLike(map('aa', 'cc', 'bb', 'dd'), 'd%');

SELECT mapExtractValueLike(map('aa', 'cc', 'bb', 'dd'), 'q%');