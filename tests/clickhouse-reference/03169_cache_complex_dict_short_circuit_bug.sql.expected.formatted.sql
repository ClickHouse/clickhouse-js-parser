DROP TABLE IF EXISTS complex_key_simple_attributes_source_short_circuit_table;

DROP DICTIONARY IF EXISTS cache_dictionary_complex_key_simple_attributes_short_circuit;

CREATE TABLE complex_key_simple_attributes_source_short_circuit_table
(
    id UInt64,
    id_key String,
    value_first String,
    value_second String
)
ENGINE = TinyLog();

INSERT INTO complex_key_simple_attributes_source_short_circuit_table;

CREATE DICTIONARY cache_dictionary_complex_key_simple_attributes_short_circuit
(
    id UInt64,
    id_key String,
    value_first String DEFAULT 'value_first_default',
    value_second String DEFAULT 'value_second_default'
)
PRIMARY KEY id, id_key
SOURCE(clickhouse(TABLE 'complex_key_simple_attributes_source_short_circuit_table'))
LIFETIME(MIN 1 MAX 1000)
LAYOUT(COMPLEX_KEY_CACHE(SIZE_IN_CELLS 10));

SELECT dictGetOrDefault('cache_dictionary_complex_key_simple_attributes_short_circuit', 'value_first', (number, concat(toString(number))), toString(materialize('default'))) AS value_first
FROM `system`.numbers
LIMIT 20
FORMAT Null;