DROP TABLE IF EXISTS bf_tokenbf_map_keys_test;

DROP TABLE IF EXISTS bf_ngrambf_map_keys_test;

CREATE TABLE bf_tokenbf_map_keys_test
(
    row_id UInt32,
    map Map(String, String),
    map_fixed Map(FixedString(2), String),
    INDEX map_keys_tokenbf mapKeys(map) TYPE tokenbf_v1(256, 2, 0) GRANULARITY 1,
    INDEX map_fixed_keys_tokenbf mapKeys(map_fixed) TYPE ngrambf_v1(4, 256, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY row_id
SETTINGS index_granularity = '1';

INSERT INTO bf_tokenbf_map_keys_test;

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_keys_tokenbf';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_keys_tokenbf';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map['K3'] = '';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_keys_tokenbf';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_keys_tokenbf';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map['K3'] != '';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map_fixed['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_fixed_keys_tokenbf';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map_fixed['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_fixed_keys_tokenbf';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map_fixed['K3'] = '';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map_fixed['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_fixed_keys_tokenbf';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map_fixed['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_fixed_keys_tokenbf';

SELECT *
FROM bf_tokenbf_map_keys_test
WHERE map_fixed['K3'] != '';

DROP TABLE bf_tokenbf_map_keys_test;

CREATE TABLE bf_tokenbf_map_values_test
(
    row_id UInt32,
    map Map(String, String),
    map_fixed Map(FixedString(2), String),
    INDEX map_values_tokenbf mapValues(map) TYPE tokenbf_v1(256, 2, 0) GRANULARITY 1,
    INDEX map_fixed_values_tokenbf mapValues(map_fixed) TYPE ngrambf_v1(4, 256, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY row_id
SETTINGS index_granularity = '1';

INSERT INTO bf_tokenbf_map_values_test;

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map['K3'] = '';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map['K3'] != '';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE mapContainsValueLike(map, 'V0')
SETTINGS force_data_skipping_indices = 'map_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE mapContainsValueLike(map, 'V2')
SETTINGS force_data_skipping_indices = 'map_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE NOT mapContainsValueLike(map, 'V0')
SETTINGS force_data_skipping_indices = 'map_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE NOT mapContainsValueLike(map, 'V2')
SETTINGS force_data_skipping_indices = 'map_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map_fixed['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_fixed_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map_fixed['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_fixed_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map_fixed['K3'] = '';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map_fixed['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_fixed_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map_fixed['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_fixed_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE map_fixed['K3'] != '';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE mapContainsValueLike(map_fixed, 'V0%')
SETTINGS force_data_skipping_indices = 'map_fixed_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE mapContainsValueLike(map_fixed, 'V2%')
SETTINGS force_data_skipping_indices = 'map_fixed_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE NOT mapContainsValueLike(map_fixed, 'V0%')
SETTINGS force_data_skipping_indices = 'map_fixed_values_tokenbf';

SELECT *
FROM bf_tokenbf_map_values_test
WHERE NOT mapContainsValueLike(map_fixed, 'V2%')
SETTINGS force_data_skipping_indices = 'map_fixed_values_tokenbf';

DROP TABLE bf_tokenbf_map_values_test;

CREATE TABLE bf_ngrambf_map_keys_test
(
    row_id UInt32,
    map Map(String, String),
    map_fixed Map(FixedString(2), String),
    INDEX map_keys_ngrambf mapKeys(map) TYPE ngrambf_v1(4, 256, 2, 0) GRANULARITY 1,
    INDEX map_fixed_keys_ngrambf mapKeys(map_fixed) TYPE ngrambf_v1(4, 256, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY row_id
SETTINGS index_granularity = '1';

INSERT INTO bf_ngrambf_map_keys_test;

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_keys_ngrambf';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_keys_ngrambf';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map['K3'] = '';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_keys_ngrambf';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_keys_ngrambf';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map['K3'] != '';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map_fixed['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_fixed_keys_ngrambf';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map_fixed['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_fixed_keys_ngrambf';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map_fixed['K3'] = '';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map_fixed['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_fixed_keys_ngrambf';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map_fixed['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_fixed_keys_ngrambf';

SELECT *
FROM bf_ngrambf_map_keys_test
WHERE map_fixed['K3'] != '';

DROP TABLE bf_ngrambf_map_keys_test;

CREATE TABLE bf_ngrambf_map_values_test
(
    row_id UInt32,
    map Map(String, String),
    map_fixed Map(FixedString(2), String),
    INDEX map_values_ngrambf mapKeys(map) TYPE ngrambf_v1(4, 256, 2, 0) GRANULARITY 1,
    INDEX map_fixed_values_ngrambf mapKeys(map_fixed) TYPE ngrambf_v1(4, 256, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY row_id
SETTINGS index_granularity = '1';

INSERT INTO bf_ngrambf_map_values_test;

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_values_ngrambf';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_values_ngrambf';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map['K3'] = '';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_values_ngrambf';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_values_ngrambf';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map['K3'] != '';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map_fixed['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_fixed_values_ngrambf';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map_fixed['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_fixed_values_ngrambf';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map_fixed['K3'] = '';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map_fixed['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_fixed_values_ngrambf';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map_fixed['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_fixed_values_ngrambf';

SELECT *
FROM bf_ngrambf_map_values_test
WHERE map_fixed['K3'] != '';

DROP TABLE bf_ngrambf_map_values_test;