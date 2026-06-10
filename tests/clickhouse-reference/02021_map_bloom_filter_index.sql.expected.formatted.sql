DROP TABLE IF EXISTS map_test_index_map_keys;

CREATE TABLE map_test_index_map_keys
(
    row_id UInt32,
    map Map(String, String),
    INDEX map_bloom_filter_keys mapKeys(map) TYPE bloom_filter() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY row_id
SETTINGS index_granularity = '1';

INSERT INTO map_test_index_map_keys;

SELECT *
FROM map_test_index_map_keys
WHERE map['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE map['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE map['K3'] = '';

SELECT *
FROM map_test_index_map_keys
WHERE map['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE map['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE map['K3'] != '';

SELECT *
FROM map_test_index_map_keys
WHERE map['K0'] IN ('V0')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE map['K2'] IN ('V2')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE map['K3'] IN ('');

SELECT *
FROM map_test_index_map_keys
WHERE map['K0'] NOT IN ('V0')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE map['K2'] NOT IN ('V2')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE map['K3'] NOT IN ('');

SELECT *
FROM map_test_index_map_keys
WHERE mapContains(map, 'K0')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE mapContains(map, 'K2')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE mapContains(map, '');

SELECT *
FROM map_test_index_map_keys
WHERE mapContainsKey(map, 'K0')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE mapContainsKey(map, 'K2')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE mapContainsKey(map, '');

SELECT *
FROM map_test_index_map_keys
WHERE has(map, 'K0')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE has(map, 'K2')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

SELECT *
FROM map_test_index_map_keys
WHERE has(map, '')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_keys';

DROP TABLE map_test_index_map_keys;

DROP TABLE IF EXISTS map_test_index_map_values;

CREATE TABLE map_test_index_map_values
(
    row_id UInt32,
    map Map(String, String),
    INDEX map_bloom_filter_values mapValues(map) TYPE bloom_filter() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY row_id
SETTINGS index_granularity = '1';

INSERT INTO map_test_index_map_values;

SELECT *
FROM map_test_index_map_values
WHERE map['K0'] = 'V0'
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE map['K2'] = 'V2'
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE map['K3'] = '';

SELECT *
FROM map_test_index_map_values
WHERE map['K0'] != 'V0'
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE map['K2'] != 'V2'
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE map['K3'] != '';

SELECT *
FROM map_test_index_map_values
WHERE map['K0'] IN ('V0')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE map['K2'] IN ('V2')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE map['K3'] IN ('');

SELECT *
FROM map_test_index_map_values
WHERE map['K0'] NOT IN ('V0')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE map['K2'] NOT IN ('V2')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE map['K3'] NOT IN ('');

SELECT *
FROM map_test_index_map_values
WHERE mapContainsValue(map, 'V0')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE mapContainsValue(map, 'V2')
SETTINGS force_data_skipping_indices = 'map_bloom_filter_values';

SELECT *
FROM map_test_index_map_values
WHERE mapContainsValue(map, '');

DROP TABLE map_test_index_map_values;