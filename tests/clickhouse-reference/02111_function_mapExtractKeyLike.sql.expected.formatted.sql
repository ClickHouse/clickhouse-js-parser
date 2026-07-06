DROP TABLE IF EXISTS map_extractKeyLike_test;

CREATE TABLE map_extractKeyLike_test
(
    id UInt32,
    map Map(String, String)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '2';

INSERT INTO map_extractKeyLike_test;

INSERT INTO map_extractKeyLike_test;

INSERT INTO map_extractKeyLike_test;

SELECT *
FROM map_extractKeyLike_test
ORDER BY id ASC;

SELECT 'The results of query: SELECT id, mapExtractKeyLike(map, ''P1%'') FROM map_extractKeyLike_test ORDER BY id;';

SELECT
    id,
    mapExtractKeyLike(map, 'P1%')
FROM map_extractKeyLike_test
ORDER BY id ASC;

SELECT 'The results of query: SELECT id, mapExtractKeyLike(map, ''5-K1'') FROM map_extractKeyLike_test ORDER BY id;';

SELECT
    id,
    mapExtractKeyLike(map, '5-K1')
FROM map_extractKeyLike_test
ORDER BY id ASC;

DROP TABLE map_extractKeyLike_test;

SELECT mapExtractKeyLike(map('aa', 1, 'bb', 2), 'a%');

SELECT mapExtractKeyLike(map('aa', 1, 'bb', 2), materialize('a%'));

SELECT mapExtractKeyLike(materialize(map('aa', 1, 'bb', 2)), 'a%');

SELECT mapExtractKeyLike(materialize(map('aa', 1, 'bb', 2)), materialize('a%'));