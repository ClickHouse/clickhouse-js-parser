-- Tags: no-parallel-replicas
-- Tests that text indexes can be build on and used with Map columns.
SET enable_analyzer = '1';

SET enable_full_text_index = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt32,
    map Map(String, String),
    map_fixed Map(FixedString(2), String),
    INDEX map_keys_idx mapKeys(map) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX map_fixed_keys_idx mapKeys(map_fixed) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

INSERT INTO tab;

SELECT '-- mapContains support';

SELECT count()
FROM tab
WHERE mapContains(map, 'K0');

SELECT count()
FROM tab
WHERE mapContains(map, 'K1');

SELECT count()
FROM tab
WHERE mapContains(map, 'K2');

SELECT count()
FROM tab
WHERE mapContains(map, 'K3');

SELECT count()
FROM tab
WHERE mapContains(map_fixed, toFixedString('K0', 2));

SELECT count()
FROM tab
WHERE mapContains(map_fixed, toFixedString('K1', 2));

SELECT count()
FROM tab
WHERE mapContains(map_fixed, toFixedString('K2', 2));

SELECT count()
FROM tab
WHERE mapContains(map_fixed, toFixedString('K3', 2));

DROP VIEW IF EXISTS explain_index_mapContains;

CREATE VIEW explain_index_mapContains
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, mapContains(map_fixed, 'placeholder'), mapContains(map, 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

SELECT *
FROM explain_index_mapContains(use_idx_fixed = 0, filter = 'K0');

SELECT *
FROM explain_index_mapContains(use_idx_fixed = 0, filter = 'K2');

SELECT *
FROM explain_index_mapContains(use_idx_fixed = 0, filter = 'K1');

SELECT *
FROM explain_index_mapContains(use_idx_fixed = 0, filter = 'K3');

SELECT *
FROM explain_index_mapContains(use_idx_fixed = 1, filter = toFixedString('K0', 2));

SELECT *
FROM explain_index_mapContains(use_idx_fixed = 1, filter = toFixedString('K2', 2));

SELECT *
FROM explain_index_mapContains(use_idx_fixed = 1, filter = toFixedString('K1', 2));

SELECT *
FROM explain_index_mapContains(use_idx_fixed = 1, filter = toFixedString('K3', 2));

SELECT count()
FROM tab
WHERE map['K0'] = 'V0';

SELECT count()
FROM tab
WHERE map['K1'] = 'V1';

SELECT count()
FROM tab
WHERE map['K2'] = 'V2';

SELECT count()
FROM tab
WHERE map['K3'] = 'V3';

SELECT count()
FROM tab
WHERE map_fixed[toFixedString('K0', 2)] = 'V0';

SELECT count()
FROM tab
WHERE map_fixed[toFixedString('K1', 2)] = 'V1';

SELECT count()
FROM tab
WHERE map_fixed[toFixedString('K2', 2)] = 'V2';

SELECT count()
FROM tab
WHERE map_fixed[toFixedString('K3', 2)] = 'V3';

DROP VIEW IF EXISTS explain_index_equals;

CREATE VIEW explain_index_equals
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, map_fixed['placeholder'] = 'placeholder', map['placeholder'] = 'placeholder')
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

SELECT *
FROM explain_index_equals(use_idx_fixed = 0, filter = 'K0', value = 'V3');

SELECT *
FROM explain_index_equals(use_idx_fixed = 0, filter = 'K2', value = 'V3');

SELECT *
FROM explain_index_equals(use_idx_fixed = 0, filter = 'K1', value = 'V3');

SELECT *
FROM explain_index_equals(use_idx_fixed = 0, filter = 'K3', value = 'V3');

SELECT *
FROM explain_index_equals(use_idx_fixed = 1, filter = 'K0', value = 'V3');

SELECT *
FROM explain_index_equals(use_idx_fixed = 1, filter = 'K2', value = 'V3');

SELECT *
FROM explain_index_equals(use_idx_fixed = 1, filter = 'K1', value = 'V3');

SELECT *
FROM explain_index_equals(use_idx_fixed = 1, filter = 'K3', value = 'V3');

SELECT count()
FROM tab
WHERE has(map, 'K0');

SELECT count()
FROM tab
WHERE has(map, 'K1');

SELECT count()
FROM tab
WHERE has(map, 'K2');

SELECT count()
FROM tab
WHERE has(map, 'K3');

SELECT count()
FROM tab
WHERE has(map_fixed, toFixedString('K0', 2));

SELECT count()
FROM tab
WHERE has(map_fixed, toFixedString('K1', 2));

SELECT count()
FROM tab
WHERE has(map_fixed, toFixedString('K2', 2));

SELECT count()
FROM tab
WHERE has(map_fixed, toFixedString('K3', 2));

DROP VIEW IF EXISTS explain_index_has;

CREATE VIEW explain_index_has
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, has(map_fixed, 'placeholder'), has(map, 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'K0');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'K2');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'K1');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'K3');

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = toFixedString('K0', 2));

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = toFixedString('K2', 2));

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = toFixedString('K1', 2));

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = toFixedString('K3', 2));

SELECT count()
FROM tab
WHERE hasAnyTokens(mapKeys(map), 'K0 K1');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapKeys(map), 'K1 K2');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapKeys(map), 'K2 K3');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapKeys(map), 'K3 K4');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapKeys(map_fixed), 'K0 K1');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapKeys(map_fixed), 'K1 K2');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapKeys(map_fixed), 'K2 K3');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapKeys(map_fixed), 'K3 K4');

DROP VIEW IF EXISTS explain_index_has_any_tokens;

CREATE VIEW explain_index_has_any_tokens
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, hasAnyTokens(mapKeys(map_fixed), 'placeholder'), hasAnyTokens(mapKeys(map), 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'K0 K1');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'K1 K2');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'K2 K3');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'K3 K4');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'K0 K1');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'K1 K2');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'K2 K3');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'K3 K4');

SELECT count()
FROM tab
WHERE hasAllTokens(mapKeys(map), 'K0 K1');

SELECT count()
FROM tab
WHERE hasAllTokens(mapKeys(map), 'K1 K2');

SELECT count()
FROM tab
WHERE hasAllTokens(mapKeys(map), 'K2 K3');

SELECT count()
FROM tab
WHERE hasAllTokens(mapKeys(map), 'K3 K4');

SELECT count()
FROM tab
WHERE hasAllTokens(mapKeys(map_fixed), 'K0 K1');

SELECT count()
FROM tab
WHERE hasAllTokens(mapKeys(map_fixed), 'K1 K2');

SELECT count()
FROM tab
WHERE hasAllTokens(mapKeys(map_fixed), 'K2 K3');

SELECT count()
FROM tab
WHERE hasAllTokens(mapKeys(map_fixed), 'K3 K4');

DROP VIEW IF EXISTS explain_index_has_all_tokens;

CREATE VIEW explain_index_has_all_tokens
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, hasAllTokens(mapKeys(map_fixed), 'placeholder'), hasAllTokens(mapKeys(map), 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'K0 K1');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'K1 K2');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'K2 K3');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'K3 K4');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'K0 K1');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'K1 K2');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'K2 K3');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'K3 K4');

DROP VIEW explain_index_has_any_tokens;

DROP VIEW explain_index_has_all_tokens;

DROP TABLE tab;

CREATE TABLE tab
(
    id UInt32,
    map Map(String, String),
    map_fixed Map(String, FixedString(2)),
    INDEX map_values_idx mapValues(map) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX map_fixed_values_idx mapValues(map_fixed) TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id;

SELECT count()
FROM tab
WHERE map_fixed['K0'] = toFixedString('V0', 2);

SELECT count()
FROM tab
WHERE map_fixed['K1'] = toFixedString('V1', 2);

SELECT count()
FROM tab
WHERE map_fixed['K2'] = toFixedString('V2', 2);

SELECT count()
FROM tab
WHERE map_fixed['K3'] = toFixedString('V3', 2);

SELECT *
FROM explain_index_equals(use_idx_fixed = 0, filter = 'K3', value = 'V0');

SELECT *
FROM explain_index_equals(use_idx_fixed = 0, filter = 'K3', value = 'V2');

SELECT *
FROM explain_index_equals(use_idx_fixed = 0, filter = 'K3', value = 'V1');

SELECT *
FROM explain_index_equals(use_idx_fixed = 1, filter = 'K3', value = toFixedString('V0', 2));

SELECT *
FROM explain_index_equals(use_idx_fixed = 1, filter = 'K3', value = toFixedString('V2', 2));

SELECT *
FROM explain_index_equals(use_idx_fixed = 1, filter = 'K3', value = toFixedString('V1', 2));

SELECT *
FROM explain_index_equals(use_idx_fixed = 1, filter = 'K3', value = toFixedString('V3', 2));

CREATE VIEW explain_index_has
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, has(mapValues(map_fixed), 'placeholder'), has(mapValues(map), 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'V0');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'V2');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'V1');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'V3');

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = 'V0');

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = 'V2');

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = 'V1');

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = 'V3');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapValues(map), 'V0 V1');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapValues(map), 'V1 V2');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapValues(map), 'V2 V3');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapValues(map), 'V3 V4');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapValues(map_fixed), 'V0 V1');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapValues(map_fixed), 'V1 V2');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapValues(map_fixed), 'V2 V3');

SELECT count()
FROM tab
WHERE hasAnyTokens(mapValues(map_fixed), 'V3 V4');

CREATE VIEW explain_index_has_any_tokens
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, hasAnyTokens(mapValues(map_fixed), 'placeholder'), hasAnyTokens(mapValues(map), 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'V0');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'V2');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'V0 V1');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'V3');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'V0');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'V2');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'V0 V1');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'V3');

SELECT count()
FROM tab
WHERE hasAllTokens(mapValues(map), 'V0 V1');

SELECT count()
FROM tab
WHERE hasAllTokens(mapValues(map), 'V1 V2');

SELECT count()
FROM tab
WHERE hasAllTokens(mapValues(map), 'V2 V3');

SELECT count()
FROM tab
WHERE hasAllTokens(mapValues(map), 'V3 V4');

SELECT count()
FROM tab
WHERE hasAllTokens(mapValues(map_fixed), 'V0 V1');

SELECT count()
FROM tab
WHERE hasAllTokens(mapValues(map_fixed), 'V1 V2');

SELECT count()
FROM tab
WHERE hasAllTokens(mapValues(map_fixed), 'V2 V3');

SELECT count()
FROM tab
WHERE hasAllTokens(mapValues(map_fixed), 'V3 V4');

CREATE VIEW explain_index_has_all_tokens
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, hasAllTokens(mapValues(map_fixed), 'placeholder'), hasAllTokens(mapValues(map), 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'V0');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'V2');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'V0 V1');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'V3');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'V0');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'V2');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'V0 V1');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'V3');

CREATE TABLE tab
(
    id UInt32,
    map Map(String, String),
    map_fixed Map(String, FixedString(5)),
    INDEX map_keys mapKeys(map) TYPE text(tokenizer = splitByNonAlpha) GRANULARITY 100000000,
    INDEX map_values mapValues(map) TYPE text(tokenizer = splitByNonAlpha) GRANULARITY 100000000,
    INDEX map_keys_fixed mapKeys(map_fixed) TYPE text(tokenizer = splitByNonAlpha) GRANULARITY 100000000,
    INDEX map_values_fixed mapValues(map_fixed) TYPE text(tokenizer = splitByNonAlpha) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

INSERT INTO tab;

SELECT count()
FROM tab
WHERE mapContainsKeyLike(map, '% b %');

SELECT count()
FROM tab
WHERE mapContainsKeyLike(map, '% h %');

SELECT count()
FROM tab
WHERE mapContainsKeyLike(map, '% n %');

SELECT count()
FROM tab
WHERE mapContainsValueLike(map, '% e %');

SELECT count()
FROM tab
WHERE mapContainsValueLike(map, '% k %');

SELECT count()
FROM tab
WHERE mapContainsValueLike(map, '% q %');

SELECT count()
FROM tab
WHERE mapContainsKeyLike(map_fixed, '% b %');

SELECT count()
FROM tab
WHERE mapContainsKeyLike(map_fixed, '% h %');

SELECT count()
FROM tab
WHERE mapContainsKeyLike(map_fixed, '% n %');

SELECT count()
FROM tab
WHERE mapContainsValueLike(map_fixed, '% e %');

SELECT count()
FROM tab
WHERE mapContainsValueLike(map_fixed, '% k %');

SELECT count()
FROM tab
WHERE mapContainsValueLike(map_fixed, '% q %');

-- 
DROP VIEW IF EXISTS explain_index_key_like;

CREATE VIEW explain_index_key_like
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE mapContainsKeyLike(col, 'placeholder')
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

DROP VIEW IF EXISTS explain_index_value_like;

CREATE VIEW explain_index_value_like
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE mapContainsValueLike(col, 'placeholder')
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2;

SELECT *
FROM explain_index_key_like(col = 'map', pattern = '% b %');

SELECT *
FROM explain_index_key_like(col = 'map', pattern = '% n %');

SELECT *
FROM explain_index_key_like(col = 'map', pattern = '% h %');

SELECT *
FROM explain_index_value_like(col = 'map', pattern = '% e %');

SELECT *
FROM explain_index_value_like(col = 'map', pattern = '% q %');

SELECT *
FROM explain_index_value_like(col = 'map', pattern = '% k %');

SELECT *
FROM explain_index_key_like(col = 'map_fixed', pattern = '% b %');

SELECT *
FROM explain_index_key_like(col = 'map_fixed', pattern = '% n %');

SELECT *
FROM explain_index_key_like(col = 'map_fixed', pattern = '% h %');

SELECT *
FROM explain_index_value_like(col = 'map_fixed', pattern = '% e %');

SELECT *
FROM explain_index_value_like(col = 'map_fixed', pattern = '% q %');

SELECT *
FROM explain_index_value_like(col = 'map_fixed', pattern = '% k %');

DROP VIEW explain_index_mapContains;

DROP VIEW explain_index_equals;

DROP VIEW explain_index_has;

DROP VIEW explain_index_key_like;

DROP VIEW explain_index_value_like;