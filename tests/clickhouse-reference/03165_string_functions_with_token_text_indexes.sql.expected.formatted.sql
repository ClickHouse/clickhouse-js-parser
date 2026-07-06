SELECT '-------- Bloom filter --------';

DROP TABLE IF EXISTS `03165_token_bf`;

SET enable_full_text_index = '1';

CREATE TABLE `03165_token_bf`
(
    id Int64,
    message String,
    INDEX idx_message message TYPE tokenbf_v1(32768, 3, 2) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO `03165_token_bf`;

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_bf`
                WHERE startsWith(message, 'Serv')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_bf`
WHERE startsWith(message, 'Serv');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_bf`
                WHERE startsWith(message, 'Serv i')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_bf`
WHERE startsWith(message, 'Serv i');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_bf`
                WHERE endsWith(message, 'eady')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_bf`
WHERE endsWith(message, 'eady');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_bf`
                WHERE endsWith(message, ' eady')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_bf`
WHERE endsWith(message, ' eady');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_bf`
                WHERE match(message, 'no')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_bf`
WHERE match(message, 'no');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_bf`
                WHERE match(message, ' xyz ')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_bf`
WHERE match(message, ' xyz ');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_bf`
                WHERE multiSearchAny(message, ['ce', 'no'])
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_bf`
WHERE multiSearchAny(message, ['ce', 'no']);

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_bf`
                WHERE multiSearchAny(message, [' wx ', ' yz '])
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_bf`
WHERE multiSearchAny(message, [' wx ', ' yz ']);

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_bf`
                WHERE multiSearchAny(message, [' wx ', 'yz'])
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_bf`
WHERE multiSearchAny(message, [' wx ', 'yz']);

SET enable_full_text_index = '1';

DROP TABLE IF EXISTS `03165_token_ft`;

CREATE TABLE `03165_token_ft`
(
    id Int64,
    message String,
    INDEX idx_message message TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO `03165_token_ft`;

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE startsWith(message, 'Serv')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE startsWith(message, 'Serv');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE startsWith(message, 'Serv i')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE startsWith(message, 'Serv i');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE endsWith(message, 'eady')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE endsWith(message, 'eady');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE endsWith(message, ' eady')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE endsWith(message, ' eady');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE match(message, 'no')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE match(message, 'no');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE match(message, ' xyz ')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE match(message, ' xyz ');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE like(message, '%rvice is definitely rea%')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE like(message, '%rvice is definitely rea%');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE like(message, '%rvi%')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE like(message, '%rvi%');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE like(message, '%foo%')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE like(message, '%foo%');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE notLike(message, '%rvice is rea%')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE notLike(message, '%rvice is rea%');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE notLike(message, '%rvice is not rea%')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE notLike(message, '%rvice is not rea%');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE notLike(message, '%ready%')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE notLike(message, '%ready%');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE equals(message, 'Service is not ready')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE equals(message, 'Service is not ready');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE equals(message, 'Service is not rea')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE equals(message, 'Service is not rea');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE notEquals(message, 'Service is not rea')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE notEquals(message, 'Service is not rea');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE notEquals(message, 'Service is not ready')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE notEquals(message, 'Service is not ready');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE hasTokenOrNull(message, 'ready')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE hasTokenOrNull(message, 'ready');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE hasTokenOrNull(message, 'foo')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE hasTokenOrNull(message, 'foo');

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT *
                FROM `03165_token_ft`
                WHERE hasTokenOrNull(message, 'rea dy')
            ))
    )
WHERE `explain` LIKE '%Parts:%';

SELECT *
FROM `03165_token_ft`
WHERE hasTokenOrNull(message, 'rea dy');